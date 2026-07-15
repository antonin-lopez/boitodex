import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:boitodex/core/providers/core_providers.dart';
import 'package:boitodex/features/car/data/providers/car_providers.dart';
import 'package:boitodex/features/catalog_search/data/repositories/catalog_search_repository_impl.dart';
import 'package:boitodex/features/catalog_search/domain/repositories/catalog_search_repository.dart';

part 'catalog_search_providers.g.dart';

@Riverpod(keepAlive: true)
CatalogSearchRepository catalogSearchRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  final carRepository = ref.watch(carRepositoryProvider);
  final embeddingEngine = ref.watch(embeddingEngineProvider);
  return CatalogSearchRepositoryImpl(
    db.carsDao,
    carRepository,
    embeddingEngine,
  );
}
