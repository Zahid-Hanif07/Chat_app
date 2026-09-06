import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/services/firestore_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignupProvider extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirestoreServices _firestoreServices = FirestoreServices();

  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Method for signup
  Future<bool> signUp() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    final name = nameController.text.trim();
    String username = usernameController.text.trim();
    if (username.startsWith('@')) {
      username = username.substring(1);
    }
    username = username.toLowerCase();

    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    // Validation
    if (name.isEmpty || username.isEmpty || email.isEmpty || password.isEmpty) {
      _isLoading = false;
      _errorMessage = 'All fields are required';
      notifyListeners();
      return false;
    }

    if (username.length < 3) {
      _isLoading = false;
      _errorMessage = 'Username must be at least 3 characters';
      notifyListeners();
      return false;
    }

    final bool isTaken = await _firestoreServices.isUsernameTaken(username);
    if (isTaken) {
      _isLoading = false;
      _errorMessage = 'Username "@$username" is already taken. Please choose another.';
      notifyListeners();
      return false;
    }

    if (password != confirmPassword) {
      _isLoading = false;
      _errorMessage = 'Passwords do not match';
      notifyListeners();
      return false;
    }

    if (password.length < 6) {
      _isLoading = false;
      _errorMessage = 'Password must be at least 6 characters';
      notifyListeners();
      return false;
    }

    try {
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        await _firestoreServices.createUser(
          UserModel(
            uid: user.uid,
            name: name,
            username: username,
            email: email,
            imageUrl: null,
            isOnline: true,
            createdAt: DateTime.now().toIso8601String(),
          ),
        );
      }

      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _errorMessage = 'The password provided is too weak';
      } else if (e.code == 'email-already-in-use') {
        _errorMessage = 'The account already exists for that email';
      } else {
        _errorMessage = 'Something went wrong. Please try again.';
      }
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Sign up with google
  Future<bool> signInWithGoogle() async {
    try {
      _isLoading = true;
      _errorMessage = '';
      notifyListeners();

      // 1. Open Google account picker
      final GoogleSignInAccount googleUser = await GoogleSignIn.instance
          .authenticate();

      // 2. Get Google authentication details
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // 3. Create Firebase credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // 4. Sign in to Firebase
      final UserCredential userCredential = await auth.signInWithCredential(
        credential,
      );

      final User firebaseUser = userCredential.user!;

      // 5. Check if user already exists in Firestore
      final existingUser = await _firestoreServices.getUser(firebaseUser.uid);

      // 6. Create Firestore profile only for a new user
      if (existingUser == null) {
        final defaultUsername = firebaseUser.email != null
            ? firebaseUser.email!.split('@').first.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '').toLowerCase()
            : (firebaseUser.displayName ?? 'user').replaceAll(' ', '').toLowerCase();

        final UserModel userModel = UserModel(
          uid: firebaseUser.uid,
          name: firebaseUser.displayName ?? 'User',
          username: defaultUsername,
          email: firebaseUser.email ?? '',
          imageUrl: firebaseUser.photoURL,
          isOnline: true,
          createdAt: DateTime.now().toIso8601String(),
        );

        await _firestoreServices.createUser(userModel);
      } else {
        // Existing user -> mark online
        await _firestoreServices.updateOnlineStatus(
          uid: firebaseUser.uid,
          isOnline: true,
        );
      }

      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getErrorMessage(e.code);
      return false;
    } catch (e) {
      _errorMessage = 'Google sign-in failed. Please try again.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'weak-password':
        return 'The password provided is too weak';

      case 'email-already-in-use':
        return 'The account already exists for that email';

      case 'invalid-email':
        return 'The email address is not valid';

      case 'account-exists-with-different-credential':
        return 'This email is already registered with another sign-in method';

      default:
        return 'Authentication failed. Please try again.';
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // Method to clear form
  void clearForm() {
    nameController.clear();
    usernameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    _errorMessage = '';
    _isLoading = false;
    notifyListeners();
  }
}
