import 'package:equatable/equatable.dart';

/// Состояния splash-экрана.
enum SplashStatus {
  /// Начальное состояние — проверка ещё не запущена.
  initial,

  /// Идёт проверка авторизации.
  loading,

  /// Пользователь авторизован — переход на главный экран.
  authenticated,

  /// Пользователь не авторизован — переход на экран логина.
  unauthenticated,
}

/// Состояние [SplashCubit].
class SplashState extends Equatable {
  const SplashState({this.status = SplashStatus.initial});

  /// Текущий статус проверки.
  final SplashStatus status;

  /// Создаёт копию с изменённым полем.
  SplashState copyWith({SplashStatus? status}) {
    return SplashState(status: status ?? this.status);
  }

  @override
  List<Object?> get props => [status];
}
