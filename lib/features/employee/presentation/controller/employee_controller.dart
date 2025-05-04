import 'package:eplisio_hub/features/employee/data/model/employee_model.dart';
import 'package:eplisio_hub/features/employee/data/repo/employee_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmployeeController extends GetxController {
  final EmployeeRepository _repository;
  final _employees = <EmployeeModel>[].obs;
  final _isLoading = false.obs;
  final _error = ''.obs;
  final _searchQuery = ''.obs;

  EmployeeController({required EmployeeRepository repository})
      : _repository = repository;

  // Getters
  List<EmployeeModel> get employees => _employees;
  bool get isLoading => _isLoading.value;
  String get error => _error.value;
  String get searchQuery => _searchQuery.value;

  // Filtered employees
  List<EmployeeModel> get filteredEmployees {
    if (_searchQuery.value.isEmpty) return _employees;
    return _employees.where((employee) {
      return employee.name.toLowerCase().contains(_searchQuery.value.toLowerCase()) ||
             employee.email.toLowerCase().contains(_searchQuery.value.toLowerCase());
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    loadEmployees();
  }

  Future<void> loadEmployees() async {
    try {
      _isLoading.value = true;
      _error.value = '';
      final employees = await _repository.getEmployees();
      _employees.value = employees;
    } catch (e) {
      _error.value = 'Failed to load employees';
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> createEmployee(String name, String email) async {
    try {
      _isLoading.value = true;
      await _repository.createEmployee(name: name, email: email);
      await loadEmployees(); // Refresh list
      Get.back(); // Close dialog
      Get.snackbar(
        'Success',
        'Employee created successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create employee',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  void setSearchQuery(String query) {
    _searchQuery.value = query;
  }

  void navigateToEmployeeDetails(String employeeId) {
    Get.toNamed('/employee-details/$employeeId');
  }
}