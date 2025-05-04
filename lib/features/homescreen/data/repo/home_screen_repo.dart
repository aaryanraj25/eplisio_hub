import 'package:eplisio_hub/core/constants/api_client.dart';
import 'package:eplisio_hub/features/homescreen/data/model/home_screen_model.dart';
import 'package:get_storage/get_storage.dart';

class HomeScreenRepository {
  final ApiClient apiClient;
  final _storage = GetStorage();

  HomeScreenRepository({required this.apiClient});

  // Helper method to get auth headers
  Map<String, String> get _headers {
    final token = _storage.read('token');
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Future<OrganizationStatsModel> getOrganizationStats() async {
    try {
      final response = await apiClient.get(
        '/admin/organization-stats',
        headers: _headers,
      );
      
      if (response.statusCode == 200) {
        return OrganizationStatsModel.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch organization stats: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to fetch organization stats: $e');
    }
  }

  Future<List<EmployeePerformanceModel>> getEmployeePerformance() async {
    try {
      final response = await apiClient.get(
        '/admin/employee-performance',
        headers: _headers,
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['employeePerformance'] ?? [];
        return data.map((json) => EmployeePerformanceModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch employee performance: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to fetch employee performance: $e');
    }
  }

  Future<List<TopEmployeeModel>> getTopEmployees() async {
    try {
      final response = await apiClient.get(
        '/admin/top-employees',
        headers: _headers,
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['topEmployees'] ?? [];
        return data.map((json) => TopEmployeeModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch top employees: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to fetch top employees: $e');
    }
  }

  Future<List<TopProductModel>> getTopProducts() async {
    try {
      final response = await apiClient.get(
        '/admin/top-products',
        headers: _headers,
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['topProducts'] ?? [];
        return data.map((json) => TopProductModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch top products: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to fetch top products: $e');
    }
  }

  Future<SalesTrendModel> getSalesTrends() async {
    try {
      final response = await apiClient.get(
        '/admin/sales-trends',
        headers: _headers,
      );
      
      if (response.statusCode == 200) {
        return SalesTrendModel.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch sales trends: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to fetch sales trends: $e');
    }
  }
}