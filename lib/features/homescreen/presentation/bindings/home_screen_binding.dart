import 'package:get/get.dart';
import '../../../../core/constants/api_client.dart';
import '../../data/repo/home_screen_repo.dart';
import '../controller/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Register ApiClient if not already registered
    if (!Get.isRegistered<ApiClient>()) {
      Get.put(ApiClient());
    }
    
    // Register repositories
    Get.lazyPut(() => HomeScreenRepository(apiClient: Get.find<ApiClient>()));
    
    // Register controllers
    Get.lazyPut(() => HomeController(repository: Get.find<HomeScreenRepository>()));
  }
}