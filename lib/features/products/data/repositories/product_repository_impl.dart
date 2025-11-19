import '../../../../core/errors/exceptions.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/entities/product.dart';
import '../datasources/product_remote_datasource.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Product>> getProducts() async {
    try {
      final models = await remoteDataSource.getProducts();
      return models.map((model) => _modelToEntity(model)).toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Error inesperado: $e');
    }
  }

  @override
  Future<Product> getProductById(int productId) async {
    try {
      final model = await remoteDataSource.getProductById(productId);
      return _modelToEntity(model);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Error inesperado: $e');
    }
  }

  @override
  Future<Product> createProduct(Product product) async {
    try {
      // Reglas de negocio: validar que el precio y stock no sean negativos
      if (product.price < 0) {
        throw ValidationException(message: 'El precio no puede ser negativo');
      }
      if (product.stock < 0) {
        throw ValidationException(message: 'El stock no puede ser negativo');
      }

      final model = _entityToModel(product);
      final created = await remoteDataSource.createProduct(model);
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
  Future<Product> updateProduct(int productId, Product product) async {
    try {
      // Reglas de negocio
      if (product.price < 0) {
        throw ValidationException(message: 'El precio no puede ser negativo');
      }
      if (product.stock < 0) {
        throw ValidationException(message: 'El stock no puede ser negativo');
      }

      final model = _entityToModel(product);
      final updated = await remoteDataSource.updateProduct(productId, model);
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
  Future<void> deleteProduct(int productId) async {
    try {
      await remoteDataSource.deleteProduct(productId);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Error inesperado: $e');
    }
  }

  @override
  Future<Product> updateStock(int productId, int quantity) async {
    try {
      // Regla de negocio: no permitir stock negativo
      final currentProduct = await getProductById(productId);
      final newStock = currentProduct.stock + quantity;
      if (newStock < 0) {
        throw ValidationException(
          message: 'No se puede tener stock negativo. Stock actual: ${currentProduct.stock}',
        );
      }

      final updated = await remoteDataSource.updateStock(productId, quantity);
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
  Future<Product> activateProduct(int productId) async {
    try {
      final updated = await remoteDataSource.activateProduct(productId);
      return _modelToEntity(updated);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Error inesperado: $e');
    }
  }

  Product _modelToEntity(ProductModel model) {
    return Product(
      productId: model.productId,
      name: model.name,
      description: model.description,
      price: model.price,
      stock: model.stock,
      imagenUrl: model.imagenUrl,
      active: model.active,
      categoryId: model.categoryId,
      categoryName: model.categoryName,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  ProductModel _entityToModel(Product entity) {
    return ProductModel(
      productId: entity.productId,
      name: entity.name,
      description: entity.description,
      price: entity.price,
      stock: entity.stock,
      imagenUrl: entity.imagenUrl,
      active: entity.active,
      categoryId: entity.categoryId,
      categoryName: entity.categoryName,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}

