import 'package:drift/drift.dart';
import 'items_table.dart';
import 'keywords_table.dart';

@DataClassName('ItemKeywordData')
class ItemKeywordsTable extends Table {
  @override
  String get tableName => 'item_keywords';

  TextColumn get itemId =>
      text().references(ItemsTable, #id, onDelete: KeyAction.cascade)();

  TextColumn get keywordId =>
      text().references(KeywordsTable, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {itemId, keywordId};
}
