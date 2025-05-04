import 'package:eplisio_hub/features/employee/data/model/employee_model.dart';
import 'package:eplisio_hub/features/employee_detail/presentation/controller/employee_detail_controller.dart';
import 'package:eplisio_hub/features/employee_detail/presentation/widgets/attendance_tab.dart';
import 'package:eplisio_hub/features/employee_detail/presentation/widgets/location_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class EmployeeDetailScreen extends GetView<EmployeeDetailController> {
  const EmployeeDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            _buildAppBar(context),
          ],
          body: Obx(() {
            if (controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.error.isNotEmpty) {
              return _buildErrorState();
            }

            return TabBarView(
              children: [
                BasicInfoTab(),
                AttendanceTab(),
                LocationTab(),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      floating: true,
      backgroundColor: Theme.of(context).primaryColor,
      iconTheme: const IconThemeData(color: Colors.white), // back button color
      flexibleSpace: FlexibleSpaceBar(
        background: Obx(() {
          final employee = controller.employeeDetails?.employee;
          if (employee == null) return const SizedBox();

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withOpacity(0.8),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.white,
                  child: Text(
                    employee.name[0].toUpperCase(),
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  employee.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  employee.email,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
      bottom: const TabBar(
        indicatorColor: Colors.white,
        labelColor: Colors.white, // selected tab text color
        unselectedLabelColor: Colors.white70, // unselected tab text color
        tabs: [
          Tab(text: 'Basic Info'),
          Tab(text: 'Attendance'),
          Tab(text: 'Location'),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            controller.error,
            style: TextStyle(
              fontSize: 18,
              color: Colors.red.shade600,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: controller.loadEmployeeDetails,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class BasicInfoTab extends GetView<EmployeeDetailController> {
  const BasicInfoTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Obx(() {
        final employee = controller.employeeDetails?.employee;
        if (employee == null) return const SizedBox();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatisticsCards(),
            const SizedBox(height: 8),
            _buildBasicInfo(employee),
            const SizedBox(height: 24),
            _buildRecentOrders(),
            const SizedBox(height: 24),
            _buildRecentClients(),
          ],
        );
      }),
    );
  }

  Widget _buildStatisticsCards() {
    String formatCurrency(double amount) {
      if (amount >= 10000000) {
        return '₹${(amount / 10000000).toStringAsFixed(2)} Cr';
      } else if (amount >= 100000) {
        return '₹${(amount / 100000).toStringAsFixed(2)} Lakh';
      } else if (amount >= 1000) {
        return '₹${(amount / 1000).toStringAsFixed(2)} K';
      } else {
        return '₹${amount.toStringAsFixed(2)}';
      }
    }

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 14,
      crossAxisSpacing: 0,
      childAspectRatio: 1.2,
      children: [
        _buildStatCard(
          'Total Sales',
          formatCurrency(controller.totalSales),
          Icons.currency_rupee_outlined,
          Colors.green,
        ),
        _buildStatCard(
          'Total Orders',
          controller.totalOrders.toString(),
          Icons.local_shipping,
          Colors.blue,
        ),
        _buildStatCard(
          'Total Clients',
          controller.totalClients.toString(),
          Icons.people,
          Colors.orange,
        ),
        _buildStatCard(
          'Attendance',
          '${controller.attendancePercentage.toStringAsFixed(1)}%',
          Icons.timer,
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfo(EmployeeModel employee) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Basic Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Employee ID', employee.id),
            _buildInfoRow('Role', employee.role.toUpperCase()),
            _buildInfoRow('Organization', employee.organization),
            _buildInfoRow(
              'Joined',
              DateFormat('MMM dd, yyyy').format(employee.createdAt),
            ),
            _buildInfoRow(
              'Status',
              employee.isActive ? 'Active' : 'Inactive',
              valueColor: employee.isActive ? Colors.green : Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            '$label:',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentOrders() {
    final orders = controller.employeeDetails?.orders ?? [];
    if (orders.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Orders',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: orders.take(5).length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return Card(
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text(order.clinicHospitalName),
                subtitle: Text(
                  '${DateFormat('MMM dd, yyyy').format(order.orderDate)}\n₹${order.totalAmount}',
                ),
                trailing: _buildStatusChip(order.status),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'completed':
        color = Colors.green;
        break;
      case 'pending':
        color = Colors.orange;
        break;
      case 'rejected':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Chip(
      label: Text(
        status,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  Widget _buildRecentClients() {
    final clients = controller.employeeDetails?.clients ?? [];
    if (clients.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Clients',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: clients.take(5).length,
          itemBuilder: (context, index) {
            final client = clients[index];
            return Card(
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(client.name[0].toUpperCase()),
                ),
                title: Text(client.name),
                subtitle: Text(client.designation),
                trailing: Text(
                  DateFormat('MMM dd').format(client.createdAt),
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
