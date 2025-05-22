// lib/pages/register_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  String? _inputError;

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _onRegister() async {
    setState(() => _inputError = null);
    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text;
    if (email.isEmpty || pass.isEmpty) {
      setState(() => _inputError = 'Email and password are required');
      return;
    }
    if (!_isValidEmail(email)) {
      setState(() => _inputError = 'Invalid email format');
      return;
    }
    if (pass.length < 6) {
      setState(() => _inputError = 'Password must be at least 6 characters');
      return;
    }
    try {
      await context.read<AuthProvider>().register(email, pass);
      final error = context.read<AuthProvider>().error;
      if (error != null) _showSnackBar(error);
    } catch (e) {
      _showSnackBar('Registration failed');
    }
  }

  @override
  Widget build(BuildContext c) {
    final auth = context.watch<AuthProvider>();
    final isBusy = auth.isLoading;

    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (_inputError != null)
              Text(_inputError!, style: TextStyle(color: Colors.red)),
            if (auth.error != null)
              Text(auth.error!, style: TextStyle(color: Colors.red)),
            TextField(
              controller: _emailCtrl,
              decoration: InputDecoration(labelText: 'Email'),
              enabled: !isBusy,
            ),
            TextField(
              controller: _passCtrl,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
              enabled: !isBusy,
            ),
            SizedBox(height: 20),
            isBusy
                ? const CircularProgressIndicator()
                : SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isBusy ? null : _onRegister,
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontWeight: FontWeight.w600),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text('Register'),
                  ),
                ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.login),
                label: const Text('Sign in with Google'),
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontWeight: FontWeight.w600),
                  minimumSize: const Size(double.infinity, 48),
                ),
                onPressed:
                    isBusy
                        ? null
                        : () => context.read<AuthProvider>().signInWithGoogle(),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.person_outline),
                label: const Text('Continue as Guest'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  foregroundColor: Theme.of(context).colorScheme.secondary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 1.5,
                    ),
                  ),
                  textStyle: const TextStyle(fontWeight: FontWeight.w600),
                  minimumSize: const Size(double.infinity, 48),
                ),
                onPressed:
                    isBusy
                        ? null
                        : () =>
                            context.read<AuthProvider>().signInAnonymously(),
              ),
            ),
            TextButton(
              onPressed:
                  isBusy
                      ? null
                      : () => Navigator.pushReplacementNamed(c, '/login'),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.secondary,
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              child: const Text('Have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }
}
