import 'package:flutter/material.dart';

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    required this.fieldController,
    required this.label,
    required this.fieldValidator,
    this.obscureText = false
    
    });

final TextEditingController fieldController;

final String label;
final bool obscureText;
final String? Function(String?) fieldValidator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: fieldController,
      obscureText: obscureText,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder()
      ),
      validator: fieldValidator,
    );
  }
}