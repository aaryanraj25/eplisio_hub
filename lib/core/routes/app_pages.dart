import 'package:eplisio_hub/core/routes/app_routes.dart';
import 'package:eplisio_hub/features/add_admin/presentation/binding/add_admin_binding.dart';
import 'package:eplisio_hub/features/add_admin/presentation/screens/add_admin_screen.dart';
import 'package:eplisio_hub/features/add_client/presentation/binding/add_client_binding.dart';
import 'package:eplisio_hub/features/add_client/presentation/screen/add_client_screen.dart';
import 'package:eplisio_hub/features/add_client/presentation/screen/client_details_screen.dart';
import 'package:eplisio_hub/features/add_client/presentation/widgets/add_client_form.dart';
import 'package:eplisio_hub/features/add_hospital/presentation/binding/hospitals_binding.dart';
import 'package:eplisio_hub/features/add_hospital/presentation/screens/hospital_screen.dart';
import 'package:eplisio_hub/features/auth/presentation/bindings/auth_binding.dart';
import 'package:eplisio_hub/features/auth/presentation/screens/login_screen.dart';
import 'package:eplisio_hub/features/dashboard/presentation/binding/dashboard_binding.dart';
import 'package:eplisio_hub/features/dashboard/presentation/screen/dashboard_screen.dart';
import 'package:eplisio_hub/features/employee_detail/presentation/binding/employee_detail_binding.dart';
import 'package:eplisio_hub/features/employee_detail/presentation/screen/employee_detail_screen.dart';
import 'package:eplisio_hub/features/homescreen/presentation/bindings/home_screen_binding.dart';
import 'package:eplisio_hub/features/homescreen/presentation/screen/home_screen.dart';
import 'package:eplisio_hub/features/orders/presentation/binding/orders_binding.dart';
import 'package:eplisio_hub/features/orders/presentation/screen/orders_screen.dart';
import 'package:eplisio_hub/features/profile/%20change_password/bindings/change_password_binding.dart';
import 'package:eplisio_hub/features/profile/%20change_password/screen/change_password_screen.dart';
import 'package:eplisio_hub/features/profile/presentation/bindings/profile_binding.dart';
import 'package:eplisio_hub/features/profile/presentation/screen/profile_screen.dart';
import 'package:eplisio_hub/features/splash/presentation/screens/splash_screen.dart';
import 'package:get/get.dart';

class AppPages {
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.DASHBOARD,
      page: () => const DashboardScreen(),
      binding: DashboardBinding(),
      bindings: [HomeBinding()],
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),

    GetPage(
      name: Routes.PROFILE,
      page: () => const ProfileScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: '/employee-details/:id',
      page: () => const EmployeeDetailScreen(),
      binding: EmployeeDetailBinding(),
      // Add transition for better UX
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 250),
    ),

    GetPage(
      name: Routes.CHANGEPASSWORD,
      page: () => const ChangePasswordScreen(),
      binding: ChangePasswordBinding(),
    ),

    GetPage(
      name: Routes.HOSPITAL,
      page: () => const HospitalsScreen(),
      binding: HospitalBinding(),
    ),

    GetPage(
      name: Routes.ORDER,
      page: () => const OrdersScreen(),
      binding: OrderBinding(),
    ),

    GetPage(
      name: Routes.ADDADMIN,
      page: () => const CreateAdminScreen(),
      binding: AdminBinding(),
    ),

    GetPage(
      name: Routes.CLIENT,
      page: () => const ClientsScreen(),
      binding: ClientBinding(),
    ),

    GetPage(
      name: Routes.CLIENTDETAIL,
      page: () => const ClientDetailsScreen(),
      binding: ClientBinding(),
    ),

    GetPage(
      name: Routes.CLIENTFORM,
      page: () => const ClientFormScreen(),
      binding: ClientBinding(),
    ),
  ];
}
