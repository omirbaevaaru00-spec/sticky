import 'package:supabase_flutter/supabase_flutter.dart';

/// Удалённый источник данных для аутентификации.
///
/// Инкапсулирует обращения к Supabase Auth —
/// остальной код приложения не импортирует Supabase напрямую.
abstract class AuthRemoteDatasource {
  /// Возвращает `true`, если у пользователя есть активная сессия.
  Future<bool> isAuthenticated();
}

/// Реализация [AuthRemoteDatasource] через Supabase.
class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  AuthRemoteDatasourceImpl({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  Future<bool> isAuthenticated() async {
    final session = _client.auth.currentSession;
    return session != null;
  }
}
