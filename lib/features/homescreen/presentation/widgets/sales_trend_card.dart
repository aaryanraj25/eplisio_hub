import 'package:eplisio_hub/features/homescreen/data/model/home_screen_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SalesTrendCard extends StatelessWidget {
  final SalesTrendModel trends;
  final String selectedPeriod;
  final Function(String) onPeriodChanged;

  const SalesTrendCard({
    Key? key,
    required this.trends,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Sales Trend',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: DropdownButton<String>(
                  value: selectedPeriod,
                  underline: const SizedBox(),
                  items: ['Monthly', 'Yearly']
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) onPeriodChanged(value);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: _buildChart(),
          ),
        ],
      ),
    );
  }

  Widget _buildChart() {
    // Check if there's data to display
    final hasData = selectedPeriod == 'Monthly' 
        ? trends.monthlySales.isNotEmpty && trends.monthlySales.any((sale) => sale.amount > 0)
        : trends.yearlySales.isNotEmpty && trends.yearlySales.any((sale) => sale.amount > 0);

    if (!hasData) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.show_chart, size: 40, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No sales data available',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return LineChart(
      _createChartData(),
      duration: const Duration(milliseconds: 250),
    );
  }

  LineChartData _createChartData() {
    final data = selectedPeriod == 'Monthly'
        ? trends.monthlySales
        : trends.yearlySales;

    double maxY = 0;
    List<FlSpot> spots = [];

    // Calculate maxY and create spots
    if (selectedPeriod == 'Monthly') {
      spots = trends.monthlySales
          .asMap()
          .entries
          .map((entry) {
            final amount = entry.value.amount;
            if (amount > maxY) maxY = amount;
            return FlSpot(entry.key.toDouble(), amount);
          })
          .toList();
    } else {
      spots = trends.yearlySales
          .asMap()
          .entries
          .map((entry) {
            final amount = entry.value.amount;
            if (amount > maxY) maxY = amount;
            return FlSpot(entry.key.toDouble(), amount);
          })
          .toList();
    }

    // Ensure maxY is not zero
    maxY = maxY <= 0 ? 1000 : maxY;
    
    // Calculate appropriate interval
    final horizontalInterval = maxY / 5;

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: horizontalInterval > 0 ? horizontalInterval : 100, // Ensure non-zero interval
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey[300],
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index < 0 || index >= data.length) return const Text('');
              
              if (selectedPeriod == 'Monthly') {
                final monthData = trends.monthlySales[index];
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    monthData.month,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                );
              } else {
                final yearData = trends.yearlySales[index];
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    yearData.year.toString(),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                );
              }
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: horizontalInterval > 0 ? horizontalInterval : 100, // Ensure non-zero interval
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              // Don't show 0 label
              if (value == 0) return const SizedBox();
              
              // Format the value based on its magnitude
              String formattedValue;
              if (value >= 100000) {
                formattedValue = '₹${(value / 100000).toStringAsFixed(1)}L';
              } else if (value >= 1000) {
                formattedValue = '₹${(value / 1000).toStringAsFixed(0)}K';
              } else {
                formattedValue = '₹${value.toStringAsFixed(0)}';
              }
              
              return Text(
                formattedValue,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: (data.length - 1).toDouble(),
      minY: 0,
      maxY: maxY * 1.2, // Add 20% padding to top
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              Theme.of(Get.context!).primaryColor.withOpacity(0.5),
              Theme.of(Get.context!).primaryColor,
            ],
          ),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 4,
                color: Theme.of(Get.context!).primaryColor,
                strokeWidth: 2,
                strokeColor: Colors.white,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(Get.context!).primaryColor.withOpacity(0.2),
                Theme.of(Get.context!).primaryColor.withOpacity(0.0),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Add shimmer effect widget for loading state
class SalesTrendShimmer extends StatelessWidget {
  const SalesTrendShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 100,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Container(
                width: 80,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}