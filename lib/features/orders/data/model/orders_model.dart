class Order {
  final String id;
  final String clinicId;
  final List<OrderItem> items;
  final String? notes;
  final double totalAmount;
  final String status;
  final String userId;  // Generic name for admin_id or employee_id
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
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.orderId,
    required this.clinicName,
    required this.createdByName,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    try {
      return Order(
        id: json['_id'] ?? '',
        clinicId: json['clinic_id'] ?? '',
        items: (json['items'] as List?)
            ?.map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
            .toList() ?? [],
        notes: json['notes'] as String?,
        totalAmount: (json['total_amount'] ?? 0.0).toDouble(),
        status: json['status'] ?? '',
        userId: json['admin_id'] ?? json['employee_id'] ?? '',
        createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
        updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
        orderId: json['order_id'] ?? '',
        clinicName: json['clinic_name'] ?? '',
        createdByName: json['created_by_name'] ?? '',
      );
    } catch (e) {
      print('Error parsing Order: $e');
      print('Problematic JSON: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'clinic_id': clinicId,
      'items': items.map((item) => item.toJson()).toList(),
      'notes': notes,
      'total_amount': totalAmount,
      'status': status,
      'admin_id': isAdminOrder ? userId : null,
      'employee_id': isEmployeeOrder ? userId : null,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'order_id': orderId,
      'clinic_name': clinicName,
      'created_by_name': createdByName,
    };
  }

  bool get isAdminOrder => userId.startsWith('ADM-');
  bool get isEmployeeOrder => userId.startsWith('EMP-');
  String get userIdField => isAdminOrder ? 'admin_id' : 'employee_id';
}

class OrderItem {
  final String productId;
  final String name;
  final int quantity;
  final double price;
  final double? total;

  OrderItem({
    required this.productId,
    required this.name,
    required this.quantity,
    required this.price,
    this.total,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    try {
      return OrderItem(
        productId: json['product_id'] ?? '',
        name: json['name'] ?? '',
        quantity: json['quantity'] ?? 0,
        price: (json['price'] ?? 0.0).toDouble(),
        total: json['total']?.toDouble(),
      );
    } catch (e) {
      print('Error parsing OrderItem: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'name': name,
      'quantity': quantity,
      'price': price,
      'total': total,
    };
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
    try {
      return PaymentInfo(
        method: json['method'] ?? '',
        status: json['status'] ?? '',
        transactionId: json['transaction_id'],
        paidAt: json['paid_at'] != null ? DateTime.parse(json['paid_at']) : null,
      );
    } catch (e) {
      print('Error parsing PaymentInfo: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'method': method,
      'status': status,
      'transaction_id': transactionId,
      'paid_at': paidAt?.toIso8601String(),
    };
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
    try {
      return DeliveryInfo(
        address: json['address'] ?? '',
        city: json['city'] ?? '',
        state: json['state'] ?? '',
        pincode: json['pincode'] ?? '',
        trackingId: json['tracking_id'],
        status: json['status'] ?? '',
        estimatedDelivery: json['estimated_delivery'] != null
            ? DateTime.parse(json['estimated_delivery'])
            : null,
      );
    } catch (e) {
      print('Error parsing DeliveryInfo: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'city': city,
      'state': state,
      'pincode': pincode,
      'tracking_id': trackingId,
      'status': status,
      'estimated_delivery': estimatedDelivery?.toIso8601String(),
    };
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
    try {
      return OrdersResponse(
        total: json['total'] ?? 0,
        orders: (json['orders'] as List?)
            ?.map((x) => Order.fromJson(x as Map<String, dynamic>))
            .toList() ?? [],
        page: json['page'] ?? 1,
        pages: json['pages'] ?? 1,
      );
    } catch (e) {
      print('Error parsing OrdersResponse: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'orders': orders.map((order) => order.toJson()).toList(),
      'page': page,
      'pages': pages,
    };
  }
}