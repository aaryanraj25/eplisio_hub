class Admin {
  final String email;
  final String name;
  final String phone;

  Admin({
    required this.email,
    required this.name,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'phone': phone,
    };
  }

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
    );
  }
}

