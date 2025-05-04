import 'package:eplisio_hub/core/constants/app_colors.dart';
import 'package:eplisio_hub/features/employee/data/model/employee_model.dart';
import 'package:eplisio_hub/features/employee/presentation/controller/employee_controller.dart';
import 'package:eplisio_hub/features/employee/presentation/widgets/add_employee_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmployeeScreen extends GetView<EmployeeController> {
  const EmployeeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: controller.loadEmployees,
            child: CustomScrollView(
              slivers: [
                _buildAppBar(context),
                _buildEmployeeList(),
              ],
            ),
          ),
          Obx(() {
            if (controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEmployeeDialog(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.person_add, color: Colors.white),
        label: const Text('Add Employee', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      expandedHeight: 140,
      centerTitle: true,
      backgroundColor: AppColors.gradientEnd,
      title: const Text(
        'Employees',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          letterSpacing: 0.5,
          color: Colors.white,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: TextField(
            onChanged: controller.setSearchQuery,
            decoration: InputDecoration(
              hintText: 'Search employees...',
              filled: true,
              fillColor: Colors.white,
              prefixIcon: const Icon(Icons.search, color: AppColors.primary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmployeeList() {
    return Obx(() {
      if (controller.error.isNotEmpty) {
        return SliverFillRemaining(
          child: Center(
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
                  onPressed: controller.loadEmployees,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        );
      }

      final employees = controller.filteredEmployees;
      if (employees.isEmpty) {
        return const SliverFillRemaining(
          child: Center(
            child: Text('No employees found'),
          ),
        );
      }

      return SliverPadding(
        padding: const EdgeInsets.all(16),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final employee = employees[index];
              return _buildEmployeeCard(employee);
            },
            childCount: employees.length,
          ),
        ),
      );
    });
  }

  Widget _buildEmployeeCard(EmployeeModel employee) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => controller.navigateToEmployeeDetails(employee.id),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.blue.shade100,
                child: Text(
                  employee.name[0].toUpperCase(),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      employee.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      employee.email,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.circle,
                          size: 12,
                          color: employee.isActive ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          employee.isActive ? 'Active' : 'Inactive',
                          style: TextStyle(
                            color: employee.isActive ? Colors.green : Colors.red,
                            fontSize: 12,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Joined ${employee.createdAt.toLocal().toString().split(' ')[0]}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddEmployeeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddEmployeeDialog(
        onSubmit: controller.createEmployee,
      ),
    );
  }
}