import 'package:eplisio_hub/features/homescreen/data/model/home_screen_model.dart';
import 'package:eplisio_hub/features/homescreen/presentation/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmployeePerformanceCard extends StatelessWidget {
  final TopEmployeeModel employee;

  const EmployeePerformanceCard({
    Key? key,
    required this.employee,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 30,
            child: Text(
              employee.name.substring(0, 2).toUpperCase(),
              style: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            employee.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Sales: ${Get.find<HomeController>().formatCurrency(employee.salesAmount)}',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}