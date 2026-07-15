import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:boitodex/core/providers/core_providers.dart';
import 'package:boitodex/features/car/data/repositories/car_repository_impl.dart';
import 'package:boitodex/features/car/domain/models/car.dart';
import 'package:boitodex/features/car/domain/repositories/car_repository.dart';

part 'car_providers.g.dart';

@Riverpod(keepAlive: true)
CarRepository carRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  final embeddingEngine = ref.watch(embeddingEngineProvider);
  return CarRepositoryImpl(db.carsDao, db.keywordsDao, embeddingEngine);
}

@riverpod
Stream<List<Car>> carsByCollection(Ref ref, String collectionId) {
  return ref.watch(carRepositoryProvider).watchCarsByCollection(collectionId);
}
