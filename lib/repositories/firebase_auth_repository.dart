import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthRepository implements AuthService {
  final fb.FirebaseAuth _fa = fb.FirebaseAuth.instance;
  final FirebaseFirestore _fs = FirebaseFirestore.instance;
  final Logger _logger = Logger();

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _fa.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _userFromFb(cred.user!);
    } on fb.FirebaseAuthException catch (e) {
      _logger.e(
        'FirebaseAuthException code: ${e.code}',
      ); // например, 'user-not-found', 'wrong-password', 'email-already-in-use'
      _logger.e('FirebaseAuthException message: ${e.message}');
      // Покажите пользователю e.message
      rethrow;
    } catch (e) {
      _logger.e('Exception: $e');
      rethrow;
    }
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _fa.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = _userFromFb(cred.user!);

      // Создаём профиль пользователя в Firestore
      await _fs.collection('users').doc(user.uid).set({
        'email': user.email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return user;
    } on fb.FirebaseAuthException catch (e) {
      _logger.e(
        'FirebaseAuthException code: ${e.code}',
      ); // например, 'user-not-found', 'wrong-password', 'email-already-in-use'
      _logger.e('FirebaseAuthException message: ${e.message}');
      // Покажите пользователю e.message
      rethrow;
    } catch (e) {
      _logger.e('Exception: $e');
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    await _fa.signOut();
  }

  @override
  UserModel? get currentUser {
    final fb.User? u = _fa.currentUser;
    return u != null ? _userFromFb(u) : null;
  }

  @override
  Stream<UserModel?> authStateChanges() {
    return _fa.authStateChanges().map(
      (fb.User? u) => u != null ? _userFromFb(u) : null,
    );
  }

  Future<UserModel> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      throw Exception('Google sign-in aborted');
    }
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final fb.AuthCredential credential = fb.GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final cred = await _fa.signInWithCredential(credential);
    return _userFromFb(cred.user!);
  }

  Future<UserModel> signInAnonymously() async {
    final cred = await _fa.signInAnonymously();
    return _userFromFb(cred.user!);
  }

  UserModel _userFromFb(fb.User u) => UserModel(uid: u.uid, email: u.email);
}

// Пример функции-обёртки для корректного преобразования результата
Future<PigeonUserDetails?> signInWithEmailAndPasswordFixed(
  String email,
  String password,
) async {
  final Object? raw = await FirebaseAuthPlatform.instance
      .signInWithEmailAndPassword(email, password);

  if (raw is List<Object?>) {
    // Если пришёл List<Object?>, декодируем вручную
    return PigeonUserDetails.decode(raw);
  } else if (raw is PigeonUserDetails) {
    return raw;
  } else {
    return null;
  }
}
