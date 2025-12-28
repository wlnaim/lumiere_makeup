class Product {
  final String id;
  final String name;
  final double price;
  final double? oldPrice;
  final String imageUrl;
  final DateTime timestamp;
  final bool isLocalImage;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.oldPrice,
    required this.imageUrl,
    required this.timestamp,
    this.isLocalImage = false,
  });
}
