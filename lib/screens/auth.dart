import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile/screens/google_sign_in.dart';
import 'package:mobile/screens/home.dart';
import 'package:mobile/screens/register.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  AuthPageState createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  final GoogleSignInProviders _googleSignInProviders = GoogleSignInProviders();

  int _failedAttempts = 0;
  bool _isBlocked = false;
  DateTime? _blockEndTime;

  Future<void> _signInWithEmailAndPassword() async {
    if (_isLoading || _isBlocked) return;

    if (_isBlocked) {
      final remainingTime =
          _blockEndTime?.difference(DateTime.now()).inSeconds ?? 0;
      _showErrorDialog(
          'Please wait $remainingTime seconds before trying again.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();

      if (email.isEmpty || password.isEmpty) {
        _showErrorDialog('Please enter your email and password');
        return;
      }

      // Tentative de connexion
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _failedAttempts = 0;

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Home()),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No users found with this email.';
          break;
        case 'wrong-password':
          errorMessage = 'Invalid email or password.';
          break;
        case 'invalid-email':
          errorMessage = 'The email format is invalid.';
          break;
        default:
          errorMessage = 'An unexpected error occurred: ${e.message}';
          break;
      }

      // Incrémentez les tentatives échouées
      _failedAttempts++;
      if (_failedAttempts >= 3) {
        _isBlocked = true;
        _blockEndTime = DateTime.now()
            .add(const Duration(seconds: 30)); // Blocage de 30 secondes
        Future.delayed(const Duration(seconds: 30), () {
          setState(() {
            _isBlocked = false;
            _failedAttempts = 0;
          });
        });
        errorMessage = 'Too many failed attempts. Please try again later.';
      }

      _showErrorDialog(errorMessage);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _googleSignInProviders.googleLogin(context);
    } catch (e) {
      if (!mounted) return;

      _showErrorDialog('Error connecting to Google');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _navigateToRegister() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              height: 150,
              width: 150,
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Login',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 32.0),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: 'Email',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Password',
              ),
            ),
            const SizedBox(height: 32.0),
            if (_isBlocked)
              Text(
                'You are temporarily blocked. Please wait ${_blockEndTime?.difference(DateTime.now()).inSeconds ?? 0} seconds.',
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 8.0),
            _isLoading
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: 300,
                    child: ElevatedButton(
                      onPressed: _signInWithEmailAndPassword,
                      child: const Text('Connection'),
                    ),
                  ),
            const SizedBox(height: 16.0),
            _isLoading
                ? const SizedBox.shrink()
                : SizedBox(
                    width: 300,
                    child: ElevatedButton(
                      onPressed: _signInWithGoogle,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset('assets/logo-google.png', height: 24.0),
                          const SizedBox(width: 8.0),
                          const Text('Connection with Google'),
                        ],
                      ),
                    ),
                  ),
            const SizedBox(height: 16.0),
            TextButton(
              onPressed: _isLoading ? null : _navigateToRegister,
              child: const Text('No account? Register'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
