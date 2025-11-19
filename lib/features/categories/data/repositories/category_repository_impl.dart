import '../../../../core/errors/exceptions.dart';
import '../../domain/repositories/category_repository.dart';
import '../../domain/entities/category.dart';
import '../datasources/category_remote_datasource.dart';
import '../models/category_model.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;

  CategoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Category>> getCategories() async {
    try {
      final models = await remoteDataSource.getCategories();
      return models.map((model) => _modelToEntity(model)).toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Error inesperado: $e');
    }
  }

  @override
  Future<Category> getCategoryById(int categoryId) async {
    try {
      final model = await remoteDataSource.getCategoryById(categoryId);
      return _modelToEntity(model);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Error inesperado: $e');
    }
  }

  @override
  Future<Category> createCategory(Category category) async {
    try {
      // Regla de negocio: validar que el nombre no esté vacío
      if (category.name.trim().isEmpty) {
        throw ValidationException(message: 'El nombre de la categoría es requerido');
      }

      final model = _entityToModel(category);
      final created = await remoteDataSource.createCategory(model);
      return _modelToEntity(created);
    } on ValidationException {
      rethrow;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Error inesperado: $e');
    }
  }

  @override
  Future<Category> updateCategory(int categoryId, Category category) async {
    try {
      // Regla de negocio: validar que el nombre no esté vacío
      if (category.name.trim().isEmpty) {
        throw ValidationException(message: 'El nombre de la categoría es requerido');
      }

      final model = _entityToModel(category);
      final updated = await remoteDataSource.updateCategory(categoryId, model);
      return _modelToEntity(updated);
    } on ValidationException {
      rethrow;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Error inesperado: $e');
    }
  }

  @override
  Future<void> deleteCategory(int categoryId) async {
    try {
      await remoteDataSource.deleteCategory(categoryId);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Error inesperado: $e');
    }
  }

  Category _modelToEntity(CategoryModel model) {
    return Category(
      categoryId: model.categoryId,
      name: model.name,
      description: model.description,
    );
  }

  CategoryModel _entityToModel(Category entity) {
    return CategoryModel(
      categoryId: entity.categoryId,
      name: entity.name,
      description: entity.description,
    );
  }
}

