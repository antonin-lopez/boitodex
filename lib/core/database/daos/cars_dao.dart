import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/car_images_table.dart';
import '../tables/car_keywords_table.dart';
import '../tables/cars_table.dart';
import 'package:boitodex/features/sync/domain/models/sync_status.dart';

part 'cars_dao.g.dart';

@DriftAccessor(tables: [CarsTable, CarImagesTable, CarKeywordsTable])
class CarsDao extends DatabaseAccessor<AppDatabase> with _$CarsDaoMixin {
  CarsDao(super.db);

  Stream<List<CarData>> watchCars(String collectionId) {
    final query =
        select(carsTable).join([
            leftOuterJoin(
              carKeywordsTable,
              carKeywordsTable.carId.equalsExp(carsTable.id),
            ),
            leftOuterJoin(
              carImagesTable,
              carImagesTable.carId.equalsExp(carsTable.id),
            ),
          ])
          ..where(
            carsTable.collectionId.equals(collectionId) &
                carsTable.deletedAt.isNull(),
          )
          ..orderBy([OrderingTerm.desc(carsTable.createdAt)]);

    return query.watch().map((rows) {
      final seenIds = <String>{};
      final cars = <CarData>[];
      for (final row in rows) {
        final car = row.readTable(carsTable);
        if (seenIds.add(car.id)) cars.add(car);
      }
      return cars;
    });
  }

  Future<List<CarData>> getCarsByCollection(String collectionId) {
    return (select(carsTable)
          ..where(
            (tbl) =>
                tbl.collectionId.equals(collectionId) & tbl.deletedAt.isNull(),
          )
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]))
        .get();
  }

  Future<CarData?> getCarById(String id) {
    return (select(
      carsTable,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<List<String>> searchCarIdsByFts(
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

    return db.searchCarsByText(formattedQuery, collectionId).get();
  }

  Future<void> insertOrUpdateCar(CarsTableCompanion car) {
    return into(carsTable).insertOnConflictUpdate(car);
  }

  Future<void> softDeleteCar(String carId) {
    return (update(carsTable)..where((tbl) => tbl.id.equals(carId))).write(
      CarsTableCompanion(
        deletedAt: Value(DateTime.now()),
        syncStatus: const Value(SyncStatus.pending),
      ),
    );
  }

  Future<void> upsertFtsEntry({
    required String carId,
    required String notes,
    required String keywords,
  }) async {
    await customStatement('DELETE FROM cars_fts WHERE car_id = ?', [carId]);
    await customInsert(
      'INSERT INTO cars_fts (car_id, notes, keywords) VALUES (?, ?, ?)',
      variables: [
        Variable.withString(carId),
        Variable.withString(notes),
        Variable.withString(keywords),
      ],
    );
  }

  Future<List<CarImageData>> getImagesForCar(String carId) {
    return (select(
      carImagesTable,
    )..where((tbl) => tbl.carId.equals(carId) & tbl.deletedAt.isNull())).get();
  }

  Future<Map<String, List<CarImageData>>> getImagesForCars(
    List<String> carIds,
  ) async {
    if (carIds.isEmpty) return {};

    final rows = await (select(
      carImagesTable,
    )..where((tbl) => tbl.carId.isIn(carIds) & tbl.deletedAt.isNull())).get();

    final map = <String, List<CarImageData>>{};
    for (final row in rows) {
      map.putIfAbsent(row.carId, () => []).add(row);
    }
    return map;
  }

  Future<void> replaceCarImages({
    required String carId,
    required List<CarImagesTableCompanion> images,
  }) async {
    await (delete(
      carImagesTable,
    )..where((tbl) => tbl.carId.equals(carId))).go();

    for (final image in images) {
      await into(carImagesTable).insertOnConflictUpdate(image);
    }
  }
}
