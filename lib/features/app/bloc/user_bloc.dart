import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stiky/core/models/user_model.dart';
import 'package:stiky/data/auth/auth_repository.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

/// Запуск отслеживания стрима пользователя.
final class UserStarted extends UserEvent {
  const UserStarted();
}

sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

/// Начальное состояние до первого события из стрима.
final class UserInitial extends UserState {
  const UserInitial();
}

/// Пользователь авторизован.
final class UserAuthenticated extends UserState {
  const UserAuthenticated(this.user);

  final UserModel user;

  @override
  List<Object?> get props => [user];
}

/// Пользователь не авторизован.
final class UserUnauthenticated extends UserState {
  const UserUnauthenticated();
}

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const UserInitial()) {
    on<UserStarted>(_onStarted);
  }

  final AuthRepository _authRepository;

  Future<void> _onStarted(UserStarted event, Emitter<UserState> emit) async {
    await emit.forEach<UserModel?>(
      _authRepository.user,
      onData: (user) =>
          user != null ? UserAuthenticated(user) : const UserUnauthenticated(),
      onError: (_, __) => const UserUnauthenticated(),
    );
  }
}
