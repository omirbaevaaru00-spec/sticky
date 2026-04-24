import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'google_sign_in_button.dart';

import '../../../core/router/route_names.dart';

enum _InputMode { phone, email }

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  _InputMode _mode = _InputMode.phone;

  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneFocus = FocusNode();
  final _emailFocus = FocusNode();

  bool _loading = false;
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
    _phoneController.dispose();
    _emailController.dispose();
    _phoneFocus.dispose();
    _emailFocus.dispose();
    _animController.dispose();
    super.dispose();
  }

  String get _currentValue => _mode == _InputMode.phone
      ? _phoneController.text.trim()
      : _emailController.text.trim();

  bool get _canProceed => _currentValue.isNotEmpty;

  // Future<void> _proceed() async {
  //   if (!_canProceed || _loading) return;
  //   setState(() {
  //     _error = null;
  //     _loading = true;
  //   });
  //   HapticFeedback.lightImpact();

  //   try {
  //     if (_mode == _InputMode.email) {
  //       // Проверяем существует ли email — отправляем на экран пароля
  //       final methods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(
  //         _currentValue,
  //       );
  //       if (!mounted) return;
  //       // Переходим на profile_setup (новый) или login (существующий)
  //       if (methods.isEmpty) {
  //         context.push(
  //           RouteNames.profileSetup,
  //           extra: {'email': _currentValue},
  //         );
  //       } else {
  //         context.push(RouteNames.login, extra: {'email': _currentValue});
  //       }
  //     } else {
  //       // Телефон — переходим дальше с номером
  //       final phone = '+7${_phoneController.text.trim()}';
  //       context.push(RouteNames.profileSetup, extra: {'phone': phone});
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     setState(() => _error = _firebaseMessage(e.code));
  //   } catch (e) {
  //     setState(() => _error = 'Что-то пошло не так. Попробуй ещё раз.');
  //   } finally {
  //     if (mounted) setState(() => _loading = false);
  //   }
  // }

  // ── Замени метод _proceed() полностью ──
  Future<void> _proceed() async {
    if (!_canProceed || _loading) return;
    setState(() {
      _error = null;
      _loading = true;
    });
    HapticFeedback.lightImpact();

    try {
      if (_mode == _InputMode.email) {
        // Пробуем войти — если пользователь есть, идём на login
        // Если нет — на profile_setup
        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _currentValue,
            password: '________dummy________', // заведомо неверный пароль
          );
          // Если каким-то чудом зашло (не должно) — на профиль
          if (!mounted) return;
          context.go(RouteNames.home);
        } on FirebaseAuthException catch (e) {
          if (!mounted) return;
          if (e.code == 'user-not-found' || e.code == 'invalid-credential') {
            // Новый пользователь
            context.push(
              RouteNames.profileSetup,
              extra: {'email': _currentValue},
            );
          } else if (e.code == 'wrong-password' ||
              e.code == 'INVALID_LOGIN_CREDENTIALS') {
            // Пользователь существует — на экран пароля
            context.push(RouteNames.login, extra: {'email': _currentValue});
          } else {
            setState(() => _error = _firebaseMessage(e.code));
          }
        }
      } else {
        final phone = '+7${_phoneController.text.trim()}';
        context.push(RouteNames.profileSetup, extra: {'phone': phone});
      }
    } catch (e) {
      setState(() => _error = 'Что-то пошло не так. Попробуй ещё раз.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  // String _firebaseMessage(String code) {
  //   switch (code) {
  //     case 'invalid-email':
  //       return 'Неверный формат email';
  //     case 'too-many-requests':
  //       return 'Слишком много попыток. Подожди немного.';
  //     default:
  //       return 'Ошибка. Попробуй ещё раз.';
  //   }
  // }
  // ── Добавь в _firebaseMessage ──
  String _firebaseMessage(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Неверный формат email';
      case 'too-many-requests':
        return 'Слишком много попыток. Подожди немного.';
      case 'network-request-failed':
        return 'Нет интернета. Проверь соединение.';
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

                    // ── Верхняя навигация ────────────────────
                    Row(
                      children: [
                        // GestureDetector(
                        //   onTap: () => context.pop(),
                        //   child: const Icon(
                        //     Icons.arrow_back_rounded,
                        //     color: Color(0xFF3B3B8E),
                        //     size: 24,
                        //   ),
                        // ),
                        GestureDetector(
                          onTap: () {
                            if (context.canPop()) {
                              context.pop();
                            } else {
                              context.go(
                                RouteNames.home,
                              ); // или RouteNames.home
                            }
                          },
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            color: Color(0xFF3B3B8E),
                            size: 24,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // ── Логотип NOVA ─────────────────────────
                    _NovaLogo(),

                    const SizedBox(height: 28),

                    // ── Заголовок ────────────────────────────
                    const Text(
                      'Введите телефон или адрес\nэл.почты',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF2B2B8A),
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                        letterSpacing: -0.3,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── Переключатель ────────────────────────
                    _ModeToggle(
                      mode: _mode,
                      onChanged: (m) {
                        HapticFeedback.selectionClick();
                        setState(() {
                          _mode = m;
                          _error = null;
                        });
                        if (m == _InputMode.phone) {
                          _phoneFocus.requestFocus();
                        } else {
                          _emailFocus.requestFocus();
                        }
                      },
                    ),

                    const SizedBox(height: 24),

                    // ── Поле ввода ───────────────────────────
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      child: _mode == _InputMode.phone
                          ? _PhoneField(
                              key: const ValueKey('phone'),
                              controller: _phoneController,
                              focusNode: _phoneFocus,
                              onChanged: (_) => setState(() => _error = null),
                              onSubmitted: (_) => _proceed(),
                            )
                          : _EmailField(
                              key: const ValueKey('email'),
                              controller: _emailController,
                              focusNode: _emailFocus,
                              onChanged: (_) => setState(() => _error = null),
                              onSubmitted: (_) => _proceed(),
                            ),
                    ),

                    // ── Ошибка ───────────────────────────────
                    if (_error != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        _error!,
                        style: const TextStyle(
                          color: Color(0xFFD32F2F),
                          fontSize: 13,
                        ),
                      ),
                    ],

                    const SizedBox(height: 14),

                    // ── Политика конфиденциальности ──────────
                    GestureDetector(
                      onTap: () {
                        // TODO: открыть политику
                      },
                      child: const Text(
                        'Ознакомьтесь с нашей Политикой Конфиденциальности',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF3B3B8E),
                          fontSize: 13,
                          decoration: TextDecoration.underline,
                          decorationColor: Color(0xFF3B3B8E),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── Кнопка «Далее» ───────────────────────
                    _ProceedButton(
                      loading: _loading,
                      enabled: _canProceed,
                      onTap: _proceed,
                    ),
                    const SizedBox(height: 16),

                    // Разделитель
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(color: Color(0xFFDDDBEE)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'или',
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.4),
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Divider(color: Color(0xFFDDDBEE)),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    // const GoogleSignInButton(),

                    const SizedBox(height: 24),

                    // ── Уже есть аккаунт ─────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Уже есть аккаунт? ',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.45),
                            fontSize: 14,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.go(RouteNames.login),
                          child: const Text(
                            'Войти',
                            style: TextStyle(
                              color: Color(0xFF3B3B8E),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
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
// Логотип STICKY
// ─────────────────────────────────────────────

class _NovaLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/images/nova_logo.png', height: 48);
  }
}

// ─────────────────────────────────────────────
// Переключатель Телефон / Почта
// ─────────────────────────────────────────────

class _ModeToggle extends StatelessWidget {
  final _InputMode mode;
  final ValueChanged<_InputMode> onChanged;

  const _ModeToggle({required this.mode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFDDDBEE),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _ToggleTab(
            label: 'Телефон',
            selected: mode == _InputMode.phone,
            onTap: () => onChanged(_InputMode.phone),
          ),
          _ToggleTab(
            label: 'Электронная почта',
            selected: mode == _InputMode.email,
            onTap: () => onChanged(_InputMode.email),
          ),
        ],
      ),
    );
  }
}

class _ToggleTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ToggleTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(11),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: selected
                    ? const Color(0xFF2B2B8A)
                    : const Color(0xFF7B7BA8),
                fontSize: 13,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Поле телефона
// ─────────────────────────────────────────────

class _PhoneField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  const _PhoneField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Номер телефона',
          style: TextStyle(
            color: Color(0xFF2B2B8A),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFDDDBEE),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              // Префикс KZ +7
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 16,
                ),
                decoration: const BoxDecoration(
                  border: Border(
                    right: BorderSide(color: Color(0xFFBBB9D8), width: 1),
                  ),
                ),
                child: const Text(
                  'KZ +7',
                  style: TextStyle(
                    color: Color(0xFF2B2B8A),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  onChanged: onChanged,
                  onSubmitted: onSubmitted,
                  style: const TextStyle(
                    color: Color(0xFF1A1A1A),
                    fontSize: 15,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Номер телефона',
                    hintStyle: TextStyle(
                      color: Color(0xFF9E9CBB),
                      fontSize: 15,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Поле email
// ─────────────────────────────────────────────

class _EmailField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  const _EmailField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Электронная почта',
          style: TextStyle(
            color: Color(0xFF2B2B8A),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFDDDBEE),
            borderRadius: BorderRadius.circular(14),
          ),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            style: const TextStyle(color: Color(0xFF1A1A1A), fontSize: 15),
            decoration: const InputDecoration(
              hintText: 'Электронная почта',
              hintStyle: TextStyle(color: Color(0xFF9E9CBB), fontSize: 15),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Кнопка «Далее»
// ─────────────────────────────────────────────

class _ProceedButton extends StatefulWidget {
  final bool loading;
  final bool enabled;
  final VoidCallback onTap;

  const _ProceedButton({
    required this.loading,
    required this.enabled,
    required this.onTap,
  });

  @override
  State<_ProceedButton> createState() => _ProceedButtonState();
}

class _ProceedButtonState extends State<_ProceedButton> {
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
                    'Далее',
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
