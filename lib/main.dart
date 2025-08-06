import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/home.dart';
import 'screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  FirebaseOptions? firebaseOptions;
  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
      firebaseOptions = FirebaseOptions(
        apiKey: dotenv.env['FIREBASE_ANDROID_API_KEY']!,
        appId: dotenv.env['FIREBASE_ANDROID_APP_ID']!,
        messagingSenderId: dotenv.env['FIREBASE_ANDROID_MESSAGING_SENDER_ID']!,
        projectId: dotenv.env['FIREBASE_ANDROID_PROJECT_ID']!,
        storageBucket: dotenv.env['FIREBASE_ANDROID_STORAGE_BUCKET']!,
      );
      break;
    case TargetPlatform.iOS:
      firebaseOptions = FirebaseOptions(
        apiKey: dotenv.env['FIREBASE_IOS_API_KEY']!,
        appId: dotenv.env['FIREBASE_IOS_APP_ID']!,
        messagingSenderId: dotenv.env['FIREBASE_IOS_MESSAGING_SENDER_ID']!,
        projectId: dotenv.env['FIREBASE_IOS_PROJECT_ID']!,
        storageBucket: dotenv.env['FIREBASE_IOS_STORAGE_BUCKET']!,
        iosBundleId: dotenv.env['FIREBASE_IOS_BUNDLE_ID']!,
      );
      break;
    default:
      throw UnsupportedError('FirebaseOptions are not supported for this platform in .env.');
  }

  if (firebaseOptions != null) {
    await Firebase.initializeApp(options: firebaseOptions);
  }

  SharedPreferences prefs = await SharedPreferences.getInstance();
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

