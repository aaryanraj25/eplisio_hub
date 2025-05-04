import 'package:eplisio_hub/core/constants/api_client.dart';
import 'package:eplisio_hub/features/add_hospital/data/repo/hospital_repo.dart';
import 'package:get/get.dart';
import '../controller/hospital_controller.dart';

class HospitalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApiClient()); // Make sure you have this registered
    Get.lazyPut(() => HospitalRepository(apiClient: Get.find()));
    Get.lazyPut(() => HospitalController(Get.find()));
  }
}

