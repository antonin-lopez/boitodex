import 'package:drift/drift.dart';
import 'cars_table.dart';

@DataClassName('CarImageData')
class CarImagesTable extends Table {
  @override
  String get tableName => 'car_images';

  TextColumn get id => text()();

  TextColumn get carId =>
      text().references(CarsTable, #id, onDelete: KeyAction.cascade)();

  TextColumn get localPath => text().nullable()();

  TextColumn get remoteUrl => text().nullable()();

  BoolColumn get isPrimary => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  IntColumn get syncStatus => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}
