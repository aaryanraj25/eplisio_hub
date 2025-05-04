import 'package:eplisio_hub/features/homescreen/data/model/home_screen_model.dart';
import 'package:eplisio_hub/features/homescreen/presentation/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StatsOverviewCard extends StatelessWidget {
  final OrganizationStatsModel stats;

  const StatsOverviewCard({Key? key, required this.stats}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            spreadRadius: 1,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 16),
            child: Text(
              'Overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StatItemNew(
                icon: Icons.monetization_on_outlined,
                title: 'Revenue',
                value: Get.find<HomeController>().formatCurrency(stats.totalSales),
                color: Colors.green.shade600,
                description: 'Total sales',
              ),
              _buildVerticalDivider(),
              _StatItemNew(
                icon: Icons.people_outline,
                title: 'Clients',
                value: Get.find<HomeController>().formatNumber(stats.totalVisits),
                color: Colors.blue.shade600,
                description: 'Total Clients',
              ),
              _buildVerticalDivider(),
              _StatItemNew(
                icon: Icons.calendar_today_outlined,
                title: 'Meetings',
                value: Get.find<HomeController>().formatNumber(stats.totalMeetings),
                color: Colors.purple.shade600,
                description: 'Scheduled',
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildVerticalDivider() {
    return Container(
      height: 80,
      width: 1,
      color: Colors.grey.withOpacity(0.2),
    );
  }
}

class _StatItemNew extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;
  final String description;

  const _StatItemNew({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            description,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}