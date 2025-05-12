import 'package:eplisio_hub/core/constants/app_colors.dart';
import 'package:eplisio_hub/features/add_client/presentation/controller/add_client_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/detail_item.dart';

class ClientDetailsScreen extends StatefulWidget {
  const ClientDetailsScreen({Key? key}) : super(key: key);

  @override
  State<ClientDetailsScreen> createState() => _ClientDetailsScreenState();
}

class _ClientDetailsScreenState extends State<ClientDetailsScreen> {
  final ClientController controller = Get.find<ClientController>();
  late final String clientId;

  @override
  void initState() {
    super.initState();
    // Get the client ID from arguments
    clientId = Get.arguments as String;

    // Use a small delay to ensure widget tree is built before updating state
    // This prevents the build-time setState error
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getClientById(clientId);
    });
  }

  @override
  Widget build(BuildContext context) {
    String formatClientCapacity(String input) {
      return input.split(' ').map((word) {
        return word
            .split('_')
            .map((part) => part[0].toUpperCase() + part.substring(1))
            .join(' ');
      }).join(' ');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Client Details'),
        centerTitle: true,
        actions: [],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: ${controller.error.value}',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.getClientById(clientId),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final client = controller.selectedClient.value;
        if (client == null) {
          return const Center(child: Text('Client not found'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Client information card
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Client Information',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary),
                      ),
                      const Divider(),
                      const SizedBox(height: 8),
                      DetailItem(
                        icon: Icons.person,
                        title: 'Name',
                        value: client.name,
                      ),
                      DetailItem(
                        icon: Icons.work,
                        title: 'Designation',
                        value: client.designation,
                      ),
                      DetailItem(
                        icon: Icons.business,
                        title: 'Department',
                        value: client.department,
                      ),
                      DetailItem(
                        icon: Icons.assignment_ind,
                        title: 'Capacity',
                        value: formatClientCapacity(client.capacity),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Contact information card
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Contact Information',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary),
                      ),
                      const Divider(),
                      const SizedBox(height: 8),
                      DetailItem(
                        icon: Icons.phone,
                        title: 'Mobile',
                        value: client.mobile ?? '',
                        trailing: IconButton(
                          icon: const Icon(Icons.phone),
                          onPressed: () {
                            // Implement phone call functionality
                          },
                          tooltip: 'Call',
                        ),
                      ),
                      DetailItem(
                        icon: Icons.email,
                        title: 'Email',
                        value: client.email ?? '',
                        trailing: IconButton(
                          icon: const Icon(Icons.email),
                          onPressed: () {
                            // Implement email functionality
                          },
                          tooltip: 'Send Email',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Clinic information card
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Clinic Information',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary),
                      ),
                      const Divider(),
                      const SizedBox(height: 8),
                      DetailItem(
                        icon: Icons.local_hospital,
                        title: 'Clinic',
                        value: controller.getHospitalNameById(client.clinicId),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // System information card
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'System Information',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary),
                      ),
                      const Divider(),
                      const SizedBox(height: 8),
                      if (client.createdAt != null)
                        DetailItem(
                          icon: Icons.access_time,
                          title: 'Created At',
                          value:
                              '${client.createdAt!.day}/${client.createdAt!.month}/${client.createdAt!.year}',
                        ),
                      if (client.updatedAt != null)
                        DetailItem(
                          icon: Icons.update,
                          title: 'Last Updated',
                          value:
                              '${client.updatedAt!.day}/${client.updatedAt!.month}/${client.updatedAt!.year}',
                        ),
                      if (client.id != null)
                        DetailItem(
                          icon: Icons.fingerprint,
                          title: 'Client ID',
                          value: client.id!,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
