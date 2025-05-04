import 'package:eplisio_hub/core/constants/app_colors.dart';
import 'package:eplisio_hub/features/homescreen/presentation/widgets/employee_performance_card.dart';
import 'package:eplisio_hub/features/homescreen/presentation/widgets/error_view.dart';
import 'package:eplisio_hub/features/homescreen/presentation/widgets/sales_trend_card.dart';
import 'package:eplisio_hub/features/homescreen/presentation/widgets/stats_overview_shimmer.dart';
import 'package:eplisio_hub/features/homescreen/presentation/widgets/stats_overview_widgets.dart';
import 'package:eplisio_hub/features/homescreen/presentation/widgets/top_product_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: controller.loadAllData,
        child: CustomScrollView(
          slivers: [
            _buildAppBar(),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatsOverview(),
                    const SizedBox(height: 24),
                    _buildSalesTrend(),
                    const SizedBox(height: 24),
                    _buildEmployeeSection(),
                    const SizedBox(height: 24),
                    _buildProductSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 140, // Increased height for better visual impact
      floating: true,
      pinned: true,
      stretch: true, // Enables stretch effect when overscrolling
      elevation: 0, // Flat design approach (no shadow)
      backgroundColor: Colors.transparent, // Transparent to show gradient
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 14, bottom: 30),
        title: const Text(
          'Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary.withOpacity(0.9),
                AppColors.primary,
                AppColors.primary.withBlue(150),
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -30,
                top: -30,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
              Positioned(
                left: -20,
                bottom: 0,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.08),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.settings_outlined, color: Colors.white),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildStatsOverview() {
    return Obx(() {
      if (controller.isStatsLoading.value) {
        return const StatsOverviewShimmer();
      }

      if (controller.statsError.value.isNotEmpty) {
        return ErrorView(
          message: controller.statsError.value,
          onRetry: controller.loadOrganizationStats,
        );
      }

      final stats = controller.organizationStats.value;
      if (stats == null) return const SizedBox();

      return StatsOverviewCard(stats: stats);
    });
  }

  Widget _buildSalesTrend() {
    return Obx(() {
      if (controller.salesTrendError.value.isNotEmpty) {
        return ErrorView(
          message: controller.salesTrendError.value,
          onRetry: controller.loadSalesTrends,
        );
      }

      final trends = controller.salesTrends.value;
      if (trends == null) return const SizedBox();

      return SalesTrendCard(
        trends: trends,
        selectedPeriod: controller.selectedPeriod.value,
        onPeriodChanged: controller.changePeriod,
      );
    });
  }

  Widget _buildEmployeeSection() {
    return Obx(() {
      if (controller.isEmployeeLoading.value) {
        return const EmployeePerformanceShimmer();
      }

      if (controller.employeeError.value.isNotEmpty) {
        return ErrorView(
          message: controller.employeeError.value,
          onRetry: controller.loadEmployeeData,
        );
      }

      final employees = controller.topEmployees;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Employee Performance',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          if (employees.isEmpty)
            Container(
              height: 150,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'No employee found.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          else
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: employees.length,
                itemBuilder: (context, index) {
                  return EmployeePerformanceCard(
                    employee: employees[index],
                  );
                },
              ),
            ),
        ],
      );
    });
  }

  Widget _buildProductSection() {
    return Obx(() {
      if (controller.isProductLoading.value) {
        return const TopProductsShimmer();
      }

      if (controller.productError.value.isNotEmpty) {
        return ErrorView(
          message: controller.productError.value,
          onRetry: controller.loadProductData,
        );
      }

      final products = controller.topProducts;

      if (products.isEmpty) {
        return Container(
          height: 150,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Text(
            'No products found.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        );
      }

      return TopProductsCard(products: products);
    });
  }
}
