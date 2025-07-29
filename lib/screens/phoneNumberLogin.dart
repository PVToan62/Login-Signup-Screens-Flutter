import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../components/form_sizebox.dart';
import '../services/auth/AuthService.dart';

class PhoneNumberLoginPage extends StatefulWidget {
  const PhoneNumberLoginPage({super.key});

  @override
  State<PhoneNumberLoginPage> createState() => _PhoneNumberLoginPageState();
}

class _PhoneNumberLoginPageState extends State<PhoneNumberLoginPage> {
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  bool _validPhoneNumber(String phoneNumber) {
    if (phoneNumber.length < 10 || phoneNumber.length > 11) {
      return false;
    }
    return true;
  }

  String formatPhoneNumber(String phoneNumber) {
    phoneNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');
    if (phoneNumber.startsWith('0')) {
      phoneNumber = '+84' + phoneNumber.substring(1);
    }
    return phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    String formattedPhone = formatPhoneNumber(_phoneNumberController.text);
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text("Phone number login", style: TextStyle(fontSize: 30)),
              SizedBox(height: 20),
              TextField(
                controller: _phoneNumberController,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: 'Phone number',
                  hintText: 'Enter your phone number',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
              formSizeBox(
                controller: _phoneNumberController,
                validFunc: _validPhoneNumber,
                errorText: "Invalid phone number",
              ),
              Container(
                width: double.infinity,
                child: FloatingActionButton(
                  onPressed: _validPhoneNumber(_phoneNumberController.text)
                      ? () => AuthService().signInWithPhoneNumber(
                          formattedPhone,
                          context,
                        )
                      : null,
                  backgroundColor:
                      _validPhoneNumber(_phoneNumberController.text)
                      ? Colors.blue
                      : Colors.grey,
                  foregroundColor: Colors.white,
                  child: Text("Send OTP", style: TextStyle(fontSize: 20)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
