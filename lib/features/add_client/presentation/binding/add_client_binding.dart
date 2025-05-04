import 'package:eplisio_hub/core/constants/api_client.dart';
import 'package:eplisio_hub/features/add_client/data/repo/add_client_repo.dart';
import 'package:eplisio_hub/features/add_client/presentation/controller/add_client_controller.dart';
import 'package:eplisio_hub/features/add_hospital/data/repo/hospital_repo.dart';
import 'package:get/get.dart';

class ClientBinding extends Bindings {
  @override
  void dependencies() {
    // ApiClient singleton
    Get.lazyPut<ApiClient>(() => ApiClient(), fenix: true);
    
    // Repositories
    Get.lazyPut<ClientRepository>(
      () => ClientRepository(Get.find<ApiClient>()),
      fenix: true,
    );

    Get.lazyPut(() => HospitalRepository(apiClient: Get.find()));
    
    
    // Controllers
    Get.lazyPut<ClientController>(
      () => ClientController(
        clientRepository: Get.find<ClientRepository>(),
        hospitalRepository: Get.find<HospitalRepository>(),
      ),
      fenix: true,
    );
  }
}