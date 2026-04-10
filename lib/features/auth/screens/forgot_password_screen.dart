import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_names.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _emailFocus = FocusNode();

  bool _loading = false;
  bool _sent = false;
  String? _error;

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
    _emailController.dispose();
    _emailFocus.dispose();
    _animController.dispose();
    super.dispose();
  }

  bool get _canSend => _emailController.text.trim().isNotEmpty;

  Future<void> _sendReset() async {
    if (!_canSend || _loading) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _error = null;
      _loading = true;
    });
    HapticFeedback.lightImpact();

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      if (!mounted) return;
      setState(() => _sent = true);
    } on FirebaseAuthException catch (e) {
      setState(() => _error = _firebaseMessage(e.code));
    } catch (_) {
      setState(() => _error = 'Что-то пошло не так. Попробуй ещё раз.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _firebaseMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Пользователь с таким email не найден';
      case 'invalid-email':
        return 'Неверный формат email';
      case 'too-many-requests':
        return 'Слишком много попыток. Подожди немного.';
      default:
        return 'Ошибка. Попробуй ещё раз.';
    }
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
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
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
                    _NovaLogo(),

                    const SizedBox(height: 32),

                    // ── Иконка ───────────────────────────────
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: _sent
                          ? _SuccessIcon(key: const ValueKey('success'))
                          : _LockIcon(key: const ValueKey('lock')),
                    ),

                    const SizedBox(height: 28),

                    // ── Заголовок ────────────────────────────
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _sent
                          ? const Text(
                              'Письмо отправлено!',
                              key: ValueKey('title_sent'),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF2B2B8A),
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.3,
                              ),
                            )
                          : const Text(
                              'Забыли пароль?',
                              key: ValueKey('title_default'),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF2B2B8A),
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.3,
                              ),
                            ),
                    ),

                    const SizedBox(height: 10),

                    // ── Подзаголовок ─────────────────────────
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _sent
                          ? Text(
                              'Мы отправили ссылку для сброса пароля на\n${_emailController.text.trim()}',
                              key: const ValueKey('sub_sent'),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.45),
                                fontSize: 15,
                                height: 1.5,
                              ),
                            )
                          : Text(
                              'Введи email — мы отправим\nссылку для сброса пароля',
                              key: const ValueKey('sub_default'),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.45),
                                fontSize: 15,
                                height: 1.5,
                              ),
                            ),
                    ),

                    const SizedBox(height: 40),

                    // ── Форма или кнопка «Войти» ─────────────
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _sent
                          ? _BackToLoginButton(
                              key: const ValueKey('back'),
                              onTap: () => context.go(RouteNames.login),
                            )
                          : _FormSection(
                              key: const ValueKey('form'),
                              emailController: _emailController,
                              emailFocus: _emailFocus,
                              loading: _loading,
                              canSend: _canSend,
                              error: _error,
                              onChanged: (_) =>
                                  setState(() => _error = null),
                              onSubmitted: (_) => _sendReset(),
                              onSend: _sendReset,
                            ),
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

// ─────────────────────────────────────────────
// Форма (поле + кнопка + ошибка)
// ─────────────────────────────────────────────

class _FormSection extends StatelessWidget {
  final TextEditingController emailController;
  final FocusNode emailFocus;
  final bool loading;
  final bool canSend;
  final String? error;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onSend;

  const _FormSection({
    super.key,
    required this.emailController,
    required this.emailFocus,
    required this.loading,
    required this.canSend,
    required this.error,
    required this.onChanged,
    required this.onSubmitted,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Поле email
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: error != null
                  ? const Color(0xFFD32F2F).withOpacity(0.4)
                  : const Color(0xFFDDDBEE),
              width: 1.5,
            ),
          ),
          child: TextField(
            controller: emailController,
            focusNode: emailFocus,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            style: const TextStyle(
              color: Color(0xFF1A1A1A),
              fontSize: 15,
            ),
            decoration: const InputDecoration(
              hintText: 'Электронная почта',
              hintStyle: TextStyle(
                color: Color(0xFF9E9CBB),
                fontSize: 15,
              ),
              prefixIcon: Icon(
                Icons.email_outlined,
                color: Color(0xFF9E9CBB),
                size: 20,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),

        if (error != null) ...[
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              error!,
              style: const TextStyle(
                color: Color(0xFFD32F2F),
                fontSize: 13,
              ),
            ),
          ),
        ],

        const SizedBox(height: 24),

        // Кнопка отправить
        _SendButton(
          loading: loading,
          enabled: canSend,
          onTap: onSend,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Кнопка «Отправить»
// ─────────────────────────────────────────────

class _SendButton extends StatefulWidget {
  final bool loading;
  final bool enabled;
  final VoidCallback onTap;

  const _SendButton({
    required this.loading,
    required this.enabled,
    required this.onTap,
  });

  @override
  State<_SendButton> createState() => _SendButtonState();
}

class _SendButtonState extends State<_SendButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.enabled ? (_) => setState(() => _pressed = true) : null,
      onTapUp: widget.enabled
          ? (_) {
              setState(() => _pressed = false);
              widget.onTap();
            }
          : null,
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: widget.enabled
                ? const Color(0xFF2B2B8A)
                : const Color(0xFFAAAAAA),
            borderRadius: BorderRadius.circular(28),
            boxShadow: widget.enabled
                ? [
                    BoxShadow(
                      color: const Color(0xFF2B2B8A).withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: widget.loading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : const Text(
                    'Отправить ссылку',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Кнопка «Вернуться к входу» (после отправки)
// ─────────────────────────────────────────────

class _BackToLoginButton extends StatelessWidget {
  final VoidCallback onTap;

  const _BackToLoginButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Кнопка войти
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF2B2B8A),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2B2B8A).withOpacity(0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'Вернуться к входу',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Не пришло письмо?
        Text(
          'Не пришло письмо? Проверь папку «Спам»',
          style: TextStyle(
            color: Colors.black.withOpacity(0.4),
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Иконки состояния
// ─────────────────────────────────────────────

class _LockIcon extends StatelessWidget {
  const _LockIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFF2B2B8A).withOpacity(0.08),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.lock_reset_rounded,
        color: Color(0xFF2B2B8A),
        size: 38,
      ),
    );
  }
}

class _SuccessIcon extends StatelessWidget {
  const _SuccessIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFF2ECC9A).withOpacity(0.12),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.mark_email_read_outlined,
        color: Color(0xFF2ECC9A),
        size: 38,
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Логотип NOVA
// ─────────────────────────────────────────────

class _NovaLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFF3B3B8E),
            borderRadius: BorderRadius.circular(9),
          ),
          child: const Center(
            child: Text(
              'N',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: -1,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          'NOVA',
          style: TextStyle(
            color: Color(0xFF3B3B8E),
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}