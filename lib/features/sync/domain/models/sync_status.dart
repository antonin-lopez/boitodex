import 'package:drift/drift.dart';

enum SyncStatus { synced, pending, conflict }

class SyncStatusConverter extends TypeConverter<SyncStatus, int> {
  const SyncStatusConverter();

  @override
  SyncStatus fromSql(int fromDb) {
    return SyncStatus.values[fromDb];
  }

  @override
  int toSql(SyncStatus value) {
    return value.index;
  }
}
