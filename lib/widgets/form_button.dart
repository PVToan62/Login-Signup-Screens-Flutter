import 'package:flutter/material.dart';

Widget FormButton({
  required String text,
  required bool Function() isEnabled,
  required VoidCallback onPressed,
}) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
    ),
    child: FloatingActionButton(
      onPressed: isEnabled() ? onPressed : null,
      backgroundColor: isEnabled() ? Colors.blue : Colors.grey,
      foregroundColor: Colors.white,
      child: Text(
        text,
        style: TextStyle(fontSize: 20),
      ),
    ),
  );
}
