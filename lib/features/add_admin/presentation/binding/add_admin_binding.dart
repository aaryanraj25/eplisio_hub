import 'package:eplisio_hub/features/add_admin/data/repo/add_admin_repo.dart';
import 'package:eplisio_hub/features/add_admin/presentation/controller/add_admin_controller.dart';
import 'package:get/get.dart';
import '../../../../core/constants/api_client.dart';

class AdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminRepository>(
      () => AdminRepository(apiClient: Get.find<ApiClient>()),
    );
    Get.lazyPut<AdminController>(
      () => AdminController(Get.find<AdminRepository>()),
    );
  }
}

