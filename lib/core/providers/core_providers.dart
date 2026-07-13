import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:boitodex/core/database/app_database.dart';
import 'package:boitodex/core/ml/embedding_engine.dart';

part 'core_providers.g.dart';

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
}

@Riverpod(keepAlive: true)
EmbeddingEngine embeddingEngine(Ref ref) {
  final engine = EmbeddingEngine();
  ref.onDispose(() => engine.dispose());
  return engine;
}
