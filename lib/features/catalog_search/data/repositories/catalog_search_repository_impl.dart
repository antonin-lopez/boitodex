import 'dart:typed_data';

import 'package:boitodex/core/database/daos/cars_dao.dart';
import 'package:boitodex/core/ml/cosine_similarity.dart';
import 'package:boitodex/core/ml/embedding_engine.dart';
import 'package:boitodex/features/car_entry_detail/domain/repositories/car_entry_detail_repository.dart';
import 'package:boitodex/features/catalog_search/domain/models/search_result.dart';
import 'package:boitodex/features/catalog_search/domain/repositories/catalog_search_repository.dart';

class CatalogSearchRepositoryImpl implements CatalogSearchRepository {
  final CarsDao _carsDao;
  final CarEntryDetailRepository _carEntryDetailRepository;
  final EmbeddingEngine _embeddingEngine;

  static const double _semanticThreshold = 0.5;

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
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) return [];

    final ftsCarIds = await _carsDao.searchCarIdsByFts(cleanQuery);
    final resultsMap = <String, SearchResult>{};

    for (final carId in ftsCarIds) {
      final car = await _carEntryDetailRepository.getCarById(carId);
      if (car != null &&
          car.collectionId == collectionId &&
          car.deletedAt == null) {
        resultsMap[car.id] = SearchResult(
          car: car,
          score: 1.0,
          isSemanticMatch: false,
        );
      }
    }

    final queryVector = await _embeddingEngine.encodeText(cleanQuery);
    final queryFloat32 = Float32List.fromList(queryVector);

    final allCars = await _carEntryDetailRepository
        .watchCarsByCollection(collectionId)
        .first;

    for (final car in allCars) {
      if (resultsMap.containsKey(car.id)) continue;

      final carData = await _carsDao.getCarById(car.id);
      final carEmbedding = carData?.embedding;

      if (carEmbedding != null) {
        final score = cosineSimilarity(queryFloat32, carEmbedding);

        if (score >= _semanticThreshold) {
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
}
