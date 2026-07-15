import 'package:boitodex/core/utils/uuid_generator.dart';
import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/car_keywords_table.dart';
import '../tables/keywords_table.dart';

part 'keywords_dao.g.dart';

@DriftAccessor(tables: [KeywordsTable, CarKeywordsTable])
class KeywordsDao extends DatabaseAccessor<AppDatabase>
    with _$KeywordsDaoMixin {
  KeywordsDao(super.db);

  Stream<List<KeywordData>> watchKeywordsByCollection(String collectionId) {
    return (select(keywordsTable)
          ..where((tbl) => tbl.collectionId.equals(collectionId))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.label)]))
        .watch();
  }

  Future<void> insertOrUpdateKeyword(KeywordsTableCompanion keyword) {
    return into(keywordsTable).insertOnConflictUpdate(keyword);
  }

  Future<List<KeywordData>> getKeywordsForCar(String carId) async {
    final query = select(carKeywordsTable).join([
      innerJoin(
        keywordsTable,
        keywordsTable.id.equalsExp(carKeywordsTable.keywordId),
      ),
    ])..where(carKeywordsTable.carId.equals(carId));

    final rows = await query.get();
    return rows.map((row) => row.readTable(keywordsTable)).toList();
  }

  Future<Map<String, List<KeywordData>>> getKeywordsForCars(
    List<String> carIds,
  ) async {
    if (carIds.isEmpty) return {};

    final query = select(carKeywordsTable).join([
      innerJoin(
        keywordsTable,
        keywordsTable.id.equalsExp(carKeywordsTable.keywordId),
      ),
    ])..where(carKeywordsTable.carId.isIn(carIds));

    final rows = await query.get();

    final map = <String, List<KeywordData>>{};
    for (final row in rows) {
      final carId = row.read(carKeywordsTable.carId);
      final keyword = row.readTable(keywordsTable);

      if (carId != null) {
        map.putIfAbsent(carId, () => []).add(keyword);
      }
    }
    return map;
  }

  Future<KeywordData?> getKeywordByLabel(String collectionId, String label) {
    return (select(keywordsTable)..where(
          (tbl) =>
              tbl.collectionId.equals(collectionId) & tbl.label.equals(label),
        ))
        .getSingleOrNull();
  }

  Future<void> linkCarWithKeywords({
    required String carId,
    required String collectionId,
    required List<String> keywordLabels,
  }) async {
    await (delete(
      carKeywordsTable,
    )..where((tbl) => tbl.carId.equals(carId))).go();

    for (final rawLabel in keywordLabels) {
      final label = rawLabel.trim();
      if (label.isEmpty) continue;

      var keyword = await getKeywordByLabel(collectionId, label);
      var keywordId = keyword?.id;

      if (keywordId == null) {
        keywordId = UuidGenerator.generate();
        await insertOrUpdateKeyword(
          KeywordsTableCompanion.insert(
            id: keywordId,
            collectionId: collectionId,
            label: label,
            createdAt: DateTime.now(),
          ),
        );
      }

      await into(carKeywordsTable).insert(
        CarKeywordsTableCompanion.insert(carId: carId, keywordId: keywordId),
        mode: InsertMode.insertOrIgnore,
      );
    }
  }
}
