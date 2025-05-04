import 'package:flutter/material.dart';

class FormDropdown<T> extends StatelessWidget {
  final String label;
  final String? hint;
  final IconData? prefixIcon;
  final T? value;
  final List<DropdownMenuItem<T>>? items;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;

  const FormDropdown({
    Key? key,
    required this.label,
    this.hint,
    this.prefixIcon,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      items: items,
      onChanged: onChanged,
      validator: validator,
      isExpanded: true,
      icon: const Icon(Icons.arrow_drop_down),
    );
  }
}