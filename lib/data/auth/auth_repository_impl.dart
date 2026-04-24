import 'dart:async';

import 'package:stiky/core/models/user_model.dart';
import 'package:stiky/data/auth/auth_remote_datasource.dart';
import 'package:stiky/data/auth/auth_repository.dart';


import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:stiky/data/auth/user_remote_datasource.dart';


class AuthRepositoryImpl implements AuthRepository {
  /// Приватный конструктор — запрещает создание через `new`.
  AuthRepositoryImpl._()
      : _authDatasource = AuthRemoteDatasourceImpl(),
        _userDatasource = UserRemoteDatasourceImpl();

  /// Единственный instance на всё приложение.
  static final AuthRepositoryImpl instance = AuthRepositoryImpl._();

  final AuthRemoteDatasource _authDatasource;
  final UserRemoteDatasource _userDatasource;

  @override
  Stream<UserModel?> get user =>
      _authDatasource.authStateChanges.asyncMap(_mapFirebaseUser);

  @override
  Future<bool> isAuthenticated() => _authDatasource.isAuthenticated();

  @override
  Future<UserModel?> signInWithGoogle() async {
    final credential = await _authDatasource.signInWithGoogle();
    final firebaseUser = credential?.user;
    if (firebaseUser == null) return null;

    final userModel = _userModelFromFirebase(firebaseUser);
    await _userDatasource.saveUser(userModel);
    return userModel;
  }

  @override
  Future<void> signOut() => _authDatasource.signOut();

  Future<UserModel?> _mapFirebaseUser(fb.User? firebaseUser) async {
    if (firebaseUser == null) return null;

    final stored = await _userDatasource.getUser(firebaseUser.uid);
    return stored ?? _userModelFromFirebase(firebaseUser);
  }

  UserModel _userModelFromFirebase(fb.User firebaseUser) {
    return UserModel(
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName ?? '',
      photoUrl: firebaseUser.photoURL ?? '',
      uid: firebaseUser.uid,
    );
  }
}
