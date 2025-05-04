import 'package:eplisio_hub/core/constants/api_client.dart';
import 'package:eplisio_hub/features/employee/data/model/employee_model.dart';

class EmployeeRepository {
  final ApiClient _apiClient;

  EmployeeRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<List<EmployeeModel>> getEmployees() async {
    try {
      final response = await _apiClient.get('/admin/admin/employees');
      
      if (response.statusCode == 200) {
        final employees = (response.data['employees'] as List)
            .map((json) => EmployeeModel.fromJson(json))
            .toList();
        return employees;
      }
      
      throw Exception('Failed to fetch employees');
    } catch (e) {
      throw Exception('Failed to fetch employees: $e');
    }
  }

  Future<void> createEmployee({
    required String name,
    required String email,
  }) async {
    try {
      final response = await _apiClient.post(
        '/admin/create-employee',
        queryParameters: {
          'name': name,
          'email': email,
        },
      );
      
      if (response.statusCode != 200) {
        throw Exception('Failed to create employee');
      }
    } catch (e) {
      throw Exception('Failed to create employee: $e');
    }
  }
}