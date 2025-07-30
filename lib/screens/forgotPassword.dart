import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/form_button.dart';
import '../components/form_sizebox.dart';
import '../components/form_text_field.dart';
import '../services/auth/AuthService.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();

  bool _validEmail(String email) {
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text("Email for reset password", style: TextStyle(fontSize: 25)),
              SizedBox(height: 20),
              FormTextField(
                controller: _emailController,
                labelText: 'Email',
                onChanged: (value) => setState(() {}),
                validator: _validEmail,
              ),
              formSizeBox(
                controller: _emailController,
                validFunc: _validEmail,
                errorText: "Invalid email",
              ),
              FormButton(
                text: "Reset password",
                isEnabled: () => _validEmail(_emailController.text),
                onPressed: () {
                  AuthService().resetPassword(_emailController.text, context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
