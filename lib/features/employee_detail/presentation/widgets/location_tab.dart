import 'package:eplisio_hub/core/constants/app_colors.dart';
import 'package:eplisio_hub/features/employee_detail/data/model/employee_detail_model.dart';
import 'package:eplisio_hub/features/employee_detail/presentation/controller/employee_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationTab extends GetView<EmployeeDetailController> {
  const LocationTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCurrentLocation(),
          const SizedBox(height: 24),
          _buildTrackingHistory(),
        ],
      ),
    );
  }

  Widget _buildCurrentLocation() {
    return Obx(() {
      if (controller.isLocationLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      final location = controller.location;
      if (location == null) {
        return const Center(child: Text('Location not available'));
      }

      return Card(
        color: Colors.white,
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
                  const Icon(Icons.location_on, color: Colors.red),
                  const SizedBox(width: 8),
                  const Text(
                    'Current Location',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: controller.loadEmployeeLocation,
                    tooltip: 'Refresh location',
                  ),
                ],
              ),
              const Divider(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLocationDetail(
                          'Latitude',
                          location.location.latitude.toString(),
                        ),
                        const SizedBox(height: 8),
                        _buildLocationDetail(
                          'Longitude',
                          location.location.longitude.toString(),
                        ),
                        const SizedBox(height: 8),
                        _buildLocationDetail(
                          'Last Updated',
                          location.location.formattedLastUpdate,
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: controller.openLocationInMaps,
                    icon: const Icon(Icons.map,color: Colors.white),
                    label: const Text('Open Maps', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildLocationDetail(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            '$label:',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrackingHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Location History',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            _buildDatePicker(),
          ],
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.isTrackingLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final tracking = controller.tracking;
          if (tracking.isEmpty) {
            return Center(
              child: Column(
                children: [
                  Icon(
                    Icons.location_off,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No location history found',
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
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tracking.length,
            itemBuilder: (context, index) {
              final record = tracking[index];
              return _buildTrackingCard(record);
            },
          );
        }),
      ],
    );
  }

  Widget _buildDatePicker() {
    return TextButton.icon(
      onPressed: () async {
        final date = await showDatePicker(
          context: Get.context!,
          initialDate: controller.selectedDate,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
        );
        if (date != null) {
          controller.setSelectedDate(date);
        }
      },
      icon: const Icon(Icons.calendar_today, size: 18),
      label: Obx(() => Text(
        DateFormat('MMM dd, yyyy').format(controller.selectedDate),
      )),
    );
  }

  Widget _buildTrackingCard(TrackingModel tracking) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: const CircleAvatar(
          child: Icon(Icons.location_history),
        ),
        title: Text(DateFormat('hh:mm a').format(tracking.timestamp)),
        subtitle: Text(
          'Lat: ${tracking.location.latitude}\nLng: ${tracking.location.longitude}',
        ),
        trailing: IconButton(
          icon: const Icon(Icons.map),
          onPressed: () => launchUrl(Uri.parse(
            'https://www.google.com/maps?q=${tracking.location.latitude},${tracking.location.longitude}',
          )),
        ),
      ),
    );
  }
}