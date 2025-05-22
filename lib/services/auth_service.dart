import '../models/user_model.dart';

abstract class AuthService {
  Future<UserModel> login({required String email, required String password});

  Future<UserModel> register({required String email, required String password});

  Future<void> logout();

  UserModel? get currentUser;

  Stream<UserModel?> authStateChanges();
}
