import 'package:eplisio_hub/features/add_client/data/model/add_client_model.dart';
import 'package:eplisio_hub/features/add_client/presentation/controller/add_client_controller.dart';
import 'package:eplisio_hub/features/add_client/presentation/widgets/client_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClientsScreen extends StatelessWidget {
  const ClientsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ClientController controller = Get.find<ClientController>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clients Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              
            },
            tooltip: 'Filter Clients',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.fetchClients(),
            tooltip: 'Refresh',
          ),
        ],
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
                  onPressed: () => controller.fetchClients(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        
        if (controller.clients.isEmpty) {
          return const Center(
            child: Text('No clients found'),
          );
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.clients.length,
          itemBuilder: (context, index) {
            final client = controller.clients[index];
            return ClientCard(
              client: client,
              clinicName: controller.getHospitalNameById(client.clinicId),
              onTap: () => Get.toNamed(
                '/client-details',
                arguments: client.id,
              ),
              onEdit: () => Get.toNamed(
                '/client-form',
                arguments: client.id,
              ),
              onDelete: () => _showDeleteConfirmation(context, controller, client),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/client-form'),
        child: const Icon(Icons.add),
        tooltip: 'Add Client',
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    ClientController controller,
    AddClientModel client,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Client'),
        content: Text('Are you sure you want to delete ${client.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              controller.deleteClient(client.id!);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}