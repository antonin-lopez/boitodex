import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../app_database.dart';
import '../tables/item_keywords_table.dart';
import '../tables/keywords_table.dart';

part 'keywords_dao.g.dart';

/// Data access object for managing keywords and item associations.
@DriftAccessor(tables: [KeywordsTable, ItemKeywordsTable])
class KeywordsDao extends DatabaseAccessor<AppDatabase>
    with _$KeywordsDaoMixin {
  KeywordsDao(super.db);

  /// Watches all keywords for a given collection, sorted alphabetically.
  Stream<List<KeywordData>> watchKeywordsByCollection(String collectionId) {
    return (select(keywordsTable)
          ..where((tbl) => tbl.collectionId.equals(collectionId))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.label)]))
        .watch();
  }

  /// Inserts a keyword or updates it if a primary key conflict occurs.
  Future<void> insertOrUpdateKeyword(KeywordsTableCompanion keyword) {
    return into(keywordsTable).insertOnConflictUpdate(keyword);
  }

  /// Retrieves all keywords linked to a specific item.
  Future<List<KeywordData>> getKeywordsForItem(String itemId) async {
    final query =
        select(itemKeywordsTable).join([
            innerJoin(
              keywordsTable,
              keywordsTable.id.equalsExp(itemKeywordsTable.keywordId),
            ),
          ])
          ..where(itemKeywordsTable.itemId.equals(itemId))
          ..orderBy([OrderingTerm.asc(keywordsTable.label)]);

    final rows = await query.get();
    return rows.map((row) => row.readTable(keywordsTable)).toList();
  }

  /// Batch-loads keywords for multiple items to prevent N+1 queries.
  Future<Map<String, List<KeywordData>>> getKeywordsForItems(
    List<String> itemIds,
  ) async {
    if (itemIds.isEmpty) return {};

    final query =
        select(itemKeywordsTable).join([
            innerJoin(
              keywordsTable,
              keywordsTable.id.equalsExp(itemKeywordsTable.keywordId),
            ),
          ])
          ..where(itemKeywordsTable.itemId.isIn(itemIds))
          ..orderBy([OrderingTerm.asc(keywordsTable.label)]);

    final rows = await query.get();

    final map = <String, List<KeywordData>>{};
    for (final row in rows) {
      final itemId = row.readTable(itemKeywordsTable).itemId;
      final keyword = row.readTable(keywordsTable);

      map.putIfAbsent(itemId, () => []).add(keyword);
    }
    return map;
  }

  /// Finds an existing keyword by label within a collection.
  Future<KeywordData?> getKeywordByLabel(String collectionId, String label) {
    return (select(keywordsTable)..where(
          (tbl) =>
              tbl.collectionId.equals(collectionId) &
              tbl.label.collate(Collate.noCase).equals(label),
        ))
        .getSingleOrNull();
  }

  /// Atomically updates a item's keyword associations.
  Future<void> linkItemWithKeywords({
    required String itemId,
    required String collectionId,
    required List<String> keywordLabels,
  }) {
    return transaction(() async {
      // Normalize and deduplicate inputs.
      final cleanedLabels = keywordLabels
          .map((label) => label.trim())
          .where((label) => label.isNotEmpty)
          .toSet();

      // Remove existing associations.
      await (delete(
        itemKeywordsTable,
      )..where((tbl) => tbl.itemId.equals(itemId))).go();

      if (cleanedLabels.isEmpty) return;

      // Ensure keywords exist and create join entries.
      for (final label in cleanedLabels) {
        var keyword = await getKeywordByLabel(collectionId, label);
        var keywordId = keyword?.id;

        if (keywordId == null) {
          keywordId = const Uuid().v4();
          await insertOrUpdateKeyword(
            KeywordsTableCompanion.insert(
              id: keywordId,
              collectionId: collectionId,
              label: label,
              createdAt: DateTime.now(),
            ),
          );
        }

        await into(itemKeywordsTable).insert(
          ItemKeywordsTableCompanion.insert(itemId: itemId, keywordId: keywordId),
          mode: InsertMode.insertOrIgnore,
        );
      }
    });
  }
}
