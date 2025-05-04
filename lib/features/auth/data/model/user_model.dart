class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
    };
  }
}

class OrganizationModel {
  final String id;
  final String name;

  OrganizationModel({
    required this.id,
    required this.name,
  });

  factory OrganizationModel.fromJson(Map<String, dynamic> json) {
    return OrganizationModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class AuthResponseModel {
  final bool success;
  final String? message;
  final String? token;
  final UserModel? user;
  final OrganizationModel? organization;
  final String? error;

  AuthResponseModel({
    required this.success,
    this.message,
    this.token,
    this.user,
    this.organization,
    this.error,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      success: json['success'] ?? false,
      message: json['message'],
      token: json['token'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      organization: json['organization'] != null 
          ? OrganizationModel.fromJson(json['organization']) 
          : null,
      error: json['error'],
    );
  }
}