import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:stiky/data/auth/auth_repository.dart';

import 'splash_state.dart';

/// Cubit splash-экрана.
///
/// При инициализации проверяет наличие сессии
/// и переводит состояние в [SplashStatus.authenticated]
/// или [SplashStatus.unauthenticated].
class SplashCubit extends Cubit<SplashState> {
  SplashCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const SplashState());

  final AuthRepository _authRepository;
  final _logger = Logger();

  /// Минимальная длительность показа splash-экрана (UX).
  static const _minSplashDuration = Duration(milliseconds: 1500);

  /// Запускает проверку авторизации.
  Future<void> checkAuth() async {
    emit(state.copyWith(status: SplashStatus.loading));

    final stopwatch = Stopwatch()..start();

    try {
      final isAuthenticated = await _authRepository.isAuthenticated();

      // Гарантируем минимальное время показа splash.
      final elapsed = stopwatch.elapsed;
      if (elapsed < _minSplashDuration) {
        await Future<void>.delayed(_minSplashDuration - elapsed);
      }

      emit(
        state.copyWith(
          status: isAuthenticated
              ? SplashStatus.authenticated
              : SplashStatus.unauthenticated,
        ),
      );
    } catch (e, st) {
      _logger.e('Ошибка проверки авторизации', error: e, stackTrace: st);
      emit(state.copyWith(status: SplashStatus.unauthenticated));
    }
  }
}
