class CategoryModel {
  final int? categoryId;
  final String name;
  final String? description;

  CategoryModel({
    this.categoryId,
    required this.name,
    this.description,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      categoryId: json['category_id'] as int?,
      name: json['name'] as String,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (categoryId != null) 'category_id': categoryId,
      'name': name,
      if (description != null) 'description': description,
    };
  }

  CategoryModel copyWith({
    int? categoryId,
    String? name,
    String? description,
  }) {
    return CategoryModel(
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }
}

