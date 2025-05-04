import 'package:eplisio_hub/features/add_client/presentation/controller/add_client_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/form_dropdown.dart';
import '../widgets/form_input_field.dart';

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

  @override
  void initState() {
    super.initState();
    clientId = Get.arguments as String?;
    isEditMode = clientId != null;
    
    if (isEditMode) {
      controller.getClientById(clientId!);
    } else {
      controller.resetForm();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Client' : 'Add Client'),
        actions: [
          if (isEditMode)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                _showDeleteConfirmation(context);
              },
              tooltip: 'Delete Client',
            ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && isEditMode) {
          return const Center(child: CircularProgressIndicator());
        }
        
        return Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Client Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Name field
                        FormInputField(
                          controller: controller.nameController,
                          label: 'Name',
                          hint: 'Enter client name',
                          prefixIcon: Icons.person,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Name is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        // Designation field
                        FormInputField(
                          controller: controller.designationController,
                          label: 'Designation',
                          hint: 'Enter designation',
                          prefixIcon: Icons.work,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Designation is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        // Department field
                        FormInputField(
                          controller: controller.departmentController,
                          label: 'Department',
                          hint: 'Enter department',
                          prefixIcon: Icons.business,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Department is required';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Contact Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Mobile field
                        FormInputField(
                          controller: controller.mobileController,
                          label: 'Mobile',
                          hint: 'Enter mobile number',
                          prefixIcon: Icons.phone,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Mobile number is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        // Email field
                        FormInputField(
                          controller: controller.emailController,
                          label: 'Email',
                          hint: 'Enter email address',
                          prefixIcon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
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
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Additional Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Clinic dropdown
                        Obx(() => FormDropdown<String>(
                          label: 'Clinic',
                          hint: 'Select clinic',
                          prefixIcon: Icons.local_hospital,
                          value: controller.selectedHospitalId.value,
                          items: controller.hospitals.map((clinic) {
                            return DropdownMenuItem<String>(
                              value: clinic.id,
                              child: Text(clinic.name),
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
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                Obx(() => controller.error.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          controller.error.value,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : const SizedBox.shrink()),
                
                ElevatedButton(
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
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: controller.isSubmitting.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(isEditMode ? 'Update Client' : 'Add Client'),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Client'),
        content: const Text(
          'Are you sure you want to delete this client? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              controller.deleteClient(clientId!);
              Get.back();
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}