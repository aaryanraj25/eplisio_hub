import 'package:eplisio_hub/features/employee/presentation/binding/employee_binding.dart';
import 'package:eplisio_hub/features/homescreen/presentation/bindings/home_screen_binding.dart';
import 'package:eplisio_hub/features/product/presentation/bindings/product_binding.dart';
import 'package:eplisio_hub/features/profile/presentation/bindings/profile_binding.dart';
import 'package:get/get.dart';
import '../controller/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());

    HomeBinding().dependencies();

    ProductBinding().dependencies();

    EmployeeBinding().dependencies();

    ProfileBinding().dependencies();


  }
}