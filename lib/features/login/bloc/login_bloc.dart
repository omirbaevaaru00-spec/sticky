// lib/features/auth/presentation/bloc/login_bloc.dart
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:stiky/core/models/user_model.dart';
import 'package:stiky/data/auth/auth_repository.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const LoginState()) {
    on<LoginGoogleSignInPressed>(_onGoogleSignInPressed);
    on<LoginUserReceived>(_onUserReceived);
    on<LoginFailed>(_onFailed);
  }

  final AuthRepository _authRepository;
  StreamSubscription<UserModel?>? _userSubscription;

  Future<void> _onGoogleSignInPressed(
    LoginGoogleSignInPressed event,
    Emitter<LoginState> emit,
  ) async {
    if (state.status == LoginStatus.loading) return;

    emit(state.copyWith(status: LoginStatus.loading, errorMessage: null));

    await _userSubscription?.cancel();
    _userSubscription = _authRepository.user.listen((user) {
      if (user != null) {
        add(LoginUserReceived(user));
      }
    }, onError: (Object error) => add(LoginFailed(error)));

    try {
      await _authRepository.signInWithGoogle();
    } catch (error) {
      add(LoginFailed(error));
    }
  }

  void _onUserReceived(LoginUserReceived event, Emitter<LoginState> emit) {
    emit(state.copyWith(status: LoginStatus.success));
  }

  void _onFailed(LoginFailed event, Emitter<LoginState> emit) {
    emit(
      state.copyWith(
        status: LoginStatus.failure,
        errorMessage: 'Не удалось войти через Google. Попробуй ещё раз.',
      ),
    );
  }

  @override
  Future<void> close() async {
    await _userSubscription?.cancel();
    return super.close();
  }
}
