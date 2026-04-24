// lib/features/auth/presentation/bloc/login_event.dart
import 'package:equatable/equatable.dart';
import 'package:stiky/core/models/user_model.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

/// Нажата кнопка входа через Google.
final class LoginGoogleSignInPressed extends LoginEvent {
  const LoginGoogleSignInPressed();
}

/// Из стрима пришёл авторизованный пользователь.
///
/// Внутреннее событие — эмитится подпиской на [AuthRepository.user],
/// не должно добавляться извне.
final class LoginUserReceived extends LoginEvent {
  const LoginUserReceived(this.user);

  final UserModel user;

  @override
  List<Object?> get props => [user];
}

/// Процесс логина завершился ошибкой.
///
/// Внутреннее событие — эмитится из catch-блока или onError стрима.
final class LoginFailed extends LoginEvent {
  const LoginFailed(this.error);

  final Object error;

  @override
  List<Object?> get props => [error];
}