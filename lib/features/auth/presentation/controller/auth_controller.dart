import 'package:eplisio_hub/core/routes/app_routes.dart';
import 'package:eplisio_hub/features/auth/data/model/user_model.dart';
import 'package:eplisio_hub/features/auth/data/repo/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository;

  // Controllers
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  // Observable states
  final _isPasswordVisible = false.obs;
  final _isLoading = false.obs;
  final _errorMessage = ''.obs;
  final _isAuthenticated = false.obs;

  // Getters
  bool get isPasswordVisible => _isPasswordVisible.value;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  bool get isAuthenticated => _isAuthenticated.value;

  // Constructor with dependency injection
  AuthController({required AuthRepository authRepository})
      : _authRepository = authRepository {
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void onInit() {
    super.onInit();
    checkAuthStatus();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // Check initial auth status
  void checkAuthStatus() {
    _isAuthenticated.value = _authRepository.isLoggedIn();
    if (_isAuthenticated.value) {
      Get.offAllNamed(Routes.DASHBOARD);
    }
  }

  void togglePasswordVisibility() {
    _isPasswordVisible.value = !_isPasswordVisible.value;
  }

  void clearError() {
    _errorMessage.value = '';
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.9),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(8),
      borderRadius: 8,
    );
  }

  void _showSuccessSnackbar(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.9),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(8),
      borderRadius: 8,
    );
  }

  Future<void> login() async {
    try {
      // Clear previous error
      clearError();

      final email = emailController.text.trim();
      final password = passwordController.text;

      // Validate input
      final emailError = validateEmail(email);
      final passwordError = validatePassword(password);

      if (emailError != null || passwordError != null) {
        _errorMessage.value = emailError ?? passwordError ?? 'Invalid input';
        _showErrorSnackbar(_errorMessage.value);
        return;
      }

      _isLoading.value = true;

      final response = await _authRepository.login(email, password);

      if (response.success && response.token != null) {
        _isAuthenticated.value = true;

        // Clear form
        emailController.clear();
        passwordController.clear();

        // Show success message if provided
        if (response.message != null) {
          Get.snackbar(
            'Success',
            response.message!,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withOpacity(0.9),
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
            margin: const EdgeInsets.all(8),
            borderRadius: 8,
          );
        }

        // Navigate to dashboard
        Get.offAllNamed(Routes.DASHBOARD);
      } else {
        // Handle specific error messages
        _errorMessage.value = response.error ?? 'Login failed';
        _showErrorSnackbar(_errorMessage.value);

        // Log detailed error for debugging
        if (response.error != null) {
          debugPrint('Login error: ${response.error}');
        }
      }
    } catch (e) {
      // Handle unexpected errors
      _errorMessage.value = 'An unexpected error occurred';
      _showErrorSnackbar(_errorMessage.value);
      debugPrint('Login error: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  // Add helper method to access organization details
  OrganizationModel? get organization =>
      _authRepository.currentOrganization.value;

  // Add helper method to access user details
  UserModel? get user => _authRepository.currentUser.value;

  // Add method to check if organization data is available
  bool get hasOrganizationData => organization != null;

  // Add method to get organization name
  String get organizationName => organization?.name ?? 'Organization';

  // Add method to get user name
  String get userName => user?.name ?? 'User';

  // Add method to get user role
  String get userRole => user?.role ?? 'User';

  // Add method to get user email
  String get userEmail => user?.email ?? '';

  Future<void> forgotPassword() async {
    try {
      final email = emailController.text.trim();

      final emailError = validateEmail(email);
      if (emailError != null) {
        _showErrorSnackbar(emailError);
        return;
      }

      _isLoading.value = true;

      final success = await _authRepository.forgotPassword(email);

      if (success) {
        _showSuccessSnackbar(
            'Password reset instructions have been sent to your email');
      } else {
        _showErrorSnackbar('Failed to process password reset request');
      }
    } catch (e) {
      _showErrorSnackbar('An unexpected error occurred');
      debugPrint('Forgot password error: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      _isLoading.value = true;
      await _authRepository.logout();
      _isAuthenticated.value = false;
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      _showErrorSnackbar('Failed to logout');
      debugPrint('Logout error: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  // Helper method to check authentication status
  bool isLoggedIn() => _isAuthenticated.value;
}
