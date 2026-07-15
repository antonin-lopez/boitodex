import 'dart:typed_data';

import 'package:boitodex/core/database/daos/cars_dao.dart';
import 'package:boitodex/core/ml/cosine_similarity.dart';
import 'package:boitodex/core/ml/embedding_engine.dart';
import 'package:boitodex/features/car/domain/models/car.dart';
import 'package:boitodex/features/car/domain/repositories/car_repository.dart';
import 'package:boitodex/features/catalog_search/domain/constants/catalog_search_constants.dart';
import 'package:boitodex/features/catalog_search/domain/models/search_result.dart';
import 'package:boitodex/features/catalog_search/domain/repositories/catalog_search_repository.dart';

class CatalogSearchRepositoryImpl implements CatalogSearchRepository {
  final CarsDao _carsDao;
  final CarRepository _carRepository;
  final EmbeddingEngine _embeddingEngine;

  final Map<String, Float32List> _queryEmbeddingCache = {};

  CatalogSearchRepositoryImpl(
    this._carsDao,
    this._carRepository,
    this._embeddingEngine,
  );

  @override
  Future<List<SearchResult>> searchCars({
    required String query,
    required String collectionId,
  }) async {
    final cleanQuery = query.trim().toLowerCase();
    if (cleanQuery.isEmpty) return [];

    final hasSearchableContent = cleanQuery
        .replaceAll(RegExp(r'[^\w\s]', unicode: true), '')
        .trim()
        .isNotEmpty;
    if (!hasSearchableContent) return [];

    final queryTerms = cleanQuery
        .split(RegExp(r'\s+'))
        .where((term) => term.isNotEmpty)
        .map(_normalizeForMatching)
        .toList();

    final ftsTask = _carsDao.searchCarIdsByFts(cleanQuery);
    final domainCarsTask = _carRepository
        .watchCarsByCollection(collectionId)
        .first;
    final queryVectorTask = _getOrComputeQueryEmbedding(cleanQuery);

    final results = await Future.wait([
      ftsTask,
      domainCarsTask,
      queryVectorTask,
    ]);

    final ftsCarIds = (results[0] as List<String>).toSet();
    final domainCarsList = results[1] as List<Car>;
    final queryFloat32 = results[2] as Float32List;

    final centroid = _computeCentroid(domainCarsList);

    final resultsMap = <String, SearchResult>{};

    for (final car in domainCarsList) {
      // On calcule TOUJOURS le score FTS s'il existe ET le score sémantique
      // s'il existe, plutôt que de court-circuiter dès qu'un match FTS est
      // trouvé. Un match FTS sur un seul terme parmi plusieurs peut donner
      // un ratio faible (ex: 1 mot sur 4 = 0.25) alors que le contenu est
      // en réalité très pertinent sémantiquement. On garde le meilleur des
      // deux signaux plutôt que de figer arbitrairement sur le premier
      // trouvé.
      final double? ftsScore = ftsCarIds.contains(car.id)
          ? _matchedTermRatio(car, queryTerms)
          : null;

      double? semanticScore;
      final carEmbedding = car.embedding;
      if (carEmbedding != null) {
        semanticScore = centroid == null
            ? cosineSimilarity(queryFloat32, carEmbedding)
            : cosineSimilarity(
                _center(queryFloat32, centroid),
                _center(carEmbedding, centroid),
              );
      }

      // Le score sémantique ne "gagne" que s'il dépasse strictement le
      // score FTS ET franchit le seuil de confiance minimal. En cas
      // d'égalité, on privilégie le match FTS (exact/lexical), plus fiable
      // à score équivalent qu'une similarité vectorielle approximative.
      final semanticIsBetter =
          semanticScore != null &&
          semanticScore >= CatalogSearchConstants.semanticSearchThreshold &&
          (ftsScore == null || semanticScore > ftsScore);

      if (semanticIsBetter) {
        resultsMap[car.id] = SearchResult(
          car: car,
          score: semanticScore!,
          isSemanticMatch: true,
        );
      } else if (ftsScore != null) {
        resultsMap[car.id] = SearchResult(
          car: car,
          score: ftsScore,
          isSemanticMatch: false,
        );
      }
      // Sinon : ni FTS ni seuil sémantique atteint -> voiture exclue.
    }

    final sortedResults = resultsMap.values.toList()
      ..sort((a, b) => b.score.compareTo(a.score));

    return sortedResults;
  }

  double _matchedTermRatio(Car car, List<String> queryTerms) {
    if (queryTerms.isEmpty) return 0.0;

    final notesWords = (car.notes ?? '')
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .map(_normalizeForMatching);
    final keywordWords = car.keywords
        .expand((k) => k.label.toLowerCase().split(RegExp(r'\s+')))
        .map(_normalizeForMatching);

    var matchedCount = 0;
    for (final term in queryTerms) {
      final matches =
          notesWords.any((w) => w.startsWith(term)) ||
          keywordWords.any((w) => w.startsWith(term));
      if (matches) matchedCount++;
    }

    return matchedCount / queryTerms.length;
  }

  String _normalizeForMatching(String input) {
    const withDiacritics =
        'àáâãäåòóôõöøèéêëçðìíîïùúûüñšÿýžÀÁÂÃÄÅÒÓÔÕÖØÈÉÊËÇÐÌÍÎÏÙÚÛÜÑŠŸÝŽ';
    const withoutDiacritics =
        'aaaaaaooooooeeeecdiiiiuuuunsyyzAAAAAAOOOOOOEEEECDIIIIUUUUNSYYZ';

    final buffer = StringBuffer();
    for (final rune in input.runes) {
      final char = String.fromCharCode(rune);
      final index = withDiacritics.indexOf(char);
      buffer.write(index == -1 ? char : withoutDiacritics[index]);
    }
    return buffer.toString();
  }

  Float32List? _computeCentroid(List<Car> cars) {
    final embeddings = cars
        .map((c) => c.embedding)
        .whereType<Float32List>()
        .toList();
    if (embeddings.length < 2) return null;

    final dim = embeddings.first.length;
    final centroid = Float32List(dim);
    for (final embedding in embeddings) {
      for (var i = 0; i < dim; i++) {
        centroid[i] += embedding[i];
      }
    }
    for (var i = 0; i < dim; i++) {
      centroid[i] /= embeddings.length;
    }
    return centroid;
  }

  Float32List _center(Float32List vector, Float32List centroid) {
    final result = Float32List(vector.length);
    for (var i = 0; i < vector.length; i++) {
      result[i] = vector[i] - centroid[i];
    }
    return result;
  }

  Future<Float32List> _getOrComputeQueryEmbedding(String query) async {
    final cached = _queryEmbeddingCache[query];
    if (cached != null) return cached;

    final queryVector = await _embeddingEngine.encodeText(query);
    final float32Vector = Float32List.fromList(queryVector);

    if (_queryEmbeddingCache.length >= CatalogSearchConstants.maxCacheSize) {
      _queryEmbeddingCache.remove(_queryEmbeddingCache.keys.first);
    }
    _queryEmbeddingCache[query] = float32Vector;

    return float32Vector;
  }
}
