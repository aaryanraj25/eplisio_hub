import 'package:eplisio_hub/features/employee/presentation/controller/employee_controller.dart';
import 'package:get/get.dart';
import '../../../../core/constants/api_client.dart';
import '../../data/repo/employee_repo.dart';

class EmployeeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(EmployeeRepository(apiClient: Get.find<ApiClient>()));
    Get.put(EmployeeController(repository: Get.find<EmployeeRepository>()));
  }
}