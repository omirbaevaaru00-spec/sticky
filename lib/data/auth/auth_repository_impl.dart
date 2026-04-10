
import 'package:stiky/data/auth/auth_remote_datasource.dart';

import 'auth_repository.dart';

/// Реализация [AuthRepository] через удалённый datasource.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required AuthRemoteDatasource datasource})
      : _datasource = datasource;

  final AuthRemoteDatasource _datasource;

  @override
  Future<bool> isAuthenticated() => _datasource.isAuthenticated();
}
