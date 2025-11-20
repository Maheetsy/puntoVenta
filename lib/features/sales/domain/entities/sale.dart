class SaleItem {
  final int productId;
  final String productName;
  final int quantity;
  final double price;
  final double subtotal;

  SaleItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.subtotal,
  });
}

class Sale {
  final String? saleId;
  final DateTime saleDate;
  final String? userId;
  final String? userName;
  final String status;
  final String paymentMethod;
  final List<SaleItem> items;
  final double total;

  Sale({
    this.saleId,
    required this.saleDate,
    this.userId,
    this.userName,
    required this.status,
    required this.paymentMethod,
    required this.items,
    required this.total,
  });
}

