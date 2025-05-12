import 'package:eplisio_hub/core/constants/api_client.dart';
import 'package:eplisio_hub/features/orders/data/model/orders_model.dart';
import 'package:get_storage/get_storage.dart';

class OrderRepository {
  final ApiClient apiClient;
  final _storage = GetStorage();

  OrderRepository({required this.apiClient});

  Map<String, String> get _headers {
    final token = _storage.read('token');
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Future<OrdersResponse> getOrders(
    String status, {
    required int page,
    int limit = 10,
  }) async {
    try {
      final response = await apiClient.get(
        '/orders/admin/admin/orders',
        queryParameters: {
          'status': status,
          'page': page,
          'limit': limit,
        },
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return OrdersResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch orders');
      }
    } catch (e) {
      throw Exception('Failed to fetch orders: $e');
    }
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      final response = await apiClient.put(  // Changed to PATCH
        '/orders/admin/admin/orders/$orderId/status?status=$status',  // Added status as query parameter
        headers: _headers,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update order status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating order status: $e');
      throw Exception('Failed to update order status: $e');
    }
  }
}