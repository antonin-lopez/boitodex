import 'package:drift/drift.dart';

@DataClassName('CollectionData')
class CollectionsTable extends Table {
  @override
  String get tableName => 'collections';

  TextColumn get id => text()();

  TextColumn get pairingCode => text().withLength(min: 8, max: 8).unique()();

  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
