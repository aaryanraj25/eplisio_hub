import 'package:flutter/material.dart';
import '../../data/model/product_model.dart';

class ProductListItem extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onToggleActive;

  const ProductListItem({
    Key? key,
    required this.product,
    required this.onEdit,
    required this.onDelete,
    this.onToggleActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: product.isActive 
                  ? primaryColor.withOpacity(0.03)
                  : Colors.grey.shade100,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Row(
              children: [
                // Status Indicator
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: product.isActive ? Colors.green : Colors.grey,
                  ),
                ),
                const SizedBox(width: 12),
                
                // Product Name & ID
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (product.id != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'ID: ${product.id}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                
                // Actions
                Row(
                  children: [
                    _buildActionButton(
                      context: context,
                      icon: Icons.edit_outlined,
                      color: primaryColor,
                      onTap: onEdit,
                      tooltip: 'Edit',
                    ),
                    _buildActionButton(
                      context: context,
                      icon: Icons.delete_outline,
                      color: Colors.red,
                      onTap: onDelete,
                      tooltip: 'Delete',
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Product Details
          Padding(
            padding: const EdgeInsets.all(12),
            child: isSmallScreen 
                ? _buildMobileLayout(context)
                : _buildDesktopLayout(context),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildInfoRow('Category', product.category),
      const SizedBox(height: 8),

      // Instead of a Row, use a Column to avoid width issues
      _buildInfoRow('Price', '₹${product.price.toStringAsFixed(2)}'),

      if (product.manufacturer.isNotEmpty) ...[
        const SizedBox(height: 8),
        _buildInfoRow('Manufacturer', product.manufacturer),
      ],
      const SizedBox(height: 16),
      _buildStockIndicator(context),
    ],
  );
}


  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow('Category', product.category),
              const SizedBox(height: 8),
              _buildInfoRow('Manufacturer', product.manufacturer),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildInfoChip(
                context: context,
                icon: Icons.attach_money,
                label: '₹${product.price.toStringAsFixed(2)}',
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: _buildStockIndicator(context),
        ),
      ],
    );
  }

  Widget _buildStockIndicator(BuildContext context) {
    final stockLevel = _getStockLevel(product.quantity);
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: stockLevel.level,
                backgroundColor: Colors.grey.shade200,
                color: stockLevel.color,
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${product.quantity} items',
            style: TextStyle(
              color: stockLevel.color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChip({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            size: 20,
            color: color,
          ),
        ),
      ),
    );
  }

  StockLevel _getStockLevel(int quantity) {
    if (quantity <= 0) {
      return StockLevel(0.0, Colors.red);
    } else if (quantity < 5) {
      return StockLevel(0.2, Colors.red.shade700);
    } else if (quantity < 10) {
      return StockLevel(0.4, Colors.orange);
    } else if (quantity < 20) {
      return StockLevel(0.6, Colors.amber.shade700);
    } else if (quantity < 50) {
      return StockLevel(0.8, Colors.green.shade600);
    } else {
      return StockLevel(1.0, Colors.green);
    }
  }
}

class StockLevel {
  final double level;
  final Color color;
  
  StockLevel(this.level, this.color);
}