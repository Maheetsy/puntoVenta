import '../entities/category.dart';

abstract class CategoryRepository {
  Future<List<Category>> getCategories();
  Future<Category> getCategoryById(int categoryId);
  Future<Category> createCategory(Category category);
  Future<Category> updateCategory(int categoryId, Category category);
  Future<void> deleteCategory(int categoryId);
}

