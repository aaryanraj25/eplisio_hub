import 'package:eplisio_hub/features/add_client/data/model/add_client_model.dart';
import 'package:eplisio_hub/features/add_client/data/repo/add_client_repo.dart';
import 'package:eplisio_hub/features/add_hospital/data/model/hospital_model.dart';
import 'package:eplisio_hub/features/add_hospital/data/repo/hospital_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClientController extends GetxController {
  final ClientRepository clientRepository;
  final HospitalRepository hospitalRepository;

  ClientController({
    required this.clientRepository,
    required this.hospitalRepository,
  });

  // Observables
  final RxList<AddClientModel> clients = <AddClientModel>[].obs;
  final RxList<Hospital> hospitals = <Hospital>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxString error = ''.obs;
  
  // Selected client for details/editing
  final Rx<AddClientModel?> selectedClient = Rx<AddClientModel?>(null);
  
  // Form controllers
  final nameController = TextEditingController();
  final designationController = TextEditingController();
  final departmentController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  
  // Fixed capacity as 'admin'
  final String capacity = 'admin';
  
  final Rx<String?> selectedHospitalId = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchClients();
    fetchHospitals();
  }

  @override
  void onClose() {
    nameController.dispose();
    designationController.dispose();
    departmentController.dispose();
    mobileController.dispose();
    emailController.dispose();
    super.onClose();
  }

  // Fetch all clients
  Future<void> fetchClients() async {
    try {
      isLoading.value = true;
      error.value = '';
      final fetchedClients = await clientRepository.getClients();
      clients.value = fetchedClients;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch all hospitals
  Future<void> fetchHospitals() async {
    try {
      isLoading.value = true;
      error.value = '';
      final response = await hospitalRepository.getHospitals();
      hospitals.value = response;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Get client by ID
  Future<void> getClientById(String clientId) async {
    try {
      isLoading.value = true;
      error.value = '';
      final client = await clientRepository.getClientById(clientId);
      selectedClient.value = client;
      
      // Populate form controllers
      populateFormControllers(client);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Create a new client
  Future<void> createClient() async {
    if (!validateForm()) return;
    
    try {
      isSubmitting.value = true;
      error.value = '';
      
      final newClient = AddClientModel(
        name: nameController.text,
        designation: designationController.text,
        department: departmentController.text,
        clinicId: selectedHospitalId.value!,
        mobile: mobileController.text,
        email: emailController.text,
        capacity: capacity, // Always set to 'admin'
      );
      
      await clientRepository.createClient(newClient);
      resetForm();
      await fetchClients();
      Get.back(); // Return to list screen
      Get.snackbar(
        'Success',
        'Client created successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to create client: ${error.value}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  // Update an existing client
  Future<void> updateClient() async {
    if (!validateForm() || selectedClient.value == null) return;
    
    try {
      isSubmitting.value = true;
      error.value = '';
      
      final updatedClient = AddClientModel(
        id: selectedClient.value!.id,
        name: nameController.text,
        designation: designationController.text,
        department: departmentController.text,
        clinicId: selectedHospitalId.value!,
        mobile: mobileController.text,
        email: emailController.text,
        capacity: capacity, // Always set to 'admin'
      );
      
      await clientRepository.updateClient(
        selectedClient.value!.id!,
        updatedClient,
      );
      
      await fetchClients();
      Get.back(); // Return to list screen
      Get.snackbar(
        'Success',
        'Client updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to update client: ${error.value}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  // Delete a client
  Future<void> deleteClient(String clientId) async {
    try {
      await clientRepository.deleteClient(clientId);
      await fetchClients();
      Get.snackbar(
        'Success',
        'Client deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to delete client: ${error.value}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Filter clients
  Future<void> filterClients({
    String? name,
    String? email,
    String? hospitalId,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';
      final filteredClients = await clientRepository.getClients(
        name: name,
        email: email,
        clinicId: hospitalId,
        capacity: capacity, // Always filter for 'admin'
      );
      clients.value = filteredClients;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Reset form
  void resetForm() {
    nameController.clear();
    designationController.clear();
    departmentController.clear();
    mobileController.clear();
    emailController.clear();
    selectedHospitalId.value = null;
    selectedClient.value = null;
    error.value = '';
  }

  // Populate form controllers for editing
  void populateFormControllers(AddClientModel client) {
    nameController.text = client.name;
    designationController.text = client.designation;
    departmentController.text = client.department;
    mobileController.text = client.mobile;
    emailController.text = client.email;
    selectedHospitalId.value = client.clinicId;
  }

  // Validate form
  bool validateForm() {
    if (nameController.text.isEmpty) {
      error.value = 'Name is required';
      return false;
    }
    if (designationController.text.isEmpty) {
      error.value = 'Designation is required';
      return false;
    }
    if (departmentController.text.isEmpty) {
      error.value = 'Department is required';
      return false;
    }
    if (selectedHospitalId.value == null) {
      error.value = 'Please select a hospital';
      return false;
    }
    if (mobileController.text.isEmpty) {
      error.value = 'Mobile number is required';
      return false;
    }
    if (emailController.text.isEmpty || !GetUtils.isEmail(emailController.text)) {
      error.value = 'Valid email is required';
      return false;
    }
    return true;
  }

  // Get hospital name by ID
  String getHospitalNameById(String hospitalId) {
    final hospital = hospitals.firstWhereOrNull((hospital) => hospital.id == hospitalId);
    return hospital?.name ?? 'Unknown Hospital';
  }
}