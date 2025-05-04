// lib/features/profile/data/model/admin_profile_model.dart

class AdminProfileModel {
  final String adminId;
  final String name;
  final String email;
  final String phone;
  final String role;
  final DateTime createdAt;
  final OrganizationDetails organization;
  final Statistics statistics;
  final List<String> permissions;
  final DateTime lastLogin;
  final bool isVerified;

  AdminProfileModel({
    required this.adminId,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.createdAt,
    required this.organization,
    required this.statistics,
    required this.permissions,
    required this.lastLogin,
    required this.isVerified,
  });

  factory AdminProfileModel.fromJson(Map<String, dynamic> json) {
    return AdminProfileModel(
      adminId: json['admin_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      organization: OrganizationDetails.fromJson(json['organization'] ?? {}),
      statistics: Statistics.fromJson(json['statistics'] ?? {}),
      permissions: List<String>.from(json['permissions'] ?? []),
      lastLogin: DateTime.parse(json['last_login']),
      isVerified: json['is_verified'] ?? false,
    );
  }
}

class OrganizationDetails {
  final String id;
  final String name;
  final OrganizationInfo details;

  OrganizationDetails({
    required this.id,
    required this.name,
    required this.details,
  });

  factory OrganizationDetails.fromJson(Map<String, dynamic> json) {
    return OrganizationDetails(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      details: OrganizationInfo.fromJson(json['details'] ?? {}),
    );
  }
}

class OrganizationInfo {
  final String id;
  final String name;
  final String address;
  final String contactPerson;
  final String contactEmail;
  final String contactNumber;
  final int totalEmployees;

  OrganizationInfo({
    required this.id,
    required this.name,
    required this.address,
    required this.contactPerson,
    required this.contactEmail,
    required this.contactNumber,
    required this.totalEmployees,
  });

  factory OrganizationInfo.fromJson(Map<String, dynamic> json) {
    return OrganizationInfo(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      contactPerson: json['contact_person'] ?? '',
      contactEmail: json['contact_email'] ?? '',
      contactNumber: json['contact_number'] ?? '',
      totalEmployees: json['total_employees'] ?? 0,
    );
  }
}

class Statistics {
  final int totalEmployees;
  final double totalSales;
  final int totalOrders;

  Statistics({
    required this.totalEmployees,
    required this.totalSales,
    required this.totalOrders,
  });

  factory Statistics.fromJson(Map<String, dynamic> json) {
    return Statistics(
      totalEmployees: json['total_employees'] ?? 0,
      totalSales: (json['total_sales'] as num?)?.toDouble() ?? 0.0,
      totalOrders: json['total_orders'] ?? 0,
    );
  }
}