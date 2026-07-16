import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:boitodex/features/car/data/providers/car_providers.dart';

part 'car_entry_detail_controller.g.dart';

@riverpod
class CarEntryDetailController extends _$CarEntryDetailController {
  @override
  FutureOr<void> build() {}

  Future<void> saveCar({
    String? id,
    required String collectionId,
    String? notes,
    required List<String> keywordLabels,
    required List<String> imagePaths,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(carRepositoryProvider)
          .saveCar(
            id: id,
            collectionId: collectionId,
            notes: notes,
            keywordLabels: keywordLabels,
            imagePaths: imagePaths,
          ),
    );
  }

  Future<void> deleteCar(String carId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(carRepositoryProvider).softDeleteCar(carId),
    );
  }
}
