import 'dart:typed_data';

import 'package:drift/drift.dart';

import 'package:boitodex/core/database/app_database.dart';
import 'package:boitodex/core/database/daos/cars_dao.dart';
import 'package:boitodex/core/database/daos/keywords_dao.dart';
import 'package:boitodex/core/ml/embedding_engine.dart';
import 'package:boitodex/core/utils/uuid_generator.dart';
import 'package:boitodex/features/car/domain/models/car.dart';
import 'package:boitodex/features/car/domain/models/car_image.dart';
import 'package:boitodex/features/car/domain/models/keyword.dart';
import 'package:boitodex/features/car/domain/repositories/car_repository.dart';
import 'package:boitodex/features/sync/domain/models/sync_status.dart';

class CarRepositoryImpl implements CarRepository {
  final CarsDao _carsDao;
  final KeywordsDao _keywordsDao;
  final EmbeddingEngine _embeddingEngine;

  CarRepositoryImpl(this._carsDao, this._keywordsDao, this._embeddingEngine);

  @override
  Future<void> saveCar({
    String? id,
    required String collectionId,
    String? notes,
    required List<String> keywordLabels,
    required List<String> imagePaths,
  }) async {
    final carId = id ?? UuidGenerator.generate();
    final now = DateTime.now();

    final combinedKeywords = keywordLabels.join(' ');
    final textToVectorize = '$combinedKeywords ${notes ?? ''}'.trim();

    Float32List? embedding;
    if (textToVectorize.isNotEmpty) {
      final rawVector = await _embeddingEngine.encodeText(textToVectorize);
      embedding = Float32List.fromList(rawVector);
    }

    await _carsDao.db.transaction(() async {
      final carCompanion = CarsTableCompanion(
        id: Value(carId),
        collectionId: Value(collectionId),
        notes: Value(notes),
        embedding: Value(embedding),
        createdAt: Value(now),
        updatedAt: Value(now),
        syncStatus: const Value(SyncStatus.pending),
      );
      await _carsDao.insertOrUpdateCar(carCompanion);

      await _keywordsDao.linkCarWithKeywords(
        carId: carId,
        collectionId: collectionId,
        keywordLabels: keywordLabels,
      );

      final imageCompanions = <CarImagesTableCompanion>[];
      for (var i = 0; i < imagePaths.length; i++) {
        imageCompanions.add(
          CarImagesTableCompanion.insert(
            id: UuidGenerator.generate(),
            carId: carId,
            localPath: Value(imagePaths[i]),
            isPrimary: Value(i == 0),
            createdAt: now,
            updatedAt: now,
            syncStatus: const Value(SyncStatus.pending),
          ),
        );
      }
      await _carsDao.replaceCarImages(carId: carId, images: imageCompanions);

      await _carsDao.upsertFtsEntry(
        carId: carId,
        notes: notes ?? '',
        keywords: combinedKeywords,
      );
    });
  }

  @override
  Future<Car?> getCarById(String id) async {
    final carData = await _carsDao.getCarById(id);
    if (carData == null) return null;

    final keywordsData = await _keywordsDao.getKeywordsForCar(id);
    final imagesData = await _carsDao.getImagesForCar(id);

    return _toDomain(carData, keywordsData, imagesData);
  }

  @override
  Future<void> softDeleteCar(String carId) async {
    await _carsDao.softDeleteCar(carId);
  }

  @override
  Stream<List<Car>> watchCarsByCollection(String collectionId) {
    return _carsDao.watchCars(collectionId).asyncMap((carList) async {
      if (carList.isEmpty) return [];

      final carIds = carList.map((car) => car.id).toList();

      final Future<Map<String, List<KeywordData>>> keywordsFuture = _keywordsDao
          .getKeywordsForCars(carIds);

      final Future<Map<String, List<CarImageData>>> imagesFuture = _carsDao
          .getImagesForCars(carIds);

      final results = await Future.wait([keywordsFuture, imagesFuture]);
      final keywordsMap = results[0] as Map<String, List<KeywordData>>;
      final imagesMap = results[1] as Map<String, List<CarImageData>>;

      return carList.map((carData) {
        final keywordsData = keywordsMap[carData.id] ?? const [];
        final imagesData = imagesMap[carData.id] ?? const [];

        return _toDomain(carData, keywordsData, imagesData);
      }).toList();
    });
  }
}

Car _toDomain(
  CarData carData,
  List<KeywordData> keywordsData,
  List<CarImageData> imagesData,
) {
  return Car(
    id: carData.id,
    collectionId: carData.collectionId,
    notes: carData.notes,
    keywords: keywordsData
        .map(
          (k) => Keyword(
            id: k.id,
            collectionId: k.collectionId,
            label: k.label,
            createdAt: k.createdAt,
          ),
        )
        .toList(),
    images: imagesData
        .map(
          (img) => CarImage(
            id: img.id,
            carId: img.carId,
            localPath: img.localPath,
            remoteUrl: img.remoteUrl,
            isPrimary: img.isPrimary,
            createdAt: img.createdAt,
            updatedAt: img.updatedAt,
          ),
        )
        .toList(),
    embedding: carData.embedding,
    createdAt: carData.createdAt,
    updatedAt: carData.updatedAt,
    deletedAt: carData.deletedAt,
  );
}
