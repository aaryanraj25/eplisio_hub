import 'package:eplisio_hub/core/constants/api_client.dart';
import 'package:eplisio_hub/features/employee_detail/data/model/employee_detail_model.dart';

class EmployeeDetailRepository {
  final ApiClient _apiClient;

  EmployeeDetailRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<EmployeeDetailModel> getEmployeeDetails(
    String employeeId, {
    String? startDate,
    String? endDate,
    String? orderStatus,
    String? attendanceStatus,
  }) async {
    try {
      final response = await _apiClient.get(
        '/admin/admin/employee/$employeeId',
        queryParameters: {
          if (startDate != null) 'start_date': startDate,
          if (endDate != null) 'end_date': endDate,
          if (orderStatus != null) 'order_status': orderStatus,
          if (attendanceStatus != null) 'attendance_status': attendanceStatus,
        },
      );
      
      return EmployeeDetailModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch employee details: $e');
    }
  }

  Future<EmployeeLocationModel> getEmployeeLocation(String employeeId) async {
    try {
      final response = await _apiClient.get('/admin/employee-location/$employeeId');
      return EmployeeLocationModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch employee location: $e');
    }
  }

  Future<List<TrackingModel>> getEmployeeTracking(String employeeId, {String? date}) async {
    try {
      final response = await _apiClient.get(
        '/admin/employee-tracking',
        queryParameters: {
          'employee_id': employeeId,
          if (date != null) 'date': date,
        },
      );
      return (response.data as List).map((e) => TrackingModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to fetch employee tracking: $e');
    }
  }
}

