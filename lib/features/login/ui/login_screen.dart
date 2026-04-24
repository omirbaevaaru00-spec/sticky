// lib/features/auth/presentation/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stiky/data/auth/auth_remote_datasource.dart';
import 'package:stiky/data/auth/auth_repository.dart';
import 'package:stiky/data/auth/auth_repository_impl.dart';
import 'package:stiky/data/auth/user_remote_datasource.dart';
import 'package:stiky/features/auth/screens/google_sign_in_button.dart';
import 'package:stiky/features/login/bloc/login_bloc.dart';
import 'package:stiky/features/login/bloc/login_event.dart';
import 'package:stiky/features/login/bloc/login_state.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LoginBloc(authRepository: AuthRepositoryImpl.instance),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeIn = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF0EEF8),
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeIn,
            child: BlocListener<LoginBloc, LoginState>(
              listenWhen: (prev, curr) => prev.status != curr.status,
              listener: (context, state) {
                if (state.status == LoginStatus.failure &&
                    state.errorMessage != null) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(state.errorMessage!),
                        backgroundColor: const Color(0xFFD32F2F),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                }
                // При success навигация произойдёт через GoRouter redirect,
                // который слушает UserBloc.
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16),

                    // ── Назад ────────────────────────────────
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => context.pop(),
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            color: Color(0xFF3B3B8E),
                            size: 24,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // ── Логотип ──────────────────────────────
                    Image.asset('assets/images/nova_logo.png'),

                    const SizedBox(height: 24),

                    // ── Заголовок ────────────────────────────
                    const Text(
                      'Снова вместе!',
                      style: TextStyle(
                        color: Color(0xFF2B2B8A),
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Войди через Google, чтобы продолжить',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.45),
                        fontSize: 15,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 56),

                    // ── Кнопка Google ────────────────────────
                    BlocBuilder<LoginBloc, LoginState>(
                      buildWhen: (prev, curr) => prev.status != curr.status,
                      builder: (context, state) {
                        final loading = state.status == LoginStatus.loading;
                        return GoogleSignInButton(
                          isLoading: loading,
                          onPressed: loading
                              ? null
                              : () {
                                  HapticFeedback.lightImpact();
                                  context.read<LoginBloc>().add(
                                    const LoginGoogleSignInPressed(),
                                  );
                                },
                        );
                      },
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
