import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../data/model/product_model.dart';
import '../controller/product_controller.dart';

class ProductFormDialog extends StatefulWidget {
  final ProductModel? product;
  final Function(ProductModel) onSubmit;

  const ProductFormDialog({
    Key? key,
    this.product,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<ProductFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _stockController;
  late final TextEditingController _manufacturerController;
  late final TextEditingController _categoryController;
  String? _selectedCategory;
  bool _isCustomCategory = false;
  bool _isLoading = false;

  bool get isEditing => widget.product != null;
  final ProductController productController = Get.find<ProductController>();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing product data or empty strings
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _priceController = TextEditingController(
      text: widget.product?.price.toStringAsFixed(2) ?? '',
    );
    _stockController = TextEditingController(
      text: widget.product?.quantity.toString() ?? '',
    );
    _manufacturerController = TextEditingController(
      text: widget.product?.manufacturer ?? '',
    );
    _categoryController = TextEditingController();
    _selectedCategory = widget.product?.category;
    
    // If product category doesn't exist in the list, set custom category
    if (_selectedCategory != null && 
        !productController.categories.contains(_selectedCategory)) {
      _isCustomCategory = true;
      _categoryController.text = _selectedCategory!;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _manufacturerController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final String category = _isCustomCategory 
            ? _categoryController.text.trim() 
            : _selectedCategory!;
            
        final product = ProductModel(
          id: widget.product?.id,
          name: _nameController.text.trim(),
          category: category,
          price: double.parse(_priceController.text),
          quantity: int.parse(_stockController.text),
          manufacturer: _manufacturerController.text.trim(),
          createdAt: widget.product?.createdAt,
          organizationId: widget.product?.organizationId,
          createdBy: widget.product?.createdBy,
          isActive: true, // Default to active
        );

        await widget.onSubmit(product);
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final maxWidth = screenSize.width > 600 ? 600.0 : screenSize.width * 0.95;
    final primaryColor = Theme.of(context).primaryColor;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: maxWidth,
          maxHeight: screenSize.height * 0.85,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(primaryColor),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: _buildForm(primaryColor),
                  ),
                ),
              ],
            ),
            if (_isLoading)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.05),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Row(
        children: [
          Icon(
            isEditing ? Icons.edit : Icons.add,
            color: primaryColor,
            size: 22,
          ),
          const SizedBox(width: 12),
          Text(
            isEditing ? 'Edit Product' : 'Add New Product',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: () => Get.back(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            color: Colors.grey.shade700,
          ),
        ],
      ),
    );
  }

  Widget _buildForm(Color primaryColor) {
    final screenWidth = MediaQuery.of(context).size.width;
    final useDoubleColumn = screenWidth > 500;
    
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Name field
          _buildTextField(
            controller: _nameController,
            label: 'Product Name',
            prefixIcon: Icons.inventory,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter product name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Category - either dropdown or text field
          _buildCategorySection(),
          const SizedBox(height: 16),
          
          // Price and Quantity fields
          if (useDoubleColumn)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildPriceField()),
                const SizedBox(width: 12),
                Expanded(child: _buildQuantityField()),
              ],
            )
          else
            Column(
              children: [
                _buildPriceField(),
                const SizedBox(height: 16),
                _buildQuantityField(),
              ],
            ),
          
          const SizedBox(height: 16),
          
          // Manufacturer field
          _buildTextField(
            controller: _manufacturerController,
            label: 'Manufacturer',
            prefixIcon: Icons.factory,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter manufacturer';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          
          // Buttons
          _buildButtons(primaryColor),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData prefixIcon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefixIcon, color: Theme.of(context).primaryColor, size: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      validator: validator,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 15),
    );
  }

  Widget _buildPriceField() {
    return _buildTextField(
      controller: _priceController,
      label: 'Price (₹)',
      prefixIcon: Icons.currency_rupee,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter price';
        }
        final price = double.tryParse(value);
        if (price == null || price <= 0) {
          return 'Invalid price';
        }
        return null;
      },
    );
  }

  Widget _buildQuantityField() {
    return _buildTextField(
      controller: _stockController,
      label: 'Quantity',
      prefixIcon: Icons.inventory_2,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter quantity';
        }
        final stock = int.tryParse(value);
        if (stock == null || stock < 0) {
          return 'Invalid quantity';
        }
        return null;
      },
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _isCustomCategory 
                  ? _buildTextField(
                      controller: _categoryController,
                      label: 'Custom Category',
                      prefixIcon: Icons.category,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter category';
                        }
                        return null;
                      },
                    )
                  : _buildCategoryDropdown(),
            ),
            IconButton(
              icon: Icon(
                _isCustomCategory ? Icons.list : Icons.add, 
                size: 20,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                setState(() {
                  _isCustomCategory = !_isCustomCategory;
                  if (_isCustomCategory && _selectedCategory != null) {
                    _categoryController.text = _selectedCategory!;
                  }
                });
              },
              tooltip: _isCustomCategory 
                  ? 'Choose from list' 
                  : 'Create custom category',
            ),
          ],
        ),
        if (!_isCustomCategory)
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 4),
            child: Text(
              'Or tap + to create a custom category',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),
          )
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    return Obx(() {
      final categories = productController.categories;
      
      return DropdownButtonFormField<String>(
        value: _selectedCategory,
        decoration: InputDecoration(
          labelText: 'Category',
          prefixIcon: Icon(Icons.category, color: Theme.of(context).primaryColor, size: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
        items: categories.map((category) {
          return DropdownMenuItem(
            value: category,
            child: Text(category),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedCategory = value;
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select a category';
          }
          return null;
        },
        icon: Icon(
          Icons.arrow_drop_down_circle,
          color: Theme.of(context).primaryColor,
          size: 18,
        ),
        style: const TextStyle(fontSize: 15, color: Colors.black87),
      );
    });
  }

  Widget _buildButtons(Color primaryColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Get.back(),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            foregroundColor: Colors.grey.shade700,
          ),
          child: const Text('Cancel', style: TextStyle(fontSize: 14)),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: _isLoading ? null : _submitForm,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(isEditing ? Icons.save : Icons.add, size: 18, color: Colors.white),
              const SizedBox(width: 6),
              Text(
                isEditing ? 'Update' : 'Add',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}