import 'package:boitodex/features/item/domain/models/item.dart';

abstract class ItemRepository {
  Future<void> saveItem({
    String? id,
    required String collectionId,
    String? notes,
    required List<String> keywordLabels,
    required List<String> imagePaths,
  });

  Future<Item?> getItemById(String id);

  Future<void> softDeleteItem(String itemId);

  Stream<List<Item>> watchItemsByCollection(String collectionId);
}
