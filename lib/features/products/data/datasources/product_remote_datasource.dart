import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_config.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> getProductById(int productId);
  Future<ProductModel> createProduct(ProductModel product);
  Future<ProductModel> updateProduct(int productId, ProductModel product);
  Future<void> deleteProduct(int productId);
  Future<ProductModel> updateStock(int productId, int quantity);
  Future<ProductModel> activateProduct(int productId);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiClient apiClient;

  ProductRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await apiClient.get(ApiConfig.productsEndpoint);
      
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
      
      return data.map((json) => ProductModel.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(message: 'Error al obtener productos: $e');
    }
  }

  @override
  Future<ProductModel> getProductById(int productId) async {
    try {
      final response = await apiClient.get('${ApiConfig.productsEndpoint}$productId');
      return ProductModel.fromJson(response);
    } catch (e) {
      throw ServerException(message: 'Error al obtener producto: $e');
    }
  }

  @override
  Future<ProductModel> createProduct(ProductModel product) async {
    try {
      final response = await apiClient.post(
        ApiConfig.productsEndpoint,
        body: product.toJson(),
      );
      return ProductModel.fromJson(response);
    } catch (e) {
      throw ServerException(message: 'Error al crear producto: $e');
    }
  }

  @override
  Future<ProductModel> updateProduct(int productId, ProductModel product) async {
    try {
      final response = await apiClient.patch(
        '${ApiConfig.productsEndpoint}$productId',
        body: product.toJson(),
      );
      return ProductModel.fromJson(response);
    } catch (e) {
      throw ServerException(message: 'Error al actualizar producto: $e');
    }
  }

  @override
  Future<void> deleteProduct(int productId) async {
    try {
      await apiClient.delete('${ApiConfig.productsEndpoint}$productId');
    } catch (e) {
      throw ServerException(message: 'Error al eliminar producto: $e');
    }
  }

  @override
  Future<ProductModel> updateStock(int productId, int quantity) async {
    try {
      final response = await apiClient.patch(
        '${ApiConfig.productsEndpoint}$productId/stock',
        body: {'quantity': quantity},
      );
      return ProductModel.fromJson(response);
    } catch (e) {
      throw ServerException(message: 'Error al actualizar stock: $e');
    }
  }

  @override
  Future<ProductModel> activateProduct(int productId) async {
    try {
      final response = await apiClient.post(
        '${ApiConfig.productsEndpoint}$productId/activate',
      );
      return ProductModel.fromJson(response);
    } catch (e) {
      throw ServerException(message: 'Error al activar producto: $e');
    }
  }
}

