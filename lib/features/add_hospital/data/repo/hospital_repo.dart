import 'package:eplisio_hub/core/constants/api_client.dart';
import 'package:eplisio_hub/features/add_hospital/data/model/hospital_model.dart';
import 'package:get_storage/get_storage.dart';

class HospitalRepository {
  final ApiClient apiClient;
  final _storage = GetStorage();

  HospitalRepository({required this.apiClient});

  // Helper method to get auth headers
  Map<String, String> get _headers {
    final token = _storage.read('token');
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Future<List<HospitalSearchResult>> searchHospitals(String query) async {
    try {
      final response = await apiClient.get(
        '/hospital/search',
        queryParameters: {'name': query},
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data ?? [];
        return data.map((x) => HospitalSearchResult.fromJson(x)).toList();
      } else {
        throw Exception(
            'Failed to search hospitals: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to search hospitals: $e');
    }
  }

  Future<Hospital> addHospital(String placeId) async {
    try {
      final response = await apiClient.post(
        '/hospital/admin/clinics/google-place',
        queryParameters: {'place_id': placeId},
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return Hospital.fromJson(response.data);
      } else {
        throw Exception('Failed to add hospital: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to add hospital: $e');
    }
  }

  Future<List<Hospital>> getHospitals({
    int skip = 0,
    int limit = 10,
    String? search,
    String? type,
    String? city,
    String? state,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {
        'skip': skip,
        'limit': limit,
        if (search != null) 'search': search,
        if (type != null) 'type': type,
        if (city != null) 'city': city,
        if (state != null) 'state': state,
      };

      final response = await apiClient.get(
        '/hospital/admin/clinics',
        queryParameters: queryParams,
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['hospitals'] ?? [];
        return data.map((x) => Hospital.fromJson(x)).toList();
      } else {
        throw Exception('Failed to get hospitals: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to get hospitals: $e');
    }
  }
}
