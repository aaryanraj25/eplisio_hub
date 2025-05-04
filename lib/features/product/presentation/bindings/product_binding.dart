import 'package:get/get.dart';
import '../../data/repo/product_repo.dart';
import '../controller/product_controller.dart';
import '../../../../core/constants/api_client.dart';

class ProductBinding implements Bindings {
  @override
  void dependencies() {
    // Register dependencies in the correct order
    _registerApiClient();
    _registerProductRepository();
    _registerProductController();
  }

  void _registerApiClient() {
    if (!Get.isRegistered<ApiClient>()) {
      Get.put(ApiClient(), permanent: true);
    }
  }

  void _registerProductRepository() {
    if (!Get.isRegistered<ProductRepository>()) {
      Get.put(ProductRepository(
        apiClient: Get.find<ApiClient>(),
      ));
    }
  }

  void _registerProductController() {
    if (!Get.isRegistered<ProductController>()) {
      Get.put(ProductController(
        repository: Get.find<ProductRepository>(),
      ));
    }
  }
}