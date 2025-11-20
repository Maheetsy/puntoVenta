import '../entities/sale.dart';

abstract class SaleRepository {
  Future<List<Sale>> getSales();
  Future<Sale> getSaleById(String saleId);
  Future<Sale> createSale(Sale sale);
}

