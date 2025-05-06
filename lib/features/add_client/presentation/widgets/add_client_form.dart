import 'package:eplisio_hub/core/constants/app_colors.dart';
import 'package:eplisio_hub/core/enums/client_capacity.dart';
import 'package:eplisio_hub/features/add_client/presentation/controller/add_client_controller.dart';
import 'package:eplisio_hub/features/add_client/presentation/widgets/form_dropdown.dart';
import 'package:eplisio_hub/features/add_client/presentation/widgets/form_input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClientFormScreen extends StatefulWidget {
  const ClientFormScreen({Key? key}) : super(key: key);

  @override
  State<ClientFormScreen> createState() => _ClientFormScreenState();
}

class _ClientFormScreenState extends State<ClientFormScreen> {
  final ClientController controller = Get.find<ClientController>();
  final _formKey = GlobalKey<FormState>();
  bool isEditMode = false;
  String? clientId;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  void _initializeData() {
    clientId = Get.arguments as String?;
    isEditMode = clientId != null;

    if (isEditMode) {
      controller.getClientById(clientId!);
    } else {
      controller.resetForm();
    }

    setState(() {
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildAppBar(),
      body: Obx(() {
        if (controller.isLoading.value && isEditMode) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          );
        }

        return Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildFormProgress(),
                      const SizedBox(height: 24),
                      _buildPersonalInfoCard(),
                      const SizedBox(height: 16),
                      _buildContactInfoCard(),
                      const SizedBox(height: 16),
                      _buildWorkInfoCard(),
                      const SizedBox(height: 24),
                      if (controller.error.isNotEmpty) _buildErrorMessage(),
                      const SizedBox(height: 100), // Space for bottom button
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
      bottomSheet: _buildBottomSheet(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        isEditMode ? 'Edit Client' : 'Add New Client',
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      iconTheme: const IconThemeData(color: AppColors.primary),
      backgroundColor: Colors.white,
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          color: Colors.grey[200],
          height: 1,
        ),
      ),
    );
  }

  Widget _buildFormProgress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isEditMode ? 'Update Client Information' : 'Create New Client',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3142),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          isEditMode
              ? 'Modify the client details below'
              : 'Fill in the client details below',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInfoCard() {
    return _buildCard(
      icon: Icons.person_outline,
      title: 'Personal Information',
      children: [
        FormInputField(
          controller: controller.nameController,
          label: 'Full Name',
          hint: 'Enter client\'s full name',
          prefixIcon: Icons.person,
          prefixIconColor: AppColors.primary,
          textColor: const Color(0xFF2D3142),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Name is required';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        Obx(() => FormDropdown<ClientCapacity>(
              label: 'Client Capacity',
              hint: 'Select client\'s role',
              prefixIcon: Icons.work_outline,
              value: controller.selectedCapacity.value,
              items: controller.capacityItems,
              onChanged: (value) {
                if (value != null) {
                  controller.selectedCapacity.value = value;
                }
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a capacity';
                }
                return null;
              },
            )),
      ],
    );
  }

  Widget _buildContactInfoCard() {
    return _buildCard(
      icon: Icons.contact_mail_outlined,
      title: 'Contact Information',
      children: [
        FormInputField(
          controller: controller.mobileController,
          label: 'Mobile Number',
          hint: 'Enter mobile number',
          prefixIcon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          prefixIconColor: AppColors.primary,
          textColor: const Color(0xFF2D3142),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Mobile number is required';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        FormInputField(
          controller: controller.emailController,
          label: 'Email Address',
          hint: 'Enter email address',
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          prefixIconColor: AppColors.primary,
          textColor: const Color(0xFF2D3142),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Email is required';
            }
            if (!GetUtils.isEmail(value)) {
              return 'Enter a valid email address';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildWorkInfoCard() {
    return _buildCard(
      icon: Icons.business_center_outlined,
      title: 'Work Information',
      children: [
        FormInputField(
          controller: controller.designationController,
          label: 'Designation',
          hint: 'Enter designation',
          prefixIcon: Icons.work_outline,
          prefixIconColor: AppColors.primary,
          textColor: const Color(0xFF2D3142),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Designation is required';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        FormInputField(
          controller: controller.departmentController,
          label: 'Department',
          hint: 'Enter department',
          prefixIcon: Icons.business_outlined,
          prefixIconColor: AppColors.primary,
          textColor: const Color(0xFF2D3142),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Department is required';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        Obx(() => FormDropdown<String>(
              label: 'Associated Clinic',
              hint: 'Select clinic',
              prefixIcon: Icons.local_hospital_outlined,
              value: controller.selectedHospitalId.value,
              items: controller.hospitals.map((hospital) {
                return DropdownMenuItem<String>(
                  value: hospital.id,
                  child: Text(hospital.name),
                );
              }).toList(),
              onChanged: (value) {
                controller.selectedHospitalId.value = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a clinic';
                }
                return null;
              },
            )),
      ],
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.withOpacity(0.1),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: AppColors.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red[100]!),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red[700],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              controller.error.value,
              style: TextStyle(
                color: Colors.red[700],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSheet() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: SafeArea(
        child: Obx(() => ElevatedButton(
              onPressed: controller.isSubmitting.value
                  ? null
                  : () {
                      if (_formKey.currentState!.validate()) {
                        if (isEditMode) {
                          controller.updateClient();
                        } else {
                          controller.createClient();
                        }
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: controller.isSubmitting.value
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Please wait...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isEditMode ? Icons.check : Icons.add,
                          size: 20,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isEditMode ? 'Update Client' : 'Add Client',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
            )),
      ),
    );
  }
}
