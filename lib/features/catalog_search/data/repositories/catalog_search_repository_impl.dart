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

    final queryTerms = cleanQuery
        .split(RegExp(r'\s+'))
        .where((term) => term.isNotEmpty)
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

    final resultsMap = <String, SearchResult>{};

    for (final car in domainCarsList) {
      if (ftsCarIds.contains(car.id)) {
        resultsMap[car.id] = SearchResult(
          car: car,
          score: _matchedTermRatio(car, queryTerms),
          isSemanticMatch: false,
        );
        continue;
      }

      final carEmbedding = car.embedding;
      if (carEmbedding != null) {
        final score = cosineSimilarity(queryFloat32, carEmbedding);
        if (score >= CatalogSearchConstants.semanticSearchThreshold) {
          resultsMap[car.id] = SearchResult(
            car: car,
            score: score,
            isSemanticMatch: true,
          );
        }
      }
    }

    final sortedResults = resultsMap.values.toList()
      ..sort((a, b) => b.score.compareTo(a.score));

    return sortedResults;
  }

  double _matchedTermRatio(Car car, List<String> queryTerms) {
    if (queryTerms.isEmpty) return 0.0;

    final notesWords = (car.notes ?? '').toLowerCase().split(RegExp(r'\s+'));
    final keywordWords = car.keywords
        .expand((k) => k.label.toLowerCase().split(RegExp(r'\s+')))
        .toList();

    var matchedCount = 0;
    for (final term in queryTerms) {
      final matches =
          notesWords.any((w) => w.startsWith(term)) ||
          keywordWords.any((w) => w.startsWith(term));
      if (matches) matchedCount++;
    }

    return matchedCount / queryTerms.length;
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
