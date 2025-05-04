// lib/features/homescreen/presentation/widgets/shimmer_widgets.dart

import 'package:flutter/material.dart';
import '../../../../core/widgets/shimmer_loading.dart';

class StatsOverviewShimmer extends StatelessWidget {
  const StatsOverviewShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        3,
        (index) => Expanded(
          child: ShimmerLoading(
            height: 100,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 8),
          ),
        ),
      ),
    );
  }
}

class SalesTrendShimmer extends StatelessWidget {
  const SalesTrendShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title shimmer
        const ShimmerLoading(
          height: 24,
          width: 120,
          margin: EdgeInsets.only(bottom: 20),
        ),
        // Chart area shimmer
        const ShimmerLoading(
          height: 200,
          width: double.infinity,
        ),
      ],
    );
  }
}

class EmployeePerformanceShimmer extends StatelessWidget {
  const EmployeePerformanceShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title shimmer
        const ShimmerLoading(
          height: 24,
          width: 180,
          margin: EdgeInsets.only(bottom: 16),
        ),
        // Employee cards shimmer
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) {
              return ShimmerLoading(
                height: 200,
                width: 200,
                margin: EdgeInsets.only(
                  right: index < 2 ? 16 : 0,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class TopProductsShimmer extends StatelessWidget {
  const TopProductsShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title shimmer
        const ShimmerLoading(
          height: 24,
          width: 120,
          margin: EdgeInsets.only(bottom: 16),
        ),
        // Product items shimmer
        ...List.generate(
          3,
          (index) => const ShimmerLoading(
            height: 60,
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 12),
          ),
        ),
      ],
    );
  }
}