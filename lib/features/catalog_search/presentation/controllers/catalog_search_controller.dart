import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:boitodex/features/catalog_search/data/providers/catalog_search_providers.dart';
import 'package:boitodex/features/catalog_search/domain/models/search_result.dart';

part 'catalog_search_controller.g.dart';

@riverpod
class CatalogSearchController extends _$CatalogSearchController {
  @override
  FutureOr<List<SearchResult>> build(String collectionId) => const [];

  Future<void> search(String query) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(catalogSearchRepositoryProvider)
          .searchCars(query: query, collectionId: collectionId),
    );
  }
}
