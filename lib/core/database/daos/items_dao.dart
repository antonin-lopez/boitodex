import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/item_images_table.dart';
import '../tables/item_keywords_table.dart';
import '../tables/items_table.dart';
import 'package:boitodex/features/sync/domain/models/sync_status.dart';

part 'items_dao.g.dart';

@DriftAccessor(tables: [ItemsTable, ItemImagesTable, ItemKeywordsTable])
class ItemsDao extends DatabaseAccessor<AppDatabase> with _$ItemsDaoMixin {
  ItemsDao(super.db);

  Stream<List<ItemData>> watchItems(String collectionId) {
    final query =
        select(itemsTable).join([
            leftOuterJoin(
              itemKeywordsTable,
              itemKeywordsTable.itemId.equalsExp(itemsTable.id),
            ),
            leftOuterJoin(
              itemImagesTable,
              itemImagesTable.itemId.equalsExp(itemsTable.id),
            ),
          ])
          ..where(
            itemsTable.collectionId.equals(collectionId) &
                itemsTable.deletedAt.isNull(),
          )
          ..orderBy([OrderingTerm.desc(itemsTable.createdAt)]);

    return query.watch().map((rows) {
      final seenIds = <String>{};
      final items = <ItemData>[];
      for (final row in rows) {
        final item = row.readTable(itemsTable);
        if (seenIds.add(item.id)) items.add(item);
      }
      return items;
    });
  }

  Future<List<ItemData>> getItemsByCollection(String collectionId) {
    return (select(itemsTable)
          ..where(
            (tbl) =>
                tbl.collectionId.equals(collectionId) & tbl.deletedAt.isNull(),
          )
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]))
        .get();
  }

  Future<ItemData?> getItemById(String id) {
    return (select(
      itemsTable,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<List<String>> searchItemIdsByFts(
    String query,
    String collectionId,
  ) async {
    final sanitized = query
        .replaceAll(RegExp(r'[^\w\s]', unicode: true), ' ')
        .trim();

    if (sanitized.isEmpty) return [];

    final formattedQuery = sanitized
        .split(RegExp(r'\s+'))
        .where((term) => term.isNotEmpty)
        .map((term) => '"$term"*')
        .join(' OR ');

    return db.searchItemsByText(formattedQuery, collectionId).get();
  }

  Future<void> insertOrUpdateItem(ItemsTableCompanion item) {
    return into(itemsTable).insertOnConflictUpdate(item);
  }

  Future<void> softDeleteItem(String itemId) {
    return (update(itemsTable)..where((tbl) => tbl.id.equals(itemId))).write(
      ItemsTableCompanion(
        deletedAt: Value(DateTime.now()),
        syncStatus: const Value(SyncStatus.pending),
      ),
    );
  }

  Future<void> upsertFtsEntry({
    required String itemId,
    required String notes,
    required String keywords,
  }) async {
    await customStatement('DELETE FROM items_fts WHERE item_id = ?', [itemId]);
    await customInsert(
      'INSERT INTO items_fts (item_id, notes, keywords) VALUES (?, ?, ?)',
      variables: [
        Variable.withString(itemId),
        Variable.withString(notes),
        Variable.withString(keywords),
      ],
    );
  }

  Future<List<ItemImageData>> getImagesForItem(String itemId) {
    return (select(
      itemImagesTable,
    )..where((tbl) => tbl.itemId.equals(itemId) & tbl.deletedAt.isNull())).get();
  }

  Future<Map<String, List<ItemImageData>>> getImagesForItems(
    List<String> itemIds,
  ) async {
    if (itemIds.isEmpty) return {};

    final rows = await (select(
      itemImagesTable,
    )..where((tbl) => tbl.itemId.isIn(itemIds) & tbl.deletedAt.isNull())).get();

    final map = <String, List<ItemImageData>>{};
    for (final row in rows) {
      map.putIfAbsent(row.itemId, () => []).add(row);
    }
    return map;
  }

  Future<void> replaceItemImages({
    required String itemId,
    required List<ItemImagesTableCompanion> images,
  }) async {
    await (delete(
      itemImagesTable,
    )..where((tbl) => tbl.itemId.equals(itemId))).go();

    for (final image in images) {
      await into(itemImagesTable).insertOnConflictUpdate(image);
    }
  }
}
