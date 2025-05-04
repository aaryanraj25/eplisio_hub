import 'package:eplisio_hub/features/employee_detail/data/model/employee_detail_model.dart';
import 'package:eplisio_hub/features/employee_detail/presentation/controller/employee_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttendanceTab extends GetView<EmployeeDetailController> {
  const AttendanceTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            child: TabBar(
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Theme.of(context).primaryColor,
              tabs: const [
                Tab(text: 'Regular'),
                Tab(text: 'Work From Home'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildAttendanceList(isWFH: false),
                _buildAttendanceList(isWFH: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceList({required bool isWFH}) {
    return Obx(() {
      final attendance = isWFH 
          ? controller.wfhAttendance 
          : controller.regularAttendance;

      if (attendance.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isWFH ? Icons.home_work : Icons.work_off,
                size: 64,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'No ${isWFH ? 'WFH' : 'regular'} attendance records found',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: attendance.length,
        itemBuilder: (context, index) {
          final record = attendance[index];
          return _buildAttendanceCard(record);
        },
      );
    });
  }

  Widget _buildAttendanceCard(AttendanceModel attendance) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  attendance.workFromHome ? Icons.home_work : Icons.work,
                  color: Theme.of(Get.context!).primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  attendance.formattedDate,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                _buildStatusChip(attendance),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTimeColumn(
                  'Clock In',
                  attendance.formattedClockIn,
                  Icons.login,
                  Colors.green,
                ),
                Container(
                  height: 40,
                  width: 1,
                  color: Colors.grey.shade300,
                ),
                _buildTimeColumn(
                  'Clock Out',
                  attendance.formattedClockOut,
                  Icons.logout,
                  Colors.red,
                ),
                Container(
                  height: 40,
                  width: 1,
                  color: Colors.grey.shade300,
                ),
                _buildTimeColumn(
                  'Hours',
                  (attendance.totalHours ?? 0).toStringAsFixed(2),
                  Icons.timer,
                  Colors.blue,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeColumn(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(AttendanceModel attendance) {
    final isOngoing = attendance.clockOutTime == null;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isOngoing ? Colors.green.withOpacity(0.1) : Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isOngoing ? Icons.circle : Icons.check_circle,
            size: 12,
            color: isOngoing ? Colors.green : Colors.blue,
          ),
          const SizedBox(width: 4),
          Text(
            isOngoing ? 'Ongoing' : 'Completed',
            style: TextStyle(
              fontSize: 12,
              color: isOngoing ? Colors.green : Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

