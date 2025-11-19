import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_config.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<CategoryModel> getCategoryById(int categoryId);
  Future<CategoryModel> createCategory(CategoryModel category);
  Future<CategoryModel> updateCategory(int categoryId, CategoryModel category);
  Future<void> deleteCategory(int categoryId);
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final ApiClient apiClient;

  CategoryRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await apiClient.get(ApiConfig.categoriesEndpoint);
      
      // FastAPI puede devolver la lista directamente o dentro de 'data' o 'items'
      List<dynamic> data = [];
      if (response.containsKey('data')) {
        final dataValue = response['data'];
        if (dataValue is List) {
          data = dataValue;
        }
      } else if (response.containsKey('items')) {
        final itemsValue = response['items'];
        if (itemsValue is List) {
          data = itemsValue;
        }
      } else if (response.containsKey('results')) {
        final resultsValue = response['results'];
        if (resultsValue is List) {
          data = resultsValue;
        }
      } else if (response.isNotEmpty) {
        // Si la respuesta no es una lista, intentar extraer los valores
        final values = response.values.toList();
        if (values.isNotEmpty && values.first is List) {
          data = values.first as List<dynamic>;
        }
      }
      
      return data.map((json) => CategoryModel.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(message: 'Error al obtener categorías: $e');
    }
  }

  @override
  Future<CategoryModel> getCategoryById(int categoryId) async {
    try {
      final response = await apiClient.get('${ApiConfig.categoriesEndpoint}$categoryId');
      return CategoryModel.fromJson(response);
    } catch (e) {
      throw ServerException(message: 'Error al obtener categoría: $e');
    }
  }

  @override
  Future<CategoryModel> createCategory(CategoryModel category) async {
    try {
      final response = await apiClient.post(
        ApiConfig.categoriesEndpoint,
        body: category.toJson(),
      );
      return CategoryModel.fromJson(response);
    } catch (e) {
      throw ServerException(message: 'Error al crear categoría: $e');
    }
  }

  @override
  Future<CategoryModel> updateCategory(int categoryId, CategoryModel category) async {
    try {
      final response = await apiClient.patch(
        '${ApiConfig.categoriesEndpoint}$categoryId',
        body: category.toJson(),
      );
      return CategoryModel.fromJson(response);
    } catch (e) {
      throw ServerException(message: 'Error al actualizar categoría: $e');
    }
  }

  @override
  Future<void> deleteCategory(int categoryId) async {
    try {
      await apiClient.delete('${ApiConfig.categoriesEndpoint}$categoryId');
    } catch (e) {
      throw ServerException(message: 'Error al eliminar categoría: $e');
    }
  }
}

