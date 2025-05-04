import 'package:eplisio_hub/core/constants/api_client.dart';
import 'package:eplisio_hub/features/product/data/model/product_model.dart';

class ProductRepository {
  final ApiClient _apiClient;

  ProductRepository({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  // Get all products
  Future<Map<String, dynamic>> getAllProducts({
    int skip = 0,
    int limit = 10,
    String? category,
    String? search,
  }) async {
    try {
      String url = '/product/list?skip=$skip&limit=$limit';
      if (category != null) url += '&category=$category';
      if (search != null) url += '&search=$search';

      final response = await _apiClient.get(url);
      
      if (response.statusCode == 200) {
        return {
          'total': response.data['total'] ?? 0,
          'products': (response.data['products'] as List?)
              ?.map((json) => ProductModel.fromJson(json))
              .toList() ?? [],
          'page': response.data['page'] ?? 1,
          'pages': response.data['pages'] ?? 1,
        };
      }
      
      throw Exception('Failed to fetch products');
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  // Get categories
  Future<List<String>> getCategories() async {
    try {
      final response = await _apiClient.get('/product/categories');
      
      if (response.statusCode == 200) {
        return (response.data['categories'] as List?)
            ?.map((e) => e.toString())
            .toList() ?? [];
      }
      
      throw Exception('Failed to fetch categories');
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }

  // Add product
  Future<ProductModel> addProduct(ProductModel product) async {
    try {
      final response = await _apiClient.post(
        '/product/add',
        data: product.toJson(),
      );
      
      if (response.statusCode == 200) {
        return ProductModel.fromJson(response.data);
      }
      
      throw Exception('Failed to add product');
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }

  // Update product
  Future<ProductModel> updateProduct(String id, ProductModel product) async {
    try {
      final response = await _apiClient.put(
        '/product/$id',
        data: product.toJson(),
      );
      
      if (response.statusCode == 200) {
        return ProductModel.fromJson(response.data);
      }
      
      throw Exception('Failed to update product');
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  // Delete product
  Future<void> deleteProduct(String id) async {
    try {
      final response = await _apiClient.delete('/product/$id');
      
      if (response.statusCode != 200) {
        throw Exception('Failed to delete product');
      }
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }

  // Bulk update products
  Future<void> bulkUpdateProducts(List<Map<String, dynamic>> products) async {
    try {
      final response = await _apiClient.post(
        '/product/bulk-update',
        data: products,
      );
      
      if (response.statusCode != 200) {
        throw Exception('Failed to bulk update products');
      }
    } catch (e) {
      throw Exception('Failed to bulk update products: $e');
    }
  }
}