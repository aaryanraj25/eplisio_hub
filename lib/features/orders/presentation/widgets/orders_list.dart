import 'package:eplisio_hub/features/orders/data/model/orders_model.dart';
import 'package:eplisio_hub/features/orders/presentation/controller/orders_controller.dart';
import 'package:eplisio_hub/features/orders/presentation/widgets/orders_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderList extends StatelessWidget {
  final RxList<Order> orders;
  final RxBool isLoading;
  final Function onRefresh;
  final String status;

  const OrderList({
    required this.orders,
    required this.isLoading,
    required this.onRefresh,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (isLoading.value && orders.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (orders.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_bag_outlined, 
                size: 64, 
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No ${status.capitalize} Orders',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () => onRefresh(),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            return OrderCard(
              order: orders[index],
              onStatusUpdate: (newStatus) {
                Get.find<OrderController>()
                    .updateOrderStatus(orders[index].id, newStatus);
              },
            );
          },
        ),
      );
    });
  }
}