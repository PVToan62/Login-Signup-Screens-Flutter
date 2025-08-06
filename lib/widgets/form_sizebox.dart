import 'package:flutter/material.dart';

Widget formSizeBox({
  required TextEditingController controller,
  required bool Function(String) validFunc,
  required String errorText,
}) {
  return SizedBox(
    height: 30,
    child: Visibility(
      visible: controller.text.isNotEmpty && !validFunc(controller.text),
      child: Container(
        alignment: Alignment.topLeft,
        child: Text(
          errorText,
          style: TextStyle(color: Colors.red),
        ),
      ),
    ),
  );
}
