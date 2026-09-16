import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:boitodex/core/providers/core_providers.dart';
import 'package:boitodex/features/item/data/repositories/item_repository_impl.dart';
import 'package:boitodex/features/item/domain/models/item.dart';
import 'package:boitodex/features/item/domain/repositories/item_repository.dart';

part 'item_providers.g.dart';

@Riverpod(keepAlive: true)
ItemRepository itemRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  final embeddingEngine = ref.watch(embeddingEngineProvider);
  return ItemRepositoryImpl(db.itemsDao, db.keywordsDao, embeddingEngine);
}

@riverpod
Stream<List<Item>> itemsByCollection(Ref ref, String collectionId) {
  return ref.watch(itemRepositoryProvider).watchItemsByCollection(collectionId);
}
