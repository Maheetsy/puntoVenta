import '../../../../core/errors/exceptions.dart';
import '../../domain/repositories/sale_repository.dart';
import '../../domain/entities/sale.dart';
import '../datasources/sale_remote_datasource.dart';
import '../models/sale_model.dart';

class SaleRepositoryImpl implements SaleRepository {
  final SaleRemoteDataSource remoteDataSource;

  SaleRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Sale>> getSales() async {
    try {
      final models = await remoteDataSource.getSales();
      return models.map((model) => model.toEntity()).toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Error inesperado: $e');
    }
  }

  @override
  Future<Sale> getSaleById(String saleId) async {
    try {
      final model = await remoteDataSource.getSaleById(saleId);
      return model.toEntity();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Error inesperado: $e');
    }
  }

  @override
  Future<Sale> createSale(Sale sale) async {
    try {
      // Validar datos
      if (sale.items.isEmpty) {
        throw ValidationException(message: 'Debe agregar al menos un producto');
      }
      if (sale.total <= 0) {
        throw ValidationException(message: 'El total debe ser mayor a 0');
      }

      final model = SaleModel.fromEntity(sale);
      final created = await remoteDataSource.createSale(model);
      return created.toEntity();
    } on ValidationException {
      rethrow;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Error inesperado: $e');
    }
  }
}

