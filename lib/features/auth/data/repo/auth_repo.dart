import 'package:eplisio_hub/core/constants/api_client.dart';
import 'package:eplisio_hub/features/auth/data/model/user_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthRepository extends GetxController {
  final ApiClient _apiClient;
  final _storage = GetStorage();
  final _isLoading = false.obs;
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxString _token = ''.obs;
  final Rx<OrganizationModel?> currentOrganization =
      Rx<OrganizationModel?>(null);

  AuthRepository(this._apiClient);

  bool get isLoading => _isLoading.value;
  String get token => _token.value;

  @override
  void onInit() {
    super.onInit();
    _loadUserFromStorage();
  }

  void _loadUserFromStorage() {
    try {
      final userData = _storage.read('user');
      final orgData = _storage.read('organization');
      final storedToken = _storage.read('token');

      if (userData != null) {
        currentUser.value = UserModel.fromJson(userData);
        _token.value = storedToken ?? '';
      }

      if (orgData != null) {
        currentOrganization.value = OrganizationModel.fromJson(orgData);
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future<void> _saveUserToStorage(
    UserModel user,
    OrganizationModel organization,
    String token,
  ) async {
    await _storage.write('user', user.toJson());
    await _storage.write('organization', organization.toJson());
    await _storage.write('token', token);
  }

  Future<AuthResponseModel> login(String email, String password) async {
    try {
      _isLoading.value = true;

      final response = await _apiClient.post(
        '/admin/admin-login',
        queryParameters: {
          'email': email,
          'password': password,
        },
      );

      final authResponse = AuthResponseModel.fromJson(response.data);

      if (authResponse.success &&
          authResponse.user != null &&
          authResponse.organization != null) {
        await _saveUserToStorage(
          authResponse.user!,
          authResponse.organization!,
          authResponse.token!,
        );

        currentUser.value = authResponse.user;
        currentOrganization.value = authResponse.organization;
        _token.value = authResponse.token!;
      }

      return authResponse;
    } catch (e) {
      return AuthResponseModel(
        success: false,
        error: e.toString(),
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<bool> forgotPassword(String email) async {
    try {
      _isLoading.value = true;

      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 2));

      // Simulate password reset email sent
      return true;
    } catch (e) {
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  bool isLoggedIn() {
    return currentUser.value != null && _token.value.isNotEmpty;
  }

  Future<void> logout() async {
    await _storage.erase(); // Clear all stored data
    Get.offAllNamed('/login'); // Navigate to login screen
  }
}

class AuthService extends GetxService {
  final GetStorage _storage = GetStorage();

  Future<void> logout() async {
    await _storage.erase(); // Clear all stored data
    Get.offAllNamed('/login'); // Navigate to login screen
  }
}
