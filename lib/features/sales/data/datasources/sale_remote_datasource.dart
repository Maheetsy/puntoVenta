import '../../../../core/network/node_api_client.dart';
import '../../../../core/constants/api_config.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/auth_service.dart';
import '../models/sale_model.dart';

abstract class SaleRemoteDataSource {
  Future<List<SaleModel>> getSales();
  Future<SaleModel> getSaleById(String saleId);
  Future<SaleModel> createSale(SaleModel sale);
}

class SaleRemoteDataSourceImpl implements SaleRemoteDataSource {
  final NodeApiClient apiClient;

  SaleRemoteDataSourceImpl({required this.apiClient});

  Future<String?> _getToken() async {
    return await AuthService.getToken();
  }

  @override
  Future<List<SaleModel>> getSales() async {
    try {
      final token = await _getToken();
      final response = await apiClient.get(
        ApiConfig.salesEndpoint,
        token: token,
      );

      List<dynamic> data = [];
      if (response['success'] == true) {
        if (response.containsKey('sales') && response['sales'] is List) {
          data = response['sales'] as List;
        } else if (response.containsKey('data') && response['data'] is List) {
          data = response['data'] as List;
        } else if (response.containsKey('items') && response['items'] is List) {
          data = response['items'] as List;
        }
      }

      return data.map((json) => SaleModel.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(message: 'Error al obtener ventas: $e');
    }
  }

  @override
  Future<SaleModel> getSaleById(String saleId) async {
    try {
      final token = await _getToken();
      final response = await apiClient.get(
        '${ApiConfig.salesEndpoint}/$saleId',
        token: token,
      );

      if (response['success'] == true && response['sale'] != null) {
        return SaleModel.fromJson(response['sale'] as Map<String, dynamic>);
      } else {
        throw ServerException(
          message: response['message']?.toString() ?? 'Error al obtener venta',
        );
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(message: 'Error al obtener venta: $e');
    }
  }

  @override
  Future<SaleModel> createSale(SaleModel sale) async {
    try {
      final token = await _getToken();
      final response = await apiClient.post(
        ApiConfig.salesEndpoint,
        body: sale.toJson(),
        token: token,
      );

      if (response['success'] == true && response['sale'] != null) {
        return SaleModel.fromJson(response['sale'] as Map<String, dynamic>);
      } else {
        throw ServerException(
          message: response['message']?.toString() ?? 'Error al crear venta',
        );
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException(message: 'Error al crear venta: $e');
    }
  }
}

