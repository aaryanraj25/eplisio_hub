import 'package:eplisio_hub/core/constants/api_client.dart';
import 'package:get/get.dart';
import '../../data/repo/auth_repo.dart';
import '../controller/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Register ApiClient if not already registered
    if (!Get.isRegistered<ApiClient>()) {
      Get.put(ApiClient(), permanent: true);
    }
    
    // Register AuthRepository with ApiClient dependency
    Get.lazyPut<AuthRepository>(
      () => AuthRepository(Get.find<ApiClient>()),
      fenix: true, // Keep instance alive
    );
    
    // Register AuthController with AuthRepository dependency
    Get.lazyPut<AuthController>(
      () => AuthController(authRepository: Get.find<AuthRepository>()),
    );
  }
}