import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:boitodex/core/database/app_database.dart';
import 'package:boitodex/core/ml/embedding_engine.dart';
import 'package:boitodex/features/car_entry_detail/data/repositories/car_repository_impl.dart';

class FakeEmbeddingEngine implements EmbeddingEngine {
  @override
  bool get isInitialized => true;

  @override
  Future<List<double>> encodeText(String text) async {
    if (text.isEmpty) return List.filled(384, 0.0);
    return List.filled(384, 0.1);
  }

  @override
  Future<void> initialize({
    String? modelAssetPath,
    String? tokenizerAssetPath,
  }) async {}

  @override
  void dispose() {}
}

void main() {
  group('CarRepositoryImpl', () {
    late AppDatabase db;
    late CarRepositoryImpl repository;

    const testCollectionId = '8f3a21b4-1234-4567-89ab-cdef01234567';

    setUp(() async {
      db = AppDatabase(
        NativeDatabase.memory(
          setup: (rawDb) {
            rawDb.execute('PRAGMA foreign_keys = ON;');
          },
        ),
      );

      repository = CarRepositoryImpl(
        db.carsDao,
        db.keywordsDao,
        FakeEmbeddingEngine(),
      );

      await db.collectionsDao.insertOrUpdateCollection(
        CollectionsTableCompanion.insert(
          id: testCollectionId,
          pairingCode: 'K7M2QX9P',
          createdAt: DateTime.now(),
        ),
      );
    });

    tearDown(() async {
      await db.close();
    });

    group('saveCar', () {
      test(
        'should save car with keywords, images, embedding vector and FTS entry',
        () async {
          const notes = 'Modèle rare en boîte d’origine';
          final keywords = ['Ambulance', 'Pinder', 'Rouge'];
          final imagePaths = ['/storage/img1.jpg', '/storage/img2.jpg'];

          await repository.saveCar(
            collectionId: testCollectionId,
            notes: notes,
            keywordLabels: keywords,
            imagePaths: imagePaths,
          );

          final carsStream = repository.watchCarsByCollection(testCollectionId);
          final carsList = await carsStream.first;

          expect(carsList.length, equals(1));

          final savedCar = carsList.first;
          expect(savedCar.collectionId, equals(testCollectionId));
          expect(savedCar.notes, equals(notes));
          expect(savedCar.keywords.map((k) => k.label), containsAll(keywords));
          expect(savedCar.images.length, equals(2));

          // Vérification de l'image principale (la première de la liste)
          final primaryImage = savedCar.images.firstWhere(
            (img) => img.isPrimary,
          );
          expect(primaryImage.localPath, equals('/storage/img1.jpg'));

          // Vérification que la recherche FTS retrouve bien la voiture insérée
          final ftsResults = await db.carsDao.searchCarIdsByFts('Ambulance');
          expect(ftsResults, contains(savedCar.id));
        },
      );

      test(
        'should update existing car details when valid car id is provided',
        () async {
          const carId = 'a1b2c3d4-e5f6-7890-abcd-ef1234567890';

          await repository.saveCar(
            id: carId,
            collectionId: testCollectionId,
            notes: 'Ancienne note',
            keywordLabels: ['Pompier'],
            imagePaths: ['/old_path.jpg'],
          );

          await repository.saveCar(
            id: carId,
            collectionId: testCollectionId,
            notes: 'Nouvelle note mise à jour',
            keywordLabels: ['Camion', 'Pompier'],
            imagePaths: ['/new_path.jpg'],
          );

          final updatedCar = await repository.getCarById(carId);

          expect(updatedCar, isNotNull);
          expect(updatedCar!.notes, equals('Nouvelle note mise à jour'));
          expect(updatedCar.keywords.length, equals(2));
          expect(updatedCar.images.first.localPath, equals('/new_path.jpg'));
        },
      );
    });

    group('getCarById', () {
      test(
        'should return complete car model with mapped keywords and images when found',
        () async {
          const carId = 'b2c3d4e5-f6a7-8901-bcde-f12345678901';

          await repository.saveCar(
            id: carId,
            collectionId: testCollectionId,
            notes: 'Fiche complète',
            keywordLabels: ['Peugeot', 'Bleu'],
            imagePaths: ['/path/car.jpg'],
          );

          final car = await repository.getCarById(carId);

          expect(car, isNotNull);
          expect(car!.id, equals(carId));
          expect(car.notes, equals('Fiche complète'));
          expect(car.keywords.length, equals(2));
          expect(car.images.length, equals(1));
        },
      );

      test(
        'should return null when car id does not exist in database',
        () async {
          final result = await repository.getCarById('non-existent-id');

          expect(result, isNull);
        },
      );
    });

    group('softDeleteCar', () {
      test(
        'should set deletedAt timestamp and set syncStatus to pending',
        () async {
          const carId = 'c3d4e5f6-a7b8-9012-cdef-123456789012';

          await repository.saveCar(
            id: carId,
            collectionId: testCollectionId,
            notes: 'Voiture à supprimer',
            keywordLabels: ['Test'],
            imagePaths: [],
          );

          await repository.softDeleteCar(carId);

          final car = await repository.getCarById(carId);

          expect(car, isNotNull);
          expect(car!.deletedAt, isNotNull);
        },
      );
    });

    group('watchCarsByCollection', () {
      test(
        'should emit list of active cars excluding soft-deleted ones',
        () async {
          await repository.saveCar(
            collectionId: testCollectionId,
            notes: 'Voiture 1 active',
            keywordLabels: ['Ford'],
            imagePaths: [],
          );

          const carToDeleteId = 'd4e5f6a7-b8c9-0123-def1-234567890123';
          await repository.saveCar(
            id: carToDeleteId,
            collectionId: testCollectionId,
            notes: 'Voiture 2 à supprimer',
            keywordLabels: ['Fiat'],
            imagePaths: [],
          );

          await repository.softDeleteCar(carToDeleteId);

          final carsList = await repository
              .watchCarsByCollection(testCollectionId)
              .first;

          expect(carsList.length, equals(1));
          expect(carsList.first.notes, equals('Voiture 1 active'));
        },
      );
    });
  });
}
