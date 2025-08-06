import 'package:flutter/material.dart';

Widget FormTextField({
  required TextEditingController controller,
  required String labelText,
  bool isPassword = false,
  bool obscureText = false,
  Function(String)? onChanged,
  VoidCallback? onToggleVisibility,
  bool Function(String)? validator,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          suffixIcon: isPassword
              ? IconButton(
            onPressed: onToggleVisibility,
            icon: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
            ),
          )
              : null,
        ),
        onChanged: onChanged,
      ),
    ],
  );
}
