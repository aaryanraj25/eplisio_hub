class AddClientModel {
  final String? id;
  final String name;
  final String designation;
  final String department;
  final String clinicId;
  final String mobile;
  final String email;
  final String capacity;
  final String? clinicName;
  final String? organizationId;
  final String? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AddClientModel({
    this.id,
    required this.name,
    required this.designation,
    required this.department,
    required this.clinicId,
    required this.mobile,
    required this.email,
    required this.capacity,
    this.clinicName,
    this.organizationId,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory AddClientModel.fromJson(Map<String, dynamic> json) {
    return AddClientModel(
      id: json['_id'],
      name: json['name'],
      designation: json['designation'],
      department: json['department'],
      clinicId: json['clinic_id'],
      mobile: json['mobile'],
      email: json['email'],
      capacity: json['capacity'],
      clinicName: json['clinic_name'],
      organizationId: json['organization_id'],
      createdBy: json['created_by'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'designation': designation,
      'department': department,
      'clinic_id': clinicId,
      'mobile': mobile,
      'email': email,
      'capacity': capacity,
    };
    
    // Add optional fields if they're not null
    if (id != null) data['_id'] = id;
    if (clinicName != null) data['clinic_name'] = clinicName;
    if (organizationId != null) data['organization_id'] = organizationId;
    if (createdBy != null) data['created_by'] = createdBy;
    
    return data;
  }
}