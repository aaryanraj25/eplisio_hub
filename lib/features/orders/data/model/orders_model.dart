class Order {
  final String id;
  final String clinicId;
  final List<OrderItem> items;
  final String? notes;
  final double totalAmount;
  final String status;
  final String adminId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String orderId;
  final String clinicName;
  final String createdByName;

  Order({
    required this.id,
    required this.clinicId,
    required this.items,
    this.notes,
    required this.totalAmount,
    required this.status,
    required this.adminId,
    required this.createdAt,
    required this.updatedAt,
    required this.orderId,
    required this.clinicName,
    required this.createdByName,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id'],
      clinicId: json['clinic_id'],
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      notes: json['notes'],
      totalAmount: json['total_amount']?.toDouble() ?? 0.0,
      status: json['status'],
      adminId: json['admin_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      orderId: json['order_id'],
      clinicName: json['clinic_name'],
      createdByName: json['created_by_name'],
    );
  }
}

class OrderItem {
  final String productId;
  final String name;
  final int quantity;
  final double price;
  final double total;

  OrderItem({
    required this.productId,
    required this.name,
    required this.quantity,
    required this.price,
    required this.total,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['product_id'],
      name: json['name'],
      quantity: json['quantity'],
      price: json['price']?.toDouble() ?? 0.0,
      total: json['total']?.toDouble() ?? 0.0,
    );
  }
}

class PaymentInfo {
  final String method;
  final String status;
  final String? transactionId;
  final DateTime? paidAt;

  PaymentInfo({
    required this.method,
    required this.status,
    this.transactionId,
    this.paidAt,
  });

  factory PaymentInfo.fromJson(Map<String, dynamic> json) {
    return PaymentInfo(
      method: json['method'],
      status: json['status'],
      transactionId: json['transaction_id'],
      paidAt: json['paid_at'] != null ? DateTime.parse(json['paid_at']) : null,
    );
  }
}

class DeliveryInfo {
  final String address;
  final String city;
  final String state;
  final String pincode;
  final String? trackingId;
  final String status;
  final DateTime? estimatedDelivery;

  DeliveryInfo({
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    this.trackingId,
    required this.status,
    this.estimatedDelivery,
  });

  factory DeliveryInfo.fromJson(Map<String, dynamic> json) {
    return DeliveryInfo(
      address: json['address'],
      city: json['city'],
      state: json['state'],
      pincode: json['pincode'],
      trackingId: json['tracking_id'],
      status: json['status'],
      estimatedDelivery: json['estimated_delivery'] != null
          ? DateTime.parse(json['estimated_delivery'])
          : null,
    );
  }
}

class OrdersResponse {
  final int total;
  final List<Order> orders;
  final int page;
  final int pages;

  OrdersResponse({
    required this.total,
    required this.orders,
    required this.page,
    required this.pages,
  });

  factory OrdersResponse.fromJson(Map<String, dynamic> json) {
    return OrdersResponse(
      total: json['total'] ?? 0,
      orders: (json['orders'] as List?)
              ?.map((x) => Order.fromJson(x))
              .toList() ??
          [],
      page: json['page'] ?? 1,
      pages: json['pages'] ?? 1,
    );
  }
}