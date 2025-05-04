class HospitalSearchResult {
  final String placeId;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final double? rating;

  HospitalSearchResult({
    required this.placeId,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.rating,
  });

  factory HospitalSearchResult.fromJson(Map<String, dynamic> json) {
    return HospitalSearchResult(
      placeId: json['place_id'],
      name: json['name'],
      address: json['address'],
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      rating: json['rating']?.toDouble(),
    );
  }
}

class Hospital {
  final String id;
  final String name;
  final String address;
  final String city;
  final String state;
  final String country;
  final String pincode;
  final String? phone;
  final String? email;
  final String? website;
  final double latitude;
  final double longitude;
  final List<String>? specialties;
  final String type;
  final String status;
  final String organizationId;
  final String addedBy;
  final String addedByRole;
  final DateTime createdAt;
  final String googlePlaceId;
  final double? rating;

  Hospital({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.pincode,
    this.phone,
    this.email,
    this.website,
    required this.latitude,
    required this.longitude,
    this.specialties,
    required this.type,
    required this.status,
    required this.organizationId,
    required this.addedBy,
    required this.addedByRole,
    required this.createdAt,
    required this.googlePlaceId,
    this.rating,
  });

  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      pincode: json['pincode'],
      phone: json['phone'],
      email: json['email'],
      website: json['website'],
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      specialties: List<String>.from(json['specialties'] ?? []),
      type: json['type'],
      status: json['status'],
      organizationId: json['organization_id'],
      addedBy: json['added_by'],
      addedByRole: json['added_by_role'],
      createdAt: DateTime.parse(json['created_at']),
      googlePlaceId: json['google_place_id'],
      rating: json['rating']?.toDouble(),
    );
  }
}

class HospitalListResponse {
  final int totalHospitals;
  final List<Hospital> hospitals;

  HospitalListResponse({
    required this.totalHospitals,
    required this.hospitals,
  });

  factory HospitalListResponse.fromJson(Map<String, dynamic> json) {
    return HospitalListResponse(
      totalHospitals: json['total_hospitals'] ?? 0,
      hospitals: (json['hospitals'] as List?)
              ?.map((x) => Hospital.fromJson(x))
              .toList() ??
          [],
    );
  }
}