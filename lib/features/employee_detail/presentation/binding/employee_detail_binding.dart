import 'package:eplisio_hub/core/constants/api_client.dart';
import 'package:eplisio_hub/features/employee_detail/data/repo/employee_detail_repo.dart';
import 'package:eplisio_hub/features/employee_detail/presentation/controller/employee_detail_controller.dart';
import 'package:get/get.dart';

class EmployeeDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(EmployeeDetailRepository(apiClient: Get.find<ApiClient>()));
    Get.put(
      EmployeeDetailController(
        repository: Get.find<EmployeeDetailRepository>(),
        employeeId: Get.parameters['id']!,
      ),
    );
  }
}