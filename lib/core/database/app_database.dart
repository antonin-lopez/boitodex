import 'dart:io';
import 'dart:typed_data';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'converters/float32_list_converter.dart';
import 'daos/cars_dao.dart';
import 'daos/collections_dao.dart';
import 'daos/keywords_dao.dart';
import 'tables/car_images_table.dart';
import 'tables/car_keywords_table.dart';
import 'tables/cars_table.dart';
import 'tables/collections_table.dart';
import 'tables/keywords_table.dart';
import 'tables/sync_cursors_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    CollectionsTable,
    CarsTable,
    CarImagesTable,
    KeywordsTable,
    CarKeywordsTable,
    SyncCursorsTable,
  ],
  include: {'tables/cars_fts.drift'},
  daos: [CollectionsDao, CarsDao, KeywordsDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },

      onUpgrade: (Migrator m, int from, int to) async {},

      beforeOpen: (OpeningDetails details) async {
        await customStatement('PRAGMA foreign_keys = ON;');
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'boitodex.sqlite'));
    return NativeDatabase.createInBackground(
      file,
      setup: (rawDb) {
        rawDb.execute('PRAGMA foreign_keys = ON;');
      },
    );
  });
}
