import 'package:eplisio_hub/core/constants/api_client.dart';
import 'package:eplisio_hub/features/auth/data/repo/auth_repo.dart';
import 'package:eplisio_hub/features/profile/%20change_password/controller/change_password_controller.dart';
import 'package:eplisio_hub/features/profile/data/repo/profile_repo.dart';
import 'package:get/get.dart';

class ChangePasswordBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(ProfileRepository(apiClient: Get.find<ApiClient>()));
    Get.put(ChangePasswordController(repository: Get.find<ProfileRepository>()));
    
    // Ensure AuthService is available
    if (!Get.isRegistered<AuthService>()) {
      Get.put(AuthService());
    }
  }
}