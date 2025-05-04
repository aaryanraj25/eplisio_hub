import 'package:get/get.dart';
import '../../data/repo/home_screen_repo.dart';
import '../../data/model/home_screen_model.dart';

class HomeController extends GetxController {
  final HomeScreenRepository repository;

  HomeController({required this.repository});

  // Section loading states
  final isStatsLoading = true.obs;
  final isSalesTrendLoading = true.obs;
  final isEmployeeLoading = true.obs;
  final isProductLoading = true.obs;

  // Section error states
  final statsError = ''.obs;
  final salesTrendError = ''.obs;
  final employeeError = ''.obs;
  final productError = ''.obs;

  // Data
  final organizationStats = Rxn<OrganizationStatsModel>();
  final salesTrends = Rxn<SalesTrendModel>();
  final employeePerformance = <EmployeePerformanceModel>[].obs;
  final topEmployees = <TopEmployeeModel>[].obs;
  final topProducts = <TopProductModel>[].obs;

  // Selected period for sales trend
  final selectedPeriod = 'Monthly'.obs;

  @override
  void onInit() {
    super.onInit();
    loadAllData();
  }

  Future<void> loadAllData() async {
    await Future.wait([
      loadOrganizationStats(),
      loadSalesTrends(),
      loadEmployeeData(),
      loadProductData(),
    ]);
  }

  Future<void> loadOrganizationStats() async {
    try {
      isStatsLoading.value = true;
      statsError.value = '';
      final stats = await repository.getOrganizationStats();
      organizationStats.value = stats;
    } catch (e) {
      statsError.value = 'Failed to load organization stats';
      print('Error loading stats: $e');
    } finally {
      isStatsLoading.value = false;
    }
  }

  Future<void> loadSalesTrends() async {
    try {
      isSalesTrendLoading.value = true;
      salesTrendError.value = '';
      final trends = await repository.getSalesTrends();
      salesTrends.value = trends;
    } catch (e) {
      salesTrendError.value = 'Failed to load sales trends';
      print('Error loading sales trends: $e');
    } finally {
      isSalesTrendLoading.value = false;
    }
  }

  Future<void> loadEmployeeData() async {
    try {
      isEmployeeLoading.value = true;
      employeeError.value = '';
      final performance = await repository.getEmployeePerformance();
      final topEmps = await repository.getTopEmployees();
      employeePerformance.value = performance;
      topEmployees.value = topEmps;
    } catch (e) {
      employeeError.value = 'Failed to load employee data';
      print('Error loading employee data: $e');
    } finally {
      isEmployeeLoading.value = false;
    }
  }

  Future<void> loadProductData() async {
    try {
      isProductLoading.value = true;
      productError.value = '';
      final products = await repository.getTopProducts();
      topProducts.value = products;
    } catch (e) {
      productError.value = 'Failed to load product data';
      print('Error loading product data: $e');
    } finally {
      isProductLoading.value = false;
    }
  }

  void changePeriod(String period) {
    selectedPeriod.value = period;
    loadSalesTrends();
  }

  String formatCurrency(double value) {
    if (value >= 10000000) {
      return '₹${(value / 10000000).toStringAsFixed(1)}Cr';
    } else if (value >= 100000) {
      return '₹${(value / 100000).toStringAsFixed(1)}L';
    } else if (value >= 1000) {
      return '₹${(value / 1000).toStringAsFixed(1)}K';
    }
    return '₹${value.toStringAsFixed(0)}';
  }

  String formatNumber(int value) {
    if (value >= 10000000) {
      return '${(value / 10000000).toStringAsFixed(1)}Cr';
    } else if (value >= 100000) {
      return '${(value / 100000).toStringAsFixed(1)}L';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toString();
  }
}