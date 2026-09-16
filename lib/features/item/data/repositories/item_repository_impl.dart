import 'dart:typed_data';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'package:boitodex/core/database/app_database.dart';
import 'package:boitodex/core/database/daos/items_dao.dart';
import 'package:boitodex/core/database/daos/keywords_dao.dart';
import 'package:boitodex/core/ml/embedding_engine.dart';
import 'package:boitodex/features/item/domain/models/item.dart';
import 'package:boitodex/features/item/domain/models/item_image.dart';
import 'package:boitodex/features/item/domain/models/keyword.dart';
import 'package:boitodex/features/item/domain/repositories/item_repository.dart';
import 'package:boitodex/features/sync/domain/models/sync_status.dart';

/// Implementation of [ItemRepository] backed by Drift DAOs and local embeddings.
class ItemRepositoryImpl implements ItemRepository {
  final ItemsDao _itemsDao;
  final KeywordsDao _keywordsDao;
  final EmbeddingEngine _embeddingEngine;

  ItemRepositoryImpl(this._itemsDao, this._keywordsDao, this._embeddingEngine);

  @override
  Future<void> saveItem({
    String? id,
    required String collectionId,
    String? notes,
    required List<String> keywordLabels,
    required List<String> imagePaths,
  }) async {
    final itemId = id ?? const Uuid().v4();
    final now = DateTime.now();

    final combinedKeywords = keywordLabels.join(' ');
    final textToVectorize = '$combinedKeywords ${notes ?? ''}'.trim();

    Float32List? embedding;
    if (textToVectorize.isNotEmpty) {
      final rawVector = await _embeddingEngine.encodeText(textToVectorize);
      embedding = Float32List.fromList(rawVector);
    }

    await _itemsDao.db.transaction(() async {
      // Vérifie l'existence réelle en base (permet aux tests d'insérer avec un id imposé)
      final existingItem = await _itemsDao.getItemById(itemId);
      final isNew = existingItem == null;

      final itemCompanion = ItemsTableCompanion(
        id: Value(itemId),
        collectionId: Value(collectionId),
        notes: Value(notes),
        embedding: Value(embedding),
        createdAt: isNew ? Value(now) : Value(existingItem.createdAt),
        updatedAt: Value(now),
        syncStatus: const Value(SyncStatus.pending),
      );

      if (isNew) {
        await _itemsDao.insertOrUpdateItem(itemCompanion);
      } else {
        await (_itemsDao.update(
          _itemsDao.itemsTable,
        )..where((tbl) => tbl.id.equals(itemId))).write(itemCompanion);
      }

      await _keywordsDao.linkItemWithKeywords(
        itemId: itemId,
        collectionId: collectionId,
        keywordLabels: keywordLabels,
      );

      final imageCompanions = <ItemImagesTableCompanion>[];
      for (var i = 0; i < imagePaths.length; i++) {
        imageCompanions.add(
          ItemImagesTableCompanion.insert(
            id: const Uuid().v4(),
            itemId: itemId,
            localPath: Value(imagePaths[i]),
            isPrimary: Value(i == 0),
            createdAt: now,
            updatedAt: now,
            syncStatus: const Value(SyncStatus.pending),
          ),
        );
      }
      await _itemsDao.replaceItemImages(
        itemId: itemId,
        images: imageCompanions,
      );

      await _itemsDao.upsertFtsEntry(
        itemId: itemId,
        notes: notes ?? '',
        keywords: combinedKeywords,
      );
    });
  }

  @override
  Future<Item?> getItemById(String id) async {
    final itemData = await _itemsDao.getItemById(id);
    if (itemData == null) return null;

    final keywordsData = await _keywordsDao.getKeywordsForItem(id);
    final imagesData = await _itemsDao.getImagesForItem(id);

    return _toDomain(itemData, keywordsData, imagesData);
  }

  @override
  Future<void> softDeleteItem(String itemId) =>
      _itemsDao.softDeleteItem(itemId);

  @override
  Stream<List<Item>> watchItemsByCollection(String collectionId) {
    return _itemsDao.watchItems(collectionId).asyncMap((itemList) async {
      if (itemList.isEmpty) return const [];

      final itemIds = itemList.map((item) => item.id).toList();

      // Parallel fetch using Dart 3 typed record wait.
      final (keywordsMap, imagesMap) = await (
        _keywordsDao.getKeywordsForItems(itemIds),
        _itemsDao.getImagesForItems(itemIds),
      ).wait;

      return itemList.map((itemData) {
        final keywordsData = keywordsMap[itemData.id] ?? const [];
        final imagesData = imagesMap[itemData.id] ?? const [];

        return _toDomain(itemData, keywordsData, imagesData);
      }).toList();
    });
  }
}

/// Maps Drift database rows to the domain [Item] model.
Item _toDomain(
  ItemData itemData,
  List<KeywordData> keywordsData,
  List<ItemImageData> imagesData,
) {
  return Item(
    id: itemData.id,
    collectionId: itemData.collectionId,
    notes: itemData.notes,
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
          (img) => ItemImage(
            id: img.id,
            itemId: img.itemId,
            localPath: img.localPath,
            remoteUrl: img.remoteUrl,
            isPrimary: img.isPrimary,
            createdAt: img.createdAt,
            updatedAt: img.updatedAt,
          ),
        )
        .toList(),
    embedding: itemData.embedding,
    createdAt: itemData.createdAt,
    updatedAt: itemData.updatedAt,
    deletedAt: itemData.deletedAt,
  );
}
