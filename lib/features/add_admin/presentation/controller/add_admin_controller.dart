import 'package:eplisio_hub/features/add_admin/data/repo/add_admin_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminController extends GetxController {
  final AdminRepository _repository;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  final RxBool isLoading = false.obs;
  
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  AdminController(this._repository);

  @override
  void onClose() {
    emailController.dispose();
    nameController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  Future<void> createAdmin() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;
      await _repository.createAdmin(
        email: emailController.text.trim(),
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
      );
      
      Get.snackbar(
        'Success',
        'Admin created successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      
      // Clear form
      emailController.clear();
      nameController.clear();
      phoneController.clear();
      
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create admin',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}

// lib/features/admin/presentation/binding/admin_binding.dart