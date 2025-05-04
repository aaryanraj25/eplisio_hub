import 'package:eplisio_hub/core/constants/api_client.dart';
import 'package:eplisio_hub/features/add_client/data/model/add_client_model.dart';

class ClientRepository {
  final ApiClient _apiClient;

  ClientRepository(this._apiClient);

  // Create a new client
  Future<AddClientModel> createClient(AddClientModel client) async {
    try {
      final response = await _apiClient.post(
        '/clients/admin',
        data: client.toJson(),
      );
      return AddClientModel.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  // Get all clients with optional filtering
  Future<List<AddClientModel>> getClients({
    String? name,
    String? email,
    String? clinicId,
    String? capacity,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {};
      
      if (name != null) queryParams['name'] = name;
      if (email != null) queryParams['email'] = email;
      if (clinicId != null) queryParams['clinic_id'] = clinicId;
      if (capacity != null) queryParams['capacity'] = capacity;
      
      final response = await _apiClient.get(
        '/clients/admin',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );
      
      return (response.data as List)
          .map((item) => AddClientModel.fromJson(item))
          .toList();
    } catch (e) {
      throw e;
    }
  }

  // Get a specific client by ID
  Future<AddClientModel> getClientById(String clientId) async {
    try {
      final response = await _apiClient.get('/clients/admin/$clientId');
      return AddClientModel.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  // Update a client
  Future<AddClientModel> updateClient(String clientId, AddClientModel updatedClient) async {
    try {
      final response = await _apiClient.put(
        '/clients/admin/$clientId',
        data: updatedClient.toJson(),
      );
      return AddClientModel.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  // Delete a client
  Future<void> deleteClient(String clientId) async {
    try {
      await _apiClient.delete('/clients/admin/$clientId');
    } catch (e) {
      throw e;
    }
  }
}