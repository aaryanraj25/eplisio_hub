import 'package:eplisio_hub/features/profile/data/model/profile_model.dart';
import 'package:eplisio_hub/features/profile/data/repo/profile_repo.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfileController extends GetxController {
  final ProfileRepository _repository;
  final _profile = Rxn<AdminProfileModel>();
  final _isLoading = false.obs;
  final _error = ''.obs;

  ProfileController({required ProfileRepository repository})
      : _repository = repository;

  // Getters
  AdminProfileModel? get profile => _profile.value;
  bool get isLoading => _isLoading.value;
  String get error => _error.value;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      _isLoading.value = true;
      _error.value = '';
      final profile = await _repository.getAdminProfile();
      _profile.value = profile;
    } catch (e) {
      _error.value = 'Failed to load profile';
    } finally {
      _isLoading.value = false;
    }
  }

  void logout() {
    // Clear storage
    GetStorage().erase();
    // Navigate to login
    Get.offAllNamed('/login');
  }

  void navigateToEditProfile() => Get.toNamed('/edit-profile');
  void navigateToAddAdmin() => Get.toNamed('/add-admin');
  void navigateToOrders() => Get.toNamed('/orders');
  void navigateToAddHospital() => Get.toNamed('/hospital');
  void navigateToAddClient() => Get.toNamed('/client');
  void navigateToChangePassword() => Get.toNamed('/change-password');
}