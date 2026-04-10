import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stiky/data/auth/auth_remote_datasource.dart';
import 'package:stiky/data/auth/auth_repository_impl.dart';
import 'package:stiky/features/splash/bloc/splash_cubit.dart';
import 'package:stiky/features/splash/bloc/splash_state.dart';


/// Splash-экран приложения.
///
/// Отображает лого (pin-иконку) по центру на тёмном фоне,
/// проверяет авторизацию и перенаправляет пользователя.
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final datasource = AuthRemoteDatasourceImpl();
        final repository = AuthRepositoryImpl(datasource: datasource);
        return SplashCubit(authRepository: repository)..checkAuth();
      },
      child: const _SplashView(),
    );
  }
}

class _SplashView extends StatelessWidget {
  const _SplashView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        switch (state.status) {
          case SplashStatus.authenticated:
            context.go('/home');
          case SplashStatus.unauthenticated:
            context.go('/login');
          case SplashStatus.initial:
          case SplashStatus.loading:
            break;
        }
      },
      child: Scaffold(
        body: Center(
          child: Image.asset(
            'assets/icons/splash_logo_1152.png',
            width: 180,
            height: 180,
          ),
        ),
      ),
    );
  }
}
