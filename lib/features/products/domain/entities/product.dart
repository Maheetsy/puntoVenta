class Product {
  final int? productId;
  final String name;
  final String? description;
  final double price;
  final int stock;
  final String? imagenUrl;
  final bool active;
  final int categoryId;
  final String? categoryName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Product({
    this.productId,
    required this.name,
    this.description,
    required this.price,
    required this.stock,
    this.imagenUrl,
    required this.active,
    required this.categoryId,
    this.categoryName,
    this.createdAt,
    this.updatedAt,
  });

  bool get isLowStock => stock < 10;
  bool get isOutOfStock => stock == 0;
}

