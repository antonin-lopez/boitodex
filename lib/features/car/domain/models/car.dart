import 'dart:typed_data';

import 'package:boitodex/features/car/domain/models/car_image.dart';
import 'package:boitodex/features/car/domain/models/keyword.dart';

class Car {
  final String id;
  final String collectionId;
  final String? notes;
  final List<Keyword> keywords;
  final List<CarImage> images;
  final Float32List? embedding;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  const Car({
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
