import 'package:drift/drift.dart';
import 'collections_table.dart';

@DataClassName('SyncCursorData')
class SyncCursorsTable extends Table {
  @override
  String get tableName => 'sync_cursors';

  TextColumn get deviceId => text()();

  TextColumn get collectionId => text().references(CollectionsTable, #id)();

  DateTimeColumn get lastSyncedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {deviceId};
}
