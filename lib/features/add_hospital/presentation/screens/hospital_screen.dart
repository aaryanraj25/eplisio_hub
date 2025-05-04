import 'package:eplisio_hub/core/constants/app_colors.dart';
import 'package:eplisio_hub/features/add_hospital/presentation/controller/hospital_controller.dart';
import 'package:eplisio_hub/features/add_hospital/presentation/widgets/hospital_card.dart';
import 'package:eplisio_hub/features/add_hospital/presentation/widgets/hospital_search_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HospitalsScreen extends GetView<HospitalController> {
  const HospitalsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hospitals'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Get.dialog(const HospitalSearchDialog()),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.hospitals.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.hospitals.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.local_hospital_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No hospitals added yet',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 24),
                
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchHospitals(refresh: true),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: controller.hospitals.length + 1,
            itemBuilder: (context, index) {
              if (index == controller.hospitals.length) {
                if (controller.isLoading.value) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }
              return HospitalCard(hospital: controller.hospitals[index]);
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => Get.dialog(const HospitalSearchDialog()),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}