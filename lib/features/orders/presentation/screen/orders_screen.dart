import 'package:eplisio_hub/core/constants/app_colors.dart';
import 'package:eplisio_hub/features/orders/presentation/controller/orders_controller.dart';
import 'package:eplisio_hub/features/orders/presentation/widgets/orders_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrdersScreen extends GetView<OrderController> {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        bottom: TabBar(
          controller: controller.tabController,
          tabs: const [
            Tab(text: 'Prospective'),
            Tab(text: 'Completed'),
            Tab(text: 'Pending'),
            Tab(text: 'Rejected'),
          ],
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey,
        ),
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: [
          OrderList(
            orders: controller.prospectiveOrders,
            isLoading: controller.isLoadingProspective,
            onRefresh: controller.fetchProspectiveOrders,
            status: 'prospective',
          ),
          OrderList(
            orders: controller.completedOrders,
            isLoading: controller.isLoadingCompleted,
            onRefresh: controller.fetchCompletedOrders,
            status: 'completed',
          ),
          OrderList(
            orders: controller.pendingOrders,
            isLoading: controller.isLoadingPending,
            onRefresh: controller.fetchPendingOrders,
            status: 'pending',
          ),
          OrderList(
            orders: controller.rejectedOrders,
            isLoading: controller.isLoadingRejected,
            onRefresh: controller.fetchRejectedOrders,
            status: 'rejected',
          ),
        ],
      ),
    );
  }
}
