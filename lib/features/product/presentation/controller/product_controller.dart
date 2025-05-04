import 'package:eplisio_hub/features/product/data/repo/product_repo.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/model/product_model.dart';

class ProductController extends GetxController {
  final ProductRepository _repository;
  
  // Observable variables
  final _isLoading = false.obs;
  final _isUploading = false.obs;
  final _products = <ProductModel>[].obs;
  final _categories = <String>[].obs;
  final _selectedCategory = Rxn<String>();
  final _error = ''.obs;
  final _searchQuery = ''.obs;
  final _currentPage = 1.obs;
  final _totalPages = 1.obs;
  final _totalProducts = 0.obs;

  ProductController({required ProductRepository repository})
      : _repository = repository;

  // Getters
  bool get isLoading => _isLoading.value;
  bool get isUploading => _isUploading.value;
  List<ProductModel> get products => _products;
  List<String> get categories => _categories;
  String? get selectedCategory => _selectedCategory.value;
  String get error => _error.value;
  String get searchQuery => _searchQuery.value;
  int get currentPage => _currentPage.value;
  int get totalPages => _totalPages.value;
  int get totalProducts => _totalProducts.value;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
    loadProducts();
  }

  // Load categories
  Future<void> loadCategories() async {
    try {
      final categories = await _repository.getCategories();
      _categories.value = categories;
    } catch (e) {
      _error.value = 'Failed to load categories';
    }
  }

  // Load products with pagination
  Future<void> loadProducts({bool refresh = false}) async {
    try {
      if (refresh) {
        _currentPage.value = 1;
      }

      _isLoading.value = true;
      _error.value = '';

      final result = await _repository.getAllProducts(
        skip: (_currentPage.value - 1) * 10,
        limit: 10,
        category: _selectedCategory.value,
        search: _searchQuery.value.isNotEmpty ? _searchQuery.value : null,
      );

      if (refresh) {
        _products.clear();
      }

      _products.value = result['products'] as List<ProductModel>;
      _totalProducts.value = result['total'] as int;
      _totalPages.value = result['pages'] as int;
      _currentPage.value = result['page'] as int;
    } catch (e) {
      _error.value = 'Failed to load products';
    } finally {
      _isLoading.value = false;
    }
  }

  // Import products from Excel
  Future<void> importProductsFromExcel() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
      );

      if (result != null) {
        _isUploading.value = true;
        
        // Read the Excel file
        final bytes = result.files.first.bytes;
        if (bytes == null) {
          throw Exception('Failed to read file');
        }

        // Convert Excel to JSON format
        final excel = Excel.decodeBytes(bytes);
        final sheet = excel.tables[excel.tables.keys.first];
        if (sheet == null) {
          throw Exception('No data found in Excel file');
        }

        // Convert rows to product format
        final products = <Map<String, dynamic>>[];
        bool isFirstRow = true;

        for (var row in sheet.rows) {
          if (isFirstRow) {
            isFirstRow = false;
            continue;
          }

          if (row.length >= 5) { // Make sure row has all required fields
            products.add({
              'name': row[0]?.value?.toString() ?? '',
              'category': row[1]?.value?.toString() ?? '',
              'quantity': int.tryParse(row[2]?.value?.toString() ?? '0') ?? 0,
              'price': double.tryParse(row[3]?.value?.toString() ?? '0') ?? 0.0,
              'manufacturer': row[4]?.value?.toString() ?? '',
            });
          }
        }

        // Send to API
        await _repository.bulkUpdateProducts(products);
        
        // Refresh products list
        await loadProducts(refresh: true);

        Get.snackbar(
          'Success',
          'Products imported successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to import products: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      _isUploading.value = false;
    }
  }

  // Add product
  Future<void> addProduct(ProductModel product) async {
    try {
      _isLoading.value = true;
      await _repository.addProduct(product);
      await loadProducts(refresh: true);
      Get.back();
      Get.snackbar(
        'Success',
        'Product added successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add product',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  // Update product
  Future<void> updateProduct(String id, ProductModel product) async {
    try {
      _isLoading.value = true;
      await _repository.updateProduct(id, product);
      await loadProducts();
      Get.back();
      Get.snackbar(
        'Success',
        'Product updated successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update product',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  // Delete product
  Future<void> deleteProduct(String id) async {
    try {
      _isLoading.value = true;
      await _repository.deleteProduct(id);
      await loadProducts(refresh: true);
      Get.snackbar(
        'Success',
        'Product deleted successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete product',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  // Pagination methods
  void nextPage() {
    if (_currentPage.value < _totalPages.value) {
      _currentPage.value++;
      loadProducts();
    }
  }

  void previousPage() {
    if (_currentPage.value > 1) {
      _currentPage.value--;
      loadProducts();
    }
  }

  // Filter methods
  void setSearchQuery(String query) {
    _searchQuery.value = query;
    loadProducts(refresh: true);
  }

  void setCategory(String? category) {
    _selectedCategory.value = category;
    loadProducts(refresh: true);
  }

  // Refresh products
  Future<void> refreshProducts() async {
    await loadProducts(refresh: true);
  }

  @override
  void onClose() {
    _searchQuery.value = '';
    _selectedCategory.value = null;
    super.onClose();
  }
}