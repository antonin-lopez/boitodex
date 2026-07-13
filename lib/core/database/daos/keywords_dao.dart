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
}
