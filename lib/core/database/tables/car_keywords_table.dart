import 'package:drift/drift.dart';
import 'cars_table.dart';
import 'keywords_table.dart';

@DataClassName('CarKeywordData')
class CarKeywordsTable extends Table {
  @override
  String get tableName => 'car_keywords';

  TextColumn get carId =>
      text().references(CarsTable, #id, onDelete: KeyAction.cascade)();

  TextColumn get keywordId =>
      text().references(KeywordsTable, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {carId, keywordId};
}
