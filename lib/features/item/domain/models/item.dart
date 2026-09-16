import 'dart:typed_data';

import 'package:boitodex/features/item/domain/models/item_image.dart';
import 'package:boitodex/features/item/domain/models/keyword.dart';

class Item {
  final String id;
  final String collectionId;
  final String? notes;
  final List<Keyword> keywords;
  final List<ItemImage> images;
  final Float32List? embedding;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  const Item({
    required this.id,
    required this.collectionId,
    this.notes,
    required this.keywords,
    required this.images,
    this.embedding,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
}
