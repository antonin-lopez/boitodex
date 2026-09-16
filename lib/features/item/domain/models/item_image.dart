class ItemImage {
  final String id;
  final String itemId;
  final String? localPath;
  final String? remoteUrl;
  final bool isPrimary;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ItemImage({
    required this.id,
    required this.itemId,
    this.localPath,
    this.remoteUrl,
    required this.isPrimary,
    required this.createdAt,
    required this.updatedAt,
  });
}
