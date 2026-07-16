import 'package:drift/drift.dart';
import 'collections_table.dart';

@DataClassName('KeywordData')
class KeywordsTable extends Table {
  @override
  String get tableName => 'keywords';

  TextColumn get id => text()();

  TextColumn get collectionId =>
      text().references(CollectionsTable, #id, onDelete: KeyAction.cascade)();

  TextColumn get label => text().withLength(min: 1, max: 50)();

  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
