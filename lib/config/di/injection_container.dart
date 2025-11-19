import '../../core/network/api_client.dart';
import '../../core/network/node_api_client.dart';
import '../../features/products/data/datasources/product_remote_datasource.dart';
import '../../features/products/data/repositories/product_repository_impl.dart';
import '../../features/products/domain/repositories/product_repository.dart';
import '../../features/categories/data/datasources/category_remote_datasource.dart';
import '../../features/categories/data/repositories/category_repository_impl.dart';
import '../../features/categories/domain/repositories/category_repository.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';

class InjectionContainer {
  static final InjectionContainer _instance = InjectionContainer._internal();
  factory InjectionContainer() => _instance;
  InjectionContainer._internal();

  // API Clients
  late final ApiClient _apiClient = ApiClient(); // FastAPI
  late final NodeApiClient _nodeApiClient = NodeApiClient(); // Node.js

  // Data Sources
  late final ProductRemoteDataSource _productRemoteDataSource =
      ProductRemoteDataSourceImpl(apiClient: _apiClient);
  late final CategoryRemoteDataSource _categoryRemoteDataSource =
      CategoryRemoteDataSourceImpl(apiClient: _apiClient);
  late final AuthRemoteDataSource _authRemoteDataSource =
      AuthRemoteDataSourceImpl(apiClient: _nodeApiClient);

  // Repositories
  ProductRepository get productRepository =>
      ProductRepositoryImpl(remoteDataSource: _productRemoteDataSource);
  CategoryRepository get categoryRepository =>
      CategoryRepositoryImpl(remoteDataSource: _categoryRemoteDataSource);
  AuthRepository get authRepository =>
      AuthRepositoryImpl(remoteDataSource: _authRemoteDataSource);
}

final injectionContainer = InjectionContainer();

