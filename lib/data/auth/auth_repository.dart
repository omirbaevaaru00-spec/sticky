import 'package:stiky/core/models/user_model.dart';

abstract class AuthRepository {
  Stream<UserModel?> get user;

  Future<bool> isAuthenticated();
  Future<UserModel?> signInWithGoogle();
  Future<void> signOut();
}
