import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/toast.dart';
import '../../screens/OTPVerify.dart';
import '../../screens/home.dart';
import '../../screens/login.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Future<UserCredential> signUpWithEmailPassword(email, password, context) async {
    try {
      showLoadingDialog(context);
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      Navigator.pop(context);
      showToast(message: "Sign up successfully");
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.leftToRightWithFade,
          duration: Duration(milliseconds: 500),
          child: LoginPage(),
        ),
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      throw Exception(e.code);
    }
  }

  Future<UserCredential> logInWithEmailPassword(email, password, context) async {
    try {
      showLoadingDialog(context);
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      Navigator.pop(context);
      showToast(message: "Login successfully");
      return userCredential;
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      throw Exception(e.code);
    }
  }

  Future<void> logOut(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('stayLoggedIn');
    await prefs.remove('googleLoggedIn');
    await _firebaseAuth.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
  }

  Future<void> resetPassword(String email, BuildContext context) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      showToast(message: "Password reset email sent");
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      showToast(message: "Password reset failed: ${e.message}");
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await _firebaseAuth.signInWithCredential(credential);
  }

  Future<void> handleGoogleSignIn(BuildContext context) async {
    try {
      UserCredential userCredential = await signInWithGoogle();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('googleLoggedIn', true);

      showToast(message: "Login with Google successfully");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (e) {
      showToast(message: "Google Sign-In failed: ${e.toString()}");
    }
  }

  Future<void> signInWithPhoneNumber(String phoneNumber, BuildContext context) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _firebaseAuth.signInWithCredential(credential);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        },
        verificationFailed: (FirebaseAuthException e) {
          showToast(message: 'Verification failed: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OTPVerifyPage(verificationId: verificationId),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
        },
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }
}
