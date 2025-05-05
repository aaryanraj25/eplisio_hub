import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

// In form_dropdown.dart
class FormDropdown<T> extends StatelessWidget {
  final String label;
  final String hint;
  final IconData? prefixIcon;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?) onChanged;
  final String? Function(T?)? validator;
  final bool isExpanded; // Add this parameter

  const FormDropdown({
    Key? key,
    required this.label,
    required this.hint,
    this.prefixIcon,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
    this.isExpanded = true, // Add with a default value
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) Text(label, style: Get.textTheme.labelMedium),
        if (label.isNotEmpty) const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: value,
          hint: Text(hint),
          isExpanded: isExpanded, // Pass the parameter here
          decoration: InputDecoration(
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          items: items,
          onChanged: onChanged,
          validator: validator,
        ),
      ],
    );
  }
}