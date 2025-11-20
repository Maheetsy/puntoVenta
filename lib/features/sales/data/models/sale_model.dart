import '../../domain/entities/sale.dart' as entity;

class SaleItemModel {
  final int productId;
  final String productName;
  final int quantity;
  final double price;
  final double subtotal;

  SaleItemModel({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.subtotal,
  });

  factory SaleItemModel.fromJson(Map<String, dynamic> json) {
    return SaleItemModel(
      productId: (json['product_id'] as num?)?.toInt() ?? 
                 (json['productId'] as num?)?.toInt() ?? 0,
      productName: json['product_name'] as String? ?? 
                   json['productName'] as String? ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'quantity': quantity,
      'price': price,
      'subtotal': subtotal,
    };
  }

  entity.SaleItem toEntity() {
    return entity.SaleItem(
      productId: productId,
      productName: productName,
      quantity: quantity,
      price: price,
      subtotal: subtotal,
    );
  }

  factory SaleItemModel.fromEntity(entity.SaleItem item) {
    return SaleItemModel(
      productId: item.productId,
      productName: item.productName,
      quantity: item.quantity,
      price: item.price,
      subtotal: item.subtotal,
    );
  }
}

class SaleModel {
  final String? saleId;
  final DateTime saleDate;
  final String? userId;
  final String? userName;
  final String status;
  final String paymentMethod;
  final List<SaleItemModel> items;
  final double total;

  SaleModel({
    this.saleId,
    required this.saleDate,
    this.userId,
    this.userName,
    required this.status,
    required this.paymentMethod,
    required this.items,
    required this.total,
  });

  factory SaleModel.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List? ?? [];
    // MongoDB usa _id como String
    final saleId = json['_id']?.toString() ?? json['sale_id']?.toString();
    
    // Parsear fecha - puede venir como String o DateTime
    DateTime saleDate;
    if (json['sale_date'] is String) {
      saleDate = DateTime.parse(json['sale_date'] as String);
    } else if (json['saleDate'] is String) {
      saleDate = DateTime.parse(json['saleDate'] as String);
    } else if (json['sale_date'] is DateTime) {
      saleDate = json['sale_date'] as DateTime;
    } else {
      saleDate = DateTime.now();
    }
    
    return SaleModel(
      saleId: saleId,
      saleDate: saleDate,
      userId: json['user_id']?.toString() ?? json['userId']?.toString(),
      userName: json['user_name'] as String? ?? json['userName'] as String?,
      status: json['status'] as String? ?? 'Completada',
      paymentMethod: json['payment_method'] as String? ?? json['paymentMethod'] as String? ?? 'Efectivo',
      items: itemsJson.map((item) => SaleItemModel.fromJson(item as Map<String, dynamic>)).toList(),
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (saleId != null) '_id': saleId,
      'sale_date': saleDate.toIso8601String().split('T')[0],
      if (userId != null) 'user_id': userId,
      'status': status,
      'payment_method': paymentMethod,
      'items': items.map((item) => item.toJson()).toList(),
      'total': total,
    };
  }

  entity.Sale toEntity() {
    return entity.Sale(
      saleId: saleId,
      saleDate: saleDate,
      userId: userId,
      userName: userName,
      status: status,
      paymentMethod: paymentMethod,
      items: items.map((item) => item.toEntity()).toList(),
      total: total,
    );
  }

  factory SaleModel.fromEntity(entity.Sale sale) {
    return SaleModel(
      saleId: sale.saleId,
      saleDate: sale.saleDate,
      userId: sale.userId,
      userName: sale.userName,
      status: sale.status,
      paymentMethod: sale.paymentMethod,
      items: sale.items.map((item) => SaleItemModel.fromEntity(item)).toList(),
      total: sale.total,
    );
  }
}

