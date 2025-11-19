class ProductModel {
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

  ProductModel({
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

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productId: json['product_id'] as int?,
      name: json['name'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      stock: json['stock'] as int,
      imagenUrl: json['imagen_url'] as String?,
      active: json['active'] as bool? ?? true,
      categoryId: json['category_id'] as int,
      categoryName: json['category_name'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (productId != null) 'product_id': productId,
      'name': name,
      if (description != null) 'description': description,
      'price': price,
      'stock': stock,
      if (imagenUrl != null) 'imagen_url': imagenUrl,
      'active': active,
      'category_id': categoryId,
    };
  }

  ProductModel copyWith({
    int? productId,
    String? name,
    String? description,
    double? price,
    int? stock,
    String? imagenUrl,
    bool? active,
    int? categoryId,
    String? categoryName,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductModel(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      imagenUrl: imagenUrl ?? this.imagenUrl,
      active: active ?? this.active,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

