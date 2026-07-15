import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/collections_table.dart';

part 'collections_dao.g.dart';

@DriftAccessor(tables: [CollectionsTable])
class CollectionsDao extends DatabaseAccessor<AppDatabase>
    with _$CollectionsDaoMixin {
  CollectionsDao(super.db);

  Future<CollectionData?> getCollectionById(String id) {
    return (select(
      collectionsTable,
    )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<CollectionData?> getCollectionByPairingCode(String code) {
    return (select(
      collectionsTable,
    )..where((tbl) => tbl.pairingCode.equals(code))).getSingleOrNull();
  }

  Future<void> insertOrUpdateCollection(CollectionsTableCompanion collection) {
    return into(collectionsTable).insertOnConflictUpdate(collection);
  }

  Future<void> deleteCollection(String id) {
    return (delete(collectionsTable)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<CollectionData?> getActiveCollection() {
    return (select(collectionsTable)..limit(1)).getSingleOrNull();
  }
}
