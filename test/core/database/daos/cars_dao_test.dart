import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:boitodex/core/database/app_database.dart';
import 'package:boitodex/core/database/daos/cars_dao.dart';
import 'package:boitodex/features/sync/domain/models/sync_status.dart';

void main() {
  group('CarsDao', () {
    late AppDatabase db;
    late CarsDao carsDao;

    const testCollectionId = '61a10e59-d60d-4ea8-ae1f-bf8b90ed23e1';

    setUp(() async {
      db = AppDatabase(
        NativeDatabase.memory(
          setup: (rawDb) {
            rawDb.execute('PRAGMA foreign_keys = ON;');
          },
        ),
      );
      carsDao = db.carsDao;

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

    group('insertOrUpdateCar', () {
      test('should insert a car and retrieve it by id', () async {
        const carId = 'd5c9c07d-492b-435d-aa52-138886b50185';

        await carsDao.insertOrUpdateCar(
          CarsTableCompanion.insert(
            id: carId,
            collectionId: testCollectionId,
            notes: const Value('Voiture de collection en parfait état'),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );

        final retrieved = await carsDao.getCarById(carId);

        expect(retrieved, isNotNull);
        expect(retrieved!.id, equals(carId));
        expect(retrieved.collectionId, equals(testCollectionId));
        expect(retrieved.syncStatus, equals(SyncStatus.pending));
      });

      test(
        'should throw SqliteException when inserting with invalid collectionId (FK constraint)',
        () async {
          const invalidCarId = 'c4fa195e-d6d5-4bca-8d16-514b0300f37b';

          expect(
            () => carsDao.insertOrUpdateCar(
              CarsTableCompanion.insert(
                id: invalidCarId,
                collectionId: '8d0bcc40-07c2-44d2-a445-410f53131ebb',
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              ),
            ),
            throwsA(isA<SqliteException>()),
          );
        },
      );
    });

    group('searchCarIdsByFts', () {
      const carId1 = 'd4e9dd85-92da-4a5a-8a14-02d4be8ae864';
      const carId2 = '3798c716-21f8-4a17-98ac-88d19a64b725';

      setUp(() async {
        await carsDao.insertOrUpdateCar(
          CarsTableCompanion.insert(
            id: carId1,
            collectionId: testCollectionId,
            notes: const Value('Pinder ambulance vintage'),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );
        await carsDao.upsertFtsEntry(
          carId: carId1,
          notes: 'Pinder ambulance vintage',
          keywords: 'Ambulance Rouge Pinder',
        );

        await carsDao.insertOrUpdateCar(
          CarsTableCompanion.insert(
            id: carId2,
            collectionId: testCollectionId,
            notes: const Value('Camion de pompier'),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );
        await carsDao.upsertFtsEntry(
          carId: carId2,
          notes: 'Camion de pompier',
          keywords: 'Pompier Rouge Renault',
        );
      });

      test('should return carId matching exact term in FTS index', () async {
        final results = await carsDao.searchCarIdsByFts(
          'Ambulance',
          testCollectionId,
        );

        expect(results, equals([carId1]));
      });

      test('should return carId matching prefix term in FTS index', () async {
        final results = await carsDao.searchCarIdsByFts(
          'Pomp',
          testCollectionId,
        );

        expect(results, equals([carId2]));
      });

      test(
        'should handle special syntax characters without crashing and still find matching terms',
        () async {
          const queryWithSpecialChars = 'Ambulance" (pinder)*:';

          final results = await carsDao.searchCarIdsByFts(
            queryWithSpecialChars,
            testCollectionId,
          );

          expect(results, contains(carId1));
        },
      );

      test(
        'should return empty list when query contains only spaces or special characters',
        () async {
          final results = await carsDao.searchCarIdsByFts(
            '   * : " ( )  ',
            testCollectionId,
          );

          expect(results, isEmpty);
        },
      );
    });

    group('softDeleteCar', () {
      test(
        'should set deletedAt timestamp and set syncStatus to pending',
        () async {
          const carId = '53bb9616-b967-4763-9d9e-ed040bf59701';

          await carsDao.insertOrUpdateCar(
            CarsTableCompanion.insert(
              id: carId,
              collectionId: testCollectionId,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              syncStatus: const Value(SyncStatus.pending),
            ),
          );

          await carsDao.softDeleteCar(carId);

          final carAfterDelete = await carsDao.getCarById(carId);

          expect(carAfterDelete, isNotNull);
          expect(carAfterDelete!.deletedAt, isNotNull);
          expect(carAfterDelete.syncStatus, equals(SyncStatus.pending));
        },
      );
    });
  });
}
