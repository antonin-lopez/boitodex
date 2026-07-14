import 'dart:typed_data';

import 'package:boitodex/core/constants/app_constants.dart';
import 'package:boitodex/core/database/app_database.dart';
import 'package:boitodex/core/database/daos/cars_dao.dart';
import 'package:boitodex/core/ml/cosine_similarity.dart';
import 'package:boitodex/core/ml/embedding_engine.dart';
import 'package:boitodex/features/car_entry_detail/domain/models/car.dart';
import 'package:boitodex/features/car_entry_detail/domain/repositories/car_entry_detail_repository.dart';
import 'package:boitodex/features/catalog_search/domain/models/search_result.dart';
import 'package:boitodex/features/catalog_search/domain/repositories/catalog_search_repository.dart';

class CatalogSearchRepositoryImpl implements CatalogSearchRepository {
  final CarsDao _carsDao;
  final CarEntryDetailRepository _carEntryDetailRepository;
  final EmbeddingEngine _embeddingEngine;

  final Map<String, Float32List> _queryEmbeddingCache = {};
  static const int _maxCacheSize = 50;

  CatalogSearchRepositoryImpl(
    this._carsDao,
    this._carEntryDetailRepository,
    this._embeddingEngine,
  );

  @override
  Future<List<SearchResult>> searchCars({
    required String query,
    required String collectionId,
  }) async {
    final cleanQuery = query.trim().toLowerCase();
    if (cleanQuery.isEmpty) return [];

    final ftsTask = _carsDao.searchCarIdsByFts(cleanQuery);
    final rawCarsTask = _carsDao.getCarsByCollection(collectionId);
    final domainCarsTask = _carEntryDetailRepository
        .watchCarsByCollection(collectionId)
        .first;
    final queryVectorTask = _getOrComputeQueryEmbedding(cleanQuery);

    final results = await Future.wait([
      ftsTask,
      rawCarsTask,
      domainCarsTask,
      queryVectorTask,
    ]);

    final ftsCarIds = (results[0] as List<String>).toSet();
    final rawCarsList = results[1] as List<CarData>;
    final domainCarsList = results[2] as List<Car>;
    final queryFloat32 = results[3] as Float32List;

    final embeddingsMap = <String, Float32List>{
      for (final raw in rawCarsList)
        if (raw.embedding != null) raw.id: raw.embedding!,
    };

    final resultsMap = <String, SearchResult>{};

    for (final car in domainCarsList) {
      if (car.collectionId != collectionId || car.deletedAt != null) continue;

      if (ftsCarIds.contains(car.id)) {
        resultsMap[car.id] = SearchResult(
          car: car,
          score: 1.0,
          isSemanticMatch: false,
        );
        continue;
      }

      final carEmbedding = embeddingsMap[car.id];
      if (carEmbedding != null) {
        final score = cosineSimilarity(queryFloat32, carEmbedding);
        if (score >= AppConstants.semanticSearchThreshold) {
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

  Future<Float32List> _getOrComputeQueryEmbedding(String query) async {
    final cached = _queryEmbeddingCache[query];
    if (cached != null) return cached;

    final queryVector = await _embeddingEngine.encodeText(query);
    final float32Vector = Float32List.fromList(queryVector);

    if (_queryEmbeddingCache.length >= _maxCacheSize) {
      _queryEmbeddingCache.remove(_queryEmbeddingCache.keys.first);
    }
    _queryEmbeddingCache[query] = float32Vector;

    return float32Vector;
  }
}
