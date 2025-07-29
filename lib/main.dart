import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/home.dart';
import 'screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  bool googleLoggedIn = prefs.getBool('googleLoggedIn') ?? false;
  bool stayLoggedIn = prefs.getBool('stayLoggedIn') ?? false;
  User? user = FirebaseAuth.instance.currentUser;

  bool shouldGoToHome = false;
  if (googleLoggedIn && user != null) {
    shouldGoToHome = true;
  } else if (stayLoggedIn && user != null) {
    shouldGoToHome = true;
  }

  runApp(MyApp(
    isLoggedIn: shouldGoToHome,
  ));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  MyApp({required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLoggedIn ? HomePage() : LoginPage(),
    );
  }
}

