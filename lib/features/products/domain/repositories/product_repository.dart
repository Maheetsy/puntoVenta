import '../entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
  Future<Product> getProductById(int productId);
  Future<Product> createProduct(Product product);
  Future<Product> updateProduct(int productId, Product product);
  Future<void> deleteProduct(int productId);
  Future<Product> updateStock(int productId, int quantity);
  Future<Product> activateProduct(int productId);
}

