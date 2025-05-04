import 'package:eplisio_hub/core/constants/app_colors.dart';
import 'package:eplisio_hub/features/add_admin/presentation/controller/add_admin_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateAdminScreen extends GetView<AdminController> {
  const CreateAdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Admin'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: controller.emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter admin email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                  prefixIconColor: AppColors.primary
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }
                  if (!GetUtils.isEmail(value)) {
                    return 'Please enter valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter admin name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                  prefixIconColor: AppColors.primary
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller.phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  hintText: 'Enter admin phone',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                  prefixIconColor: AppColors.primary
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone';
                  }
                  if (!GetUtils.isPhoneNumber(value)) {
                    return 'Please enter valid phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Obx(() => ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : controller.createAdmin,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: AppColors.primary
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
                        'Create Admin',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}