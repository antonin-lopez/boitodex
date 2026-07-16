import 'package:drift/drift.dart';

import 'package:boitodex/features/sync/domain/models/sync_status.dart';
import '../converters/float32_list_converter.dart';
import 'collections_table.dart';

@DataClassName('CarData')
class CarsTable extends Table {
  @override
  String get tableName => 'cars';

  TextColumn get id => text()();

  TextColumn get collectionId =>
      text().references(CollectionsTable, #id, onDelete: KeyAction.cascade)();

  TextColumn get notes => text().nullable()();

  BlobColumn get embedding =>
      blob().map(const Float32ListConverter()).nullable()();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  IntColumn get syncStatus => integer()
      .map(const SyncStatusConverter())
      .withDefault(
        Constant(const SyncStatusConverter().toSql(SyncStatus.pending)),
      )();

  @override
  Set<Column> get primaryKey => {id};
}
