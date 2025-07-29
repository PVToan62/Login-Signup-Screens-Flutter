import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_signup_screens/components/toast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/form_sizebox.dart';
import '../components/form_text_field.dart';
import '../services/auth/AuthService.dart';
import 'forgotPassword.dart';
import 'home.dart';
import 'phoneNumberLogin.dart';
import 'signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _stayLoggedIn = false;
  bool _obscurePassword = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _validEmail(String email) {
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  bool _validPassword(String password) {
    if (password.length < 6 || RegExp(' ').hasMatch(password)) {
      return false;
    }
    return true;
  }

  bool _validForm() {
    return _validEmail(_emailController.text) &&
        _emailController.text.isNotEmpty &&
        _validPassword(_passwordController.text) &&
        _passwordController.text.isNotEmpty;
  }

  void _handleEmailPasswordLogin() {
    final authService = AuthService();
    authService
        .logInWithEmailPassword(
          _emailController.text.trim(),
          _passwordController.text.trim(),
          context,
        )
        .then((userCredential) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          if (_stayLoggedIn) {
            await prefs.setBool('stayLoggedIn', true);
          } else {
            await prefs.remove('stayLoggedIn');
          }
          showToast(message: "Login successfully");

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        })
        .catchError((e) {
          showToast(message: "Invalid email or password");
        });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: screenHeight/3,
              color: Colors.blueGrey,
              child: Center(
                child: Text(
                  "Log in",
                  style: GoogleFonts.monoton(fontSize: 50, color: Colors.white),
                ),
              ),
            ),
            Container(
              height: 380,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
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
                    FormTextField(
                      controller: _passwordController,
                      labelText: 'Password',
                      isPassword: true,
                      obscureText: _obscurePassword,
                      onChanged: (value) => setState(() {}),
                      onToggleVisibility: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    formSizeBox(
                      controller: _passwordController,
                      validFunc: _validPassword,
                      errorText: "Invalid password",
                    ),
                    Container(
                      child: Row(
                        children: [
                          Checkbox(
                            value: _stayLoggedIn,
                            onChanged: (value) {
                              setState(() {
                                _stayLoggedIn = value ?? false;
                              });
                            },
                          ),
                          const Text(
                            "Keep me logged in",
                            style: TextStyle(fontSize: 14),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ForgotPasswordPage(),
                                ),
                              );
                            },
                            child: const Text(
                              "Forgot password?",
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: FloatingActionButton(
                        onPressed: _validForm()
                            ? _handleEmailPasswordLogin
                            : null,
                        backgroundColor: _validForm()
                            ? Colors.blue
                            : Colors.grey,
                        foregroundColor: Colors.white,
                        child: Text("Log in", style: TextStyle(fontSize: 20)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(thickness: 1, color: Colors.grey[400]),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "Or continue with",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Expanded(
                          child: Divider(thickness: 1, color: Colors.grey[400]),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                        AuthService().handleGoogleSignIn(context);
                      },
                        icon: Image.asset(
                          'assets/icons/google_logo.svg.ico',
                          height: 24,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PhoneNumberLoginPage(),
                            ),
                          );
                        },
                        icon: Icon(Icons.phone_android),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an email?"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              alignment: Alignment.center,
                              type: PageTransitionType.rightToLeftWithFade,
                              duration: Duration(milliseconds: 500),
                              child: SignupPage(),
                            ),
                          );
                        },
                        child: Text("Sign up"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
