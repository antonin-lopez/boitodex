import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:boitodex/features/car/data/providers/car_providers.dart';

part 'car_entry_detail_controller.g.dart';

@riverpod
class CarEntryDetailController extends _$CarEntryDetailController {
  @override
  FutureOr<void> build() {}

  Future<void> saveCar({
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
            collectionId: collectionId,
            notes: notes,
            keywordLabels: keywordLabels,
            imagePaths: imagePaths,
          ),
    );
  }
}
