class ProductModel {
  final String? id;
  final String name;
  final String category;
  final int quantity;
  final double price;
  final String manufacturer;
  final String? organizationId;
  final String? createdBy;
  final DateTime? createdAt;
  final bool isActive;

  ProductModel({
    this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.price,
    required this.manufacturer,
    this.organizationId,
    this.createdBy,
    this.createdAt,
    this.isActive = true,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id']?.toString(),
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      quantity: json['quantity'] ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      manufacturer: json['manufacturer'] ?? '',
      organizationId: json['organization_id']?.toString(),
      createdBy: json['created_by']?.toString(),
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'quantity': quantity,
      'price': price,
      'manufacturer': manufacturer,
      'isActive': isActive
    };
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? category,
    int? quantity,
    double? price,
    String? manufacturer,
    String? organizationId,
    String? createdBy,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      manufacturer: manufacturer ?? this.manufacturer,
      organizationId: organizationId ?? this.organizationId,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
}