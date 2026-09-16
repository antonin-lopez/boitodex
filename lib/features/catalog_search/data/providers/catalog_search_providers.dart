import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:boitodex/core/providers/core_providers.dart';
import 'package:boitodex/features/item/data/providers/item_providers.dart';
import 'package:boitodex/features/catalog_search/data/repositories/catalog_search_repository_impl.dart';
import 'package:boitodex/features/catalog_search/domain/repositories/catalog_search_repository.dart';

part 'catalog_search_providers.g.dart';

@Riverpod(keepAlive: true)
CatalogSearchRepository catalogSearchRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  final itemRepository = ref.watch(itemRepositoryProvider);
  final embeddingEngine = ref.watch(embeddingEngineProvider);
  return CatalogSearchRepositoryImpl(
    db.itemsDao,
    itemRepository,
    embeddingEngine,
  );
}
