import 'package:boitodex/features/car_entry_detail/domain/models/car.dart';

abstract class CarEntryDetailRepository {
  Future<void> saveCar({
    String? id,
    required String collectionId,
    String? notes,
    required List<String> keywordLabels,
    required List<String> imagePaths,
  });

  Future<Car?> getCarById(String id);

  Future<void> softDeleteCar(String carId);

  Stream<List<Car>> watchCarsByCollection(String collectionId);
}
