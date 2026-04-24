// lib/features/auth/presentation/bloc/login_state.dart
import 'package:equatable/equatable.dart';

enum LoginStatus { idle, loading, success, failure }

final class LoginState extends Equatable {
  const LoginState({
    this.status = LoginStatus.idle,
    this.errorMessage,
  });

  final LoginStatus status;
  final String? errorMessage;

  LoginState copyWith({
    LoginStatus? status,
    String? errorMessage,
  }) {
    return LoginState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}