import 'package:eplisio_hub/core/constants/api_client.dart';
import 'package:eplisio_hub/features/profile/data/model/profile_model.dart';

class ProfileRepository {
  final ApiClient _apiClient;

  ProfileRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<AdminProfileModel> getAdminProfile() async {
    try {
      final response = await _apiClient.get('/admin/admin/profile');
      
      if (response.statusCode == 200) {
        return AdminProfileModel.fromJson(response.data);
      }
      
      throw Exception('Failed to fetch profile');
    } catch (e) {
      throw Exception('Failed to fetch profile: $e');
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _apiClient.post(
        '/admin/admin/profile/change-password',
        queryParameters: {
          'current_password': currentPassword,
          'new_password': newPassword,
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to change password');
      }
    } catch (e) {
      throw Exception('Failed to change password: $e');
    }
  }
}

