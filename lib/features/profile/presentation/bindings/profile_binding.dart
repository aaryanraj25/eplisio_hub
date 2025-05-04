import 'package:eplisio_hub/core/constants/api_client.dart';
import 'package:eplisio_hub/features/profile/data/repo/profile_repo.dart';
import 'package:eplisio_hub/features/profile/presentation/controller/profile_controller.dart';
import 'package:get/get.dart';

class ProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(ProfileRepository(apiClient: Get.find<ApiClient>()));
    Get.put(ProfileController(repository: Get.find<ProfileRepository>()));
  }
}