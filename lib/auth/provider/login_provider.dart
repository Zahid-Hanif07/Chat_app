import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  String _errorMessage = "";

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // method to sign in
  Future<bool> signIn() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _errorMessage = "Please Enter email and Password";
      notifyListeners();
      return false;
    }

    try {
      _isLoading = true;
      _errorMessage = "";
      notifyListeners();

      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getErrorMessage(e.code);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case "invalid-email":
        return "The email address is not valid.";
      case "user-not-found":
        return "No user found for this email.";
      case "wrong-password":
        return "Incorrect password.";
      case "invalid-credential":
        return "Invalid email or password.";
      case "user-disabled":
        return "User account has been disabled.";
      default:
        return "An unexpected error occurred. Please try again.";
    }
  }

  void clearForm() {
    emailController.clear();
    passwordController.clear();
    _errorMessage = '';
    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
