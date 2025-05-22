// lib/providers/auth_provider.dart
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../repositories/firebase_auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../pages/login_page.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _auth = FirebaseAuthRepository();

  UserModel? user;
  bool isLoading = true; // пока выясняем статус на старте
  String? error;

  AuthProvider() {
    // слушаем изменение статуса
    _auth.authStateChanges().listen((u) {
      user = u;
      isLoading = false;
      notifyListeners();
    });
  }

  Future<void> login(String email, String pass) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      user = await _auth.login(email: email, password: pass);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(String email, String pass) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      user = await _auth.register(email: email, password: pass);
    } on fb.FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        error = 'This email is already in use';
      } else {
        error = e.message ?? e.toString();
      }
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout(BuildContext context) async {
    await _auth.logout();
    // После выхода — переход на экран логина
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => LoginPage()),
      (route) => false,
    );
  }

  Future<void> signInWithGoogle() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      user = await (_auth as FirebaseAuthRepository).signInWithGoogle();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signInAnonymously() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      user = await (_auth as FirebaseAuthRepository).signInAnonymously();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Widget logoutButton(BuildContext context) {
    if (user != null) {
      return ElevatedButton(
        onPressed: () => logout(context),
        child: const Text('Logout'),
      );
    }
    return const SizedBox.shrink();
  }
}
