import 'package:eplisio_hub/features/auth/data/repo/auth_repo.dart';
import 'package:eplisio_hub/features/profile/data/repo/profile_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordController extends GetxController {
  final ProfileRepository _repository;
  
  // Make these public by removing the underscore
  final isLoading = false.obs;
  final isCurrentPasswordVisible = false.obs;
  final isNewPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;

  ChangePasswordController({required ProfileRepository repository})
      : _repository = repository;

  void toggleCurrentPasswordVisibility() => 
      isCurrentPasswordVisible.value = !isCurrentPasswordVisible.value;

  void toggleNewPasswordVisibility() => 
      isNewPasswordVisible.value = !isNewPasswordVisible.value;

  void toggleConfirmPasswordVisibility() => 
      isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      isLoading.value = true;
      await _repository.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      
      // Show success dialog and handle logout
      await _showSuccessDialog();
      
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to change password. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _showSuccessDialog() async {
    await Get.dialog(
      WillPopScope(
        onWillPop: () async => false, // Prevent dialog dismissal on back press
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.green,
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Password Changed Successfully',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Your password has been changed successfully. Please login again with your new password.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      Get.back(); // Close dialog
                      await _handleLogout();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Login Again',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false, // Prevent dialog dismissal on outside tap
    );
  }

  Future<void> _handleLogout() async {
    try {
      // Show loading dialog
      Get.dialog(
        WillPopScope(
          onWillPop: () async => false,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        barrierDismissible: false,
      );

      // Perform logout
      await Get.find<AuthService>().logout();
      
      // Navigate to login screen
      Get.offAllNamed('/login');
      
      // Show success message
      Get.snackbar(
        'Success',
        'Please login with your new password',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.back(); // Close loading dialog
      Get.snackbar(
        'Error',
        'Failed to logout. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        duration: const Duration(seconds: 3),
      );
    }
  }
}