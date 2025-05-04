import 'package:eplisio_hub/features/employee_detail/data/model/employee_detail_model.dart';
import 'package:eplisio_hub/features/employee_detail/data/repo/employee_detail_repo.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class EmployeeDetailController extends GetxController {
  final EmployeeDetailRepository _repository;
  final String employeeId;

  final _employeeDetails = Rxn<EmployeeDetailModel>();
  final _location = Rxn<EmployeeLocationModel>();
  final _tracking = <TrackingModel>[].obs;
  final _isLoading = false.obs;
  final _isLocationLoading = false.obs;
  final _isTrackingLoading = false.obs;
  final _error = ''.obs;
  final _selectedDate = DateTime.now().obs;
  final _selectedTab = 0.obs;

  EmployeeDetailController({
    required EmployeeDetailRepository repository,
    required this.employeeId,
  }) : _repository = repository;

  // Getters
  EmployeeDetailModel? get employeeDetails => _employeeDetails.value;
  EmployeeLocationModel? get location => _location.value;
  List<TrackingModel> get tracking => _tracking;
  bool get isLoading => _isLoading.value;
  bool get isLocationLoading => _isLocationLoading.value;
  bool get isTrackingLoading => _isTrackingLoading.value;
  String get error => _error.value;
  DateTime get selectedDate => _selectedDate.value;
  int get selectedTab => _selectedTab.value;

  // Filtered lists
  List<AttendanceModel> get regularAttendance =>
      employeeDetails?.attendance.where((a) => !a.workFromHome).toList() ?? [];

  List<AttendanceModel> get wfhAttendance =>
      employeeDetails?.attendance.where((a) => a.workFromHome).toList() ?? [];

  @override
  void onInit() {
    super.onInit();
    loadEmployeeDetails();
    loadEmployeeLocation();
    loadEmployeeTracking();
  }

  void setSelectedTab(int index) {
    _selectedTab.value = index;
  }

  void setSelectedDate(DateTime date) {
    _selectedDate.value = date;
    loadEmployeeDetails(startDate: DateFormat('yyyy-MM-dd').format(date));
    loadEmployeeTracking(date: DateFormat('yyyy-MM-dd').format(date));
  }

  Future<void> loadEmployeeDetails({String? startDate, String? endDate}) async {
    try {
      _isLoading.value = true;
      _error.value = '';
      final details = await _repository.getEmployeeDetails(
        employeeId,
        startDate: startDate,
        endDate: endDate,
      );
      _employeeDetails.value = details;
    } catch (e, stackTrace) {
      print('Exception: $e');
      print('Stack trace: $stackTrace');
      _error.value = 'Failed to load employee details';
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> loadEmployeeLocation() async {
    try {
      _isLocationLoading.value = true;
      final location = await _repository.getEmployeeLocation(employeeId);
      _location.value = location;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load employee location',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      _isLocationLoading.value = false;
    }
  }

  Future<void> loadEmployeeTracking({String? date}) async {
    try {
      _isTrackingLoading.value = true;
      final tracking = await _repository.getEmployeeTracking(
        employeeId,
        date: date,
      );
      _tracking.value = tracking;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load tracking history',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      _isTrackingLoading.value = false;
    }
  }

  void openLocationInMaps() {
    if (_location.value?.googleMapsUrl != null) {
      launchUrl(Uri.parse(_location.value!.googleMapsUrl));
    }
  }

  // Helper methods for statistics
  double get totalSales =>
      employeeDetails?.sales
          .fold(0.0, (sum, sale) => sum! + sale.totalAmount) ??
      0.0;

  int get totalOrders => employeeDetails?.orders.length ?? 0;

  int get totalClients => employeeDetails?.clients.length ?? 0;

  double get attendancePercentage {
    final attendance = employeeDetails?.attendance ?? [];
    if (attendance.isEmpty) return 0.0;
    final present = attendance.where((a) => ((a.totalHours ?? 0) > 0)).length;
    return (present / attendance.length) * 100;
  }

  void launchUrl(Uri parse) {}
}
