import 'package:eplisio_hub/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/hospital_controller.dart';

class HospitalSearchDialog extends GetWidget<HospitalController> {
  const HospitalSearchDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        constraints: const BoxConstraints(maxHeight: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Text(
                  'Search Hospital',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter hospital name...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                if (value.length >= 3) {
                  controller.searchHospitals(value);
                }
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (controller.isSearching.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.searchResults.isEmpty) {
                  return Center(
                    child: Text(
                      'No hospitals found',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: controller.searchResults.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final hospital = controller.searchResults[index];
                    return Obx(() {
                      final isAddingThis = controller.currentlyAddingId.value == hospital.placeId;
                      
                      return ListTile(
                        title: Text(
                          hospital.name,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(hospital.address),
                            if (hospital.rating != null)
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 16,
                                  ),
                                  Text(' ${hospital.rating}'),
                                ],
                              ),
                          ],
                        ),
                        trailing: SizedBox(
                          width: 80, // Fixed width for consistent layout
                          height: 36, // Fixed height for consistent layout
                          child: ElevatedButton(
                            onPressed: isAddingThis
                                ? null
                                : () => controller.addHospital(hospital.placeId),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              disabledBackgroundColor: AppColors.primary.withOpacity(0.7),
                            ),
                            child: isAddingThis
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Text(
                                    'Add',
                                    style: TextStyle(color: Colors.white),
                                  ),
                          ),
                        ),
                        isThreeLine: hospital.rating != null,
                      );
                    });
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}