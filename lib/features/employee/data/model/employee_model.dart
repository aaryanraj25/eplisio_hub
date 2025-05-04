// lib/features/employee/data/model/employee_model.dart

class EmployeeModel {
  final String id;
  final String email;
  final String name;
  final String organizationId;
  final String organization;
  final String adminId;
  final DateTime createdAt;
  final String role;
  final bool isActive;
  final LocationModel? location;

  EmployeeModel({
    required this.id,
    required this.email,
    required this.name,
    required this.organizationId,
    required this.organization,
    required this.adminId,
    required this.createdAt,
    required this.role,
    required this.isActive,
    this.location,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['_id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      organizationId: json['organization_id'] ?? '',
      organization: json['organization'] ?? '',
      adminId: json['admin_id'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      role: json['role'] ?? '',
      isActive: json['is_active'] ?? false,
      location: json['location'] != null 
          ? LocationModel.fromJson(json['location']) 
          : null,
    );
  }
}

class LocationModel {
  final double latitude;
  final double longitude;
  final DateTime updatedAt;

  LocationModel({
    required this.latitude,
    required this.longitude,
    required this.updatedAt,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}