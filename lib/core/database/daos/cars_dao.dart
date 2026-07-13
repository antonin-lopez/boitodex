import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/car_images_table.dart';
import '../tables/car_keywords_table.dart';
import '../tables/cars_table.dart';

part 'cars_dao.g.dart';

@DriftAccessor(tables: [CarsTable, CarImagesTable, CarKeywordsTable])
class CarsDao extends DatabaseAccessor<AppDatabase> with _$CarsDaoMixin {
  CarsDao(super.db);

  Stream<List<CarData>> watchCars(String collectionId) {
    return (select(carsTable)
          ..where(
            (tbl) =>
                tbl.collectionId.equals(collectionId) & tbl.deletedAt.isNull(),
          )
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]))
        .watch();
  }

  Future<CarData?> getCarById(String id) {
    return (select(
      carsTable,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<List<String>> searchCarIdsByFts(String query) async {
    final sanitized = query
        .replaceAll(RegExp(r'[^\w\s]', unicode: true), ' ')
        .trim();

    if (sanitized.isEmpty) return [];

    final formattedQuery = sanitized
        .split(RegExp(r'\s+'))
        .where((term) => term.isNotEmpty)
        .map((term) => '"$term"*')
        .join(' ');

    return db.searchCarsByText(formattedQuery).get();
  }

  Future<void> insertOrUpdateCar(CarsTableCompanion car) {
    return into(carsTable).insertOnConflictUpdate(car);
  }

  Future<void> softDeleteCar(String carId) {
    return (update(carsTable)..where((tbl) => tbl.id.equals(carId))).write(
      CarsTableCompanion(
        deletedAt: Value(DateTime.now()),
        syncStatus: const Value(1), // 1 = Pending sync
      ),
    );
  }

  Future<void> upsertFtsEntry({
    required String carId,
    required String notes,
    required String keywords,
  }) async {
    await customInsert(
      'INSERT OR REPLACE INTO cars_fts (car_id, notes, keywords) VALUES (?, ?, ?)',
      variables: [
        Variable.withString(carId),
        Variable.withString(notes),
        Variable.withString(keywords),
      ],
    );
  }
}
