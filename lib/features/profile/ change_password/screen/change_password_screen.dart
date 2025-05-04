import 'package:eplisio_hub/core/constants/app_colors.dart';
import 'package:eplisio_hub/features/profile/%20change_password/controller/change_password_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  ChangePasswordController get controller =>
      Get.find<ChangePasswordController>();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Change Password', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 32),
                  _buildPasswordFields(),
                  const SizedBox(height: 32),
                  _buildSubmitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Create New Password',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Your new password must be different from your current password',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordFields() {
    return Column(
      children: [
        _buildPasswordField(
          controller: _currentPasswordController,
          label: 'Current Password',
          hint: 'Enter your current password',
          isVisible: controller.isCurrentPasswordVisible,
          toggleVisibility: controller.toggleCurrentPasswordVisibility,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your current password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
        ),
        const SizedBox(height: 24),
        _buildPasswordField(
          controller: _newPasswordController,
          label: 'New Password',
          hint: 'Enter your new password',
          isVisible: controller.isNewPasswordVisible,
          toggleVisibility: controller.toggleNewPasswordVisibility,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a new password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            if (value == _currentPasswordController.text) {
              return 'New password must be different from current password';
            }
            return null;
          },
        ),
        const SizedBox(height: 24),
        _buildPasswordField(
          controller: _confirmPasswordController,
          label: 'Confirm New Password',
          hint: 'Confirm your new password',
          isVisible: controller.isConfirmPasswordVisible,
          toggleVisibility: controller.toggleConfirmPasswordVisibility,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please confirm your new password';
            }
            if (value != _newPasswordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),
      ],
    );
  }

  // lib/features/profile/presentation/screens/change_password_screen.dart

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required RxBool isVisible, // Changed to RxBool
    required VoidCallback toggleVisibility,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: !isVisible.value, // Use .value here
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
              ),
            ),
            suffixIcon: Obx(() => IconButton(
                  icon: Icon(
                    isVisible.value ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey.shade600,
                  ),
                  onPressed: toggleVisibility,
                )),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Widget buildPasswordFields() {
    return Column(
      children: [
        _buildPasswordField(
          controller: _currentPasswordController,
          label: 'Current Password',
          hint: 'Enter your current password',
          isVisible: controller
              .isCurrentPasswordVisible, // Pass the Rx variable directly
          toggleVisibility: controller.toggleCurrentPasswordVisibility,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your current password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
        ),
        const SizedBox(height: 24),
        _buildPasswordField(
          controller: _newPasswordController,
          label: 'New Password',
          hint: 'Enter your new password',
          isVisible:
              controller.isNewPasswordVisible, // Pass the Rx variable directly
          toggleVisibility: controller.toggleNewPasswordVisibility,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a new password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            if (value == _currentPasswordController.text) {
              return 'New password must be different from current password';
            }
            return null;
          },
        ),
        const SizedBox(height: 24),
        _buildPasswordField(
          controller: _confirmPasswordController,
          label: 'Confirm New Password',
          hint: 'Confirm your new password',
          isVisible: controller
              .isConfirmPasswordVisible, // Pass the Rx variable directly
          toggleVisibility: controller.toggleConfirmPasswordVisibility,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please confirm your new password';
            }
            if (value != _newPasswordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: Obx(() => ElevatedButton(
            onPressed: controller.isLoading.value
                ? null
                : () {
                    if (_formKey.currentState!.validate()) {
                      controller.changePassword(
                        currentPassword: _currentPasswordController.text,
                        newPassword: _newPasswordController.text,
                      );
                    }
                  },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: controller.isLoading.value
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Change Password',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
          )),
    );
  }
}
