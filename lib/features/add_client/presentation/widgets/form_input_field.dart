import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData? prefixIcon;
  final Widget? suffix;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final int? maxLines;
  final int? minLines;
  final bool readOnly;
  final VoidCallback? onTap;
  final Function(String)? onChanged;

  final Color? textColor;
  final Color? prefixIconColor;
  final Color? labelColor;

  const FormInputField({
    Key? key,
    required this.controller,
    required this.label,
    this.hint,
    this.prefixIcon,
    this.suffix,
    this.obscureText = false,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
    this.maxLines = 1,
    this.minLines,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.textColor,
    this.labelColor,
    this.prefixIconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: textColor ?? Colors.black),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(color: labelColor ?? Colors.grey),
        hintStyle: TextStyle(color: textColor?.withOpacity(0.6) ?? Colors.grey[600]),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: prefixIconColor ?? Colors.grey)
            : null,
        suffix: suffix,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: prefixIconColor ?? Colors.blue),
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      obscureText: obscureText,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      maxLines: maxLines,
      minLines: minLines,
      readOnly: readOnly,
      onTap: onTap,
      onChanged: onChanged,
    );
  }
}
