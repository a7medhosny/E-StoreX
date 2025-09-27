import 'package:ecommerce/features/auth/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class OrderTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const OrderTextField({
    super.key,
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      labelText: label,
      controller: controller,
      keyboardType: keyboardType,
      validator: validator ?? (v) => v == null || v.isEmpty ? "Please enter $label" : null,
    );
  }
}
