import 'package:eplisio_hub/core/constants/api_client.dart';
import 'package:get_storage/get_storage.dart';

class AdminRepository {
  final ApiClient apiClient;
  final _storage = GetStorage();

  AdminRepository({required this.apiClient});

  Map<String, String> get _headers {
    final token = _storage.read('token');
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Future<void> createAdmin({
    required String email,
    required String name,
    required String phone,
  }) async {
    try {
      final response = await apiClient.post(
        '/admin/admin/create-admin',
        queryParameters: {
          'email': email,
          'name': name,
          'phone': phone,
        },
        headers: _headers,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to create admin');
      }
    } catch (e) {
      throw Exception('Failed to create admin: $e');
    }
  }
}

