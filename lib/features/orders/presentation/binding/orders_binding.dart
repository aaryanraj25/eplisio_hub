import 'package:eplisio_hub/features/orders/presentation/controller/orders_controller.dart';
import 'package:get/get.dart';
import '../../data/repo/orders_repo.dart';
import '../../../../core/constants/api_client.dart';

class OrderBinding extends Bindings {
  @override
  void dependencies() {
    // Register ApiClient if not already registered
    if (!Get.isRegistered<ApiClient>()) {
      Get.put(ApiClient());
    }

    // Register OrderRepository
    Get.lazyPut<OrderRepository>(
      () => OrderRepository(apiClient: Get.find<ApiClient>()),
    );

    // Register OrderController
    Get.lazyPut<OrderController>(
      () => OrderController(Get.find<OrderRepository>()),
    );
  }
}