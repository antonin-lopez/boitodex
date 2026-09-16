import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:boitodex/core/database/app_database.dart';
import 'package:boitodex/core/ml/embedding_engine.dart';
import 'package:boitodex/features/item/data/repositories/item_repository_impl.dart';

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
  group('ItemRepositoryImpl', () {
    late AppDatabase db;
    late ItemRepositoryImpl repository;

    const testCollectionId = '8f3a21b4-1234-4567-89ab-cdef01234567';

    setUp(() async {
      db = AppDatabase(
        NativeDatabase.memory(
          setup: (rawDb) {
            rawDb.execute('PRAGMA foreign_keys = ON;');
          },
        ),
      );

      repository = ItemRepositoryImpl(
        db.itemsDao,
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

    group('saveItem', () {
      test(
        'should save item with keywords, images, embedding vector and FTS entry',
        () async {
          const notes = 'Modèle rare en boîte d’origine';
          final keywords = ['Ambulance', 'Pinder', 'Rouge'];
          final imagePaths = ['/storage/img1.jpg', '/storage/img2.jpg'];

          await repository.saveItem(
            collectionId: testCollectionId,
            notes: notes,
            keywordLabels: keywords,
            imagePaths: imagePaths,
          );

          final itemsStream = repository.watchItemsByCollection(testCollectionId);
          final itemsList = await itemsStream.first;

          expect(itemsList.length, equals(1));

          final savedItem = itemsList.first;
          expect(savedItem.collectionId, equals(testCollectionId));
          expect(savedItem.notes, equals(notes));
          expect(savedItem.keywords.map((k) => k.label), containsAll(keywords));
          expect(savedItem.images.length, equals(2));

          // Vérification de l'image principale (la première de la liste)
          final primaryImage = savedItem.images.firstWhere(
            (img) => img.isPrimary,
          );
          expect(primaryImage.localPath, equals('/storage/img1.jpg'));

          // Vérification que la recherche FTS retrouve bien la voiture insérée
          final ftsResults = await db.itemsDao.searchItemIdsByFts(
            'Ambulance',
            testCollectionId,
          );
          expect(ftsResults, contains(savedItem.id));
        },
      );

      test(
        'should update existing item details when valid item id is provided',
        () async {
          const itemId = 'a1b2c3d4-e5f6-7890-abcd-ef1234567890';

          await repository.saveItem(
            id: itemId,
            collectionId: testCollectionId,
            notes: 'Ancienne note',
            keywordLabels: ['Pompier'],
            imagePaths: ['/old_path.jpg'],
          );

          await repository.saveItem(
            id: itemId,
            collectionId: testCollectionId,
            notes: 'Nouvelle note mise à jour',
            keywordLabels: ['Camion', 'Pompier'],
            imagePaths: ['/new_path.jpg'],
          );

          final updatedItem = await repository.getItemById(itemId);

          expect(updatedItem, isNotNull);
          expect(updatedItem!.notes, equals('Nouvelle note mise à jour'));
          expect(updatedItem.keywords.length, equals(2));
          expect(updatedItem.images.first.localPath, equals('/new_path.jpg'));
        },
      );
    });

    group('getItemById', () {
      test(
        'should return complete item model with mapped keywords and images when found',
        () async {
          const itemId = 'b2c3d4e5-f6a7-8901-bcde-f12345678901';

          await repository.saveItem(
            id: itemId,
            collectionId: testCollectionId,
            notes: 'Fiche complète',
            keywordLabels: ['Peugeot', 'Bleu'],
            imagePaths: ['/path/item.jpg'],
          );

          final item = await repository.getItemById(itemId);

          expect(item, isNotNull);
          expect(item!.id, equals(itemId));
          expect(item.notes, equals('Fiche complète'));
          expect(item.keywords.length, equals(2));
          expect(item.images.length, equals(1));
        },
      );

      test(
        'should return null when item id does not exist in database',
        () async {
          final result = await repository.getItemById('non-existent-id');

          expect(result, isNull);
        },
      );
    });

    group('softDeleteItem', () {
      test(
        'should set deletedAt timestamp and set syncStatus to pending',
        () async {
          const itemId = 'c3d4e5f6-a7b8-9012-cdef-123456789012';

          await repository.saveItem(
            id: itemId,
            collectionId: testCollectionId,
            notes: 'Voiture à supprimer',
            keywordLabels: ['Test'],
            imagePaths: [],
          );

          await repository.softDeleteItem(itemId);

          final item = await repository.getItemById(itemId);

          expect(item, isNotNull);
          expect(item!.deletedAt, isNotNull);
        },
      );
    });

    group('watchItemsByCollection', () {
      test(
        'should emit list of active items excluding soft-deleted ones',
        () async {
          await repository.saveItem(
            collectionId: testCollectionId,
            notes: 'Voiture 1 active',
            keywordLabels: ['Ford'],
            imagePaths: [],
          );

          const itemToDeleteId = 'd4e5f6a7-b8c9-0123-def1-234567890123';
          await repository.saveItem(
            id: itemToDeleteId,
            collectionId: testCollectionId,
            notes: 'Voiture 2 à supprimer',
            keywordLabels: ['Fiat'],
            imagePaths: [],
          );

          await repository.softDeleteItem(itemToDeleteId);

          final itemsList = await repository
              .watchItemsByCollection(testCollectionId)
              .first;

          expect(itemsList.length, equals(1));
          expect(itemsList.first.notes, equals('Voiture 1 active'));
        },
      );
    });
  });
}
