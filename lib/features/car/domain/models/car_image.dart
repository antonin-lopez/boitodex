class CarImage {
  final String id;
  final String carId;
  final String? localPath;
  final String? remoteUrl;
  final bool isPrimary;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CarImage({
    required this.id,
    required this.carId,
    this.localPath,
    this.remoteUrl,
    required this.isPrimary,
    required this.createdAt,
    required this.updatedAt,
  });
}
