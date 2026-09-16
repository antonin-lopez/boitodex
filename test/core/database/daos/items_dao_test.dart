import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:boitodex/core/database/app_database.dart';
import 'package:boitodex/core/database/daos/items_dao.dart';
import 'package:boitodex/features/sync/domain/models/sync_status.dart';

void main() {
  group('ItemsDao', () {
    late AppDatabase db;
    late ItemsDao itemsDao;

    const testCollectionId = '61a10e59-d60d-4ea8-ae1f-bf8b90ed23e1';

    setUp(() async {
      db = AppDatabase(
        NativeDatabase.memory(
          setup: (rawDb) {
            rawDb.execute('PRAGMA foreign_keys = ON;');
          },
        ),
      );
      itemsDao = db.itemsDao;

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

    group('insertOrUpdateItem', () {
      test('should insert a item and retrieve it by id', () async {
        const itemId = 'd5c9c07d-492b-435d-aa52-138886b50185';

        await itemsDao.insertOrUpdateItem(
          ItemsTableCompanion.insert(
            id: itemId,
            collectionId: testCollectionId,
            notes: const Value('Voiture de collection en parfait état'),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );

        final retrieved = await itemsDao.getItemById(itemId);

        expect(retrieved, isNotNull);
        expect(retrieved!.id, equals(itemId));
        expect(retrieved.collectionId, equals(testCollectionId));
        expect(retrieved.syncStatus, equals(SyncStatus.pending));
      });

      test(
        'should throw SqliteException when inserting with invalid collectionId (FK constraint)',
        () async {
          const invalidItemId = 'c4fa195e-d6d5-4bca-8d16-514b0300f37b';

          expect(
            () => itemsDao.insertOrUpdateItem(
              ItemsTableCompanion.insert(
                id: invalidItemId,
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

    group('searchItemIdsByFts', () {
      const itemId1 = 'd4e9dd85-92da-4a5a-8a14-02d4be8ae864';
      const itemId2 = '3798c716-21f8-4a17-98ac-88d19a64b725';

      setUp(() async {
        await itemsDao.insertOrUpdateItem(
          ItemsTableCompanion.insert(
            id: itemId1,
            collectionId: testCollectionId,
            notes: const Value('Pinder ambulance vintage'),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );
        await itemsDao.upsertFtsEntry(
          itemId: itemId1,
          notes: 'Pinder ambulance vintage',
          keywords: 'Ambulance Rouge Pinder',
        );

        await itemsDao.insertOrUpdateItem(
          ItemsTableCompanion.insert(
            id: itemId2,
            collectionId: testCollectionId,
            notes: const Value('Camion de pompier'),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );
        await itemsDao.upsertFtsEntry(
          itemId: itemId2,
          notes: 'Camion de pompier',
          keywords: 'Pompier Rouge Renault',
        );
      });

      test('should return itemId matching exact term in FTS index', () async {
        final results = await itemsDao.searchItemIdsByFts(
          'Ambulance',
          testCollectionId,
        );

        expect(results, equals([itemId1]));
      });

      test('should return itemId matching prefix term in FTS index', () async {
        final results = await itemsDao.searchItemIdsByFts(
          'Pomp',
          testCollectionId,
        );

        expect(results, equals([itemId2]));
      });

      test(
        'should handle special syntax characters without crashing and still find matching terms',
        () async {
          const queryWithSpecialChars = 'Ambulance" (pinder)*:';

          final results = await itemsDao.searchItemIdsByFts(
            queryWithSpecialChars,
            testCollectionId,
          );

          expect(results, contains(itemId1));
        },
      );

      test(
        'should return empty list when query contains only spaces or special characters',
        () async {
          final results = await itemsDao.searchItemIdsByFts(
            '   * : " ( )  ',
            testCollectionId,
          );

          expect(results, isEmpty);
        },
      );
    });

    group('softDeleteItem', () {
      test(
        'should set deletedAt timestamp and set syncStatus to pending',
        () async {
          const itemId = '53bb9616-b967-4763-9d9e-ed040bf59701';

          await itemsDao.insertOrUpdateItem(
            ItemsTableCompanion.insert(
              id: itemId,
              collectionId: testCollectionId,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              syncStatus: const Value(SyncStatus.pending),
            ),
          );

          await itemsDao.softDeleteItem(itemId);

          final itemAfterDelete = await itemsDao.getItemById(itemId);

          expect(itemAfterDelete, isNotNull);
          expect(itemAfterDelete!.deletedAt, isNotNull);
          expect(itemAfterDelete.syncStatus, equals(SyncStatus.pending));
        },
      );
    });
  });
}
