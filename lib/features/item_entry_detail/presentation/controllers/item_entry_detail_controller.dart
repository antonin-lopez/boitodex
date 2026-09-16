import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:boitodex/features/item/data/providers/item_providers.dart';

part 'item_entry_detail_controller.g.dart';

@riverpod
class ItemEntryDetailController extends _$ItemEntryDetailController {
  @override
  FutureOr<void> build() {}

  Future<void> saveItem({
    String? id,
    required String collectionId,
    String? notes,
    required List<String> keywordLabels,
    required List<String> imagePaths,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(itemRepositoryProvider)
          .saveItem(
            id: id,
            collectionId: collectionId,
            notes: notes,
            keywordLabels: keywordLabels,
            imagePaths: imagePaths,
          ),
    );
  }

  Future<void> deleteItem(String itemId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(itemRepositoryProvider).softDeleteItem(itemId),
    );
  }
}
