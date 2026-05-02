

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/router/route_names.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen>
    with SingleTickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _cityController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameFocus = FocusNode();
  final _cityFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _loading = false;
  bool _obscurePassword = true;
  String? _error;

  late final AnimationController _animController;
  late final Animation<double> _fadeIn;

  String? _email;
  String? _phone;
  bool _isEmailFlow = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeIn = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final extra = GoRouterState.of(context).extra;
      if (extra is Map) {
        _email = extra['email'] as String?;
        _phone = extra['phone'] as String?;
      }

      final user = FirebaseAuth.instance.currentUser;
      if (user == null && _email != null) {
        setState(() => _isEmailFlow = true);
      }

      if (user?.displayName != null && user!.displayName!.isNotEmpty) {
        _nameController.text = user.displayName!;
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    _passwordController.dispose();
    _nameFocus.dispose();
    _cityFocus.dispose();
    _passwordFocus.dispose();
    _animController.dispose();
    super.dispose();
  }

  bool get _canContinue {
    final base = _nameController.text.trim().isNotEmpty &&
        _cityController.text.trim().isNotEmpty;
    if (_isEmailFlow) {
      return base && _passwordController.text.length >= 6;
    }
    return base;
  }

  Future<void> _continue() async {
    if (!_canContinue || _loading) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _error = null;
      _loading = true;
    });
    HapticFeedback.lightImpact();

    try {
      final name = _nameController.text.trim();
      final city = _cityController.text.trim();

      User? user = FirebaseAuth.instance.currentUser;

      // ── Email регистрация ──────────────────────────────
      if (_isEmailFlow && _email != null) {
        try {
          final cred = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
            email: _email!,
            password: _passwordController.text,
          );
          user = cred.user;
        } on FirebaseAuthException catch (e) {
          setState(() => _error = _firebaseMessage(e.code));
          return;
        }
      }

      if (user == null) {
        setState(() => _error = 'Ошибка авторизации. Попробуй снова.');
        return;
      }

      await user.updateDisplayName(name);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
        'uid': user.uid,
        'name': name,
        'city': city,
        'email': user.email ?? _email ?? '',
        'phone': _phone ?? '',
        'photoUrl': user.photoURL ?? '',
        'gpa': null,
        'ielts': null,
        'ent': null,
        'favorites': [],
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('already_onboarded', true);

      if (mounted) context.go(RouteNames.home);
    } catch (e) {
      setState(() => _error = 'Что-то пошло не так. Попробуй ещё раз.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _firebaseMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Этот email уже зарегистрирован. Войди через «Войти».';
      case 'weak-password':
        return 'Пароль слишком простой. Минимум 6 символов.';
      case 'invalid-email':
        return 'Неверный формат email.';
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

                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (context.canPop()) context.pop();
                          },
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            color: Color(0xFF3B3B8E),
                            size: 24,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: Color(0xFFDDDBEE),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        color: Color(0xFF3B3B8E),
                        size: 44,
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      'Расскажи о себе',
                      style: TextStyle(
                        color: Color(0xFF2B2B8A),
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Заполни профиль — это займёт\nменьше минуты',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.45),
                        fontSize: 15,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // ── Имя ──────────────────────────────────
                    _buildLabel('Имя / Никнейм'),
                    const SizedBox(height: 8),
                    _InputField(
                      controller: _nameController,
                      focusNode: _nameFocus,
                      hint: 'Например: Арууке',
                      textInputAction: TextInputAction.next,
                      onChanged: (_) => setState(() {}),
                      onSubmitted: (_) => _cityFocus.requestFocus(),
                    ),

                    const SizedBox(height: 20),

                    // ── Город ────────────────────────────────
                    _buildLabel('Город'),
                    const SizedBox(height: 8),
                    _InputField(
                      controller: _cityController,
                      focusNode: _cityFocus,
                      hint: 'Например: Алматы',
                      textInputAction: _isEmailFlow
                          ? TextInputAction.next
                          : TextInputAction.done,
                      onChanged: (_) => setState(() {}),
                      onSubmitted: (_) {
                        if (_isEmailFlow) {
                          _passwordFocus.requestFocus();
                        } else {
                          _continue();
                        }
                      },
                    ),

                    // ── Пароль (только email flow) ────────────
                    if (_isEmailFlow) ...[
                      const SizedBox(height: 20),
                      _buildLabel('Придумай пароль'),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: const Color(0xFFDDDBEE), width: 1.5),
                        ),
                        child: TextField(
                          controller: _passwordController,
                          focusNode: _passwordFocus,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.done,
                          onChanged: (_) => setState(() {}),
                          onSubmitted: (_) => _continue(),
                          style: const TextStyle(
                              color: Color(0xFF1A1A1A), fontSize: 15),
                          decoration: InputDecoration(
                            hintText: 'Минимум 6 символов',
                            hintStyle: const TextStyle(
                                color: Color(0xFF9E9CBB), fontSize: 15),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            suffixIcon: GestureDetector(
                              onTap: () => setState(() =>
                                  _obscurePassword = !_obscurePassword),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 14),
                                child: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: const Color(0xFF9E9CBB),
                                  size: 20,
                                ),
                              ),
                            ),
                            suffixIconConstraints: const BoxConstraints(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Минимум 6 символов',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black.withOpacity(0.4),
                          ),
                        ),
                      ),
                    ],

                    // ── Ошибка ───────────────────────────────
                    if (_error != null) ...[
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _error!,
                          style: const TextStyle(
                            color: Color(0xFFD32F2F),
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 40),

                    // ── Кнопка ───────────────────────────────
                    _ContinueButton(
                      loading: _loading,
                      enabled: _canContinue,
                      onTap: _continue,
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

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF2B2B8A),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ─── Поле ввода ──────────────────────────────────────────────
class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final TextInputAction textInputAction;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  const _InputField({
    required this.controller,
    required this.focusNode,
    required this.hint,
    required this.textInputAction,
    required this.onChanged,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFDDDBEE), width: 1.5),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textInputAction: textInputAction,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        style: const TextStyle(color: Color(0xFF1A1A1A), fontSize: 15),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle:
              const TextStyle(color: Color(0xFF9E9CBB), fontSize: 15),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}

// ─── Кнопка «Продолжить» ─────────────────────────────────────
class _ContinueButton extends StatefulWidget {
  final bool loading;
  final bool enabled;
  final VoidCallback onTap;

  const _ContinueButton({
    required this.loading,
    required this.enabled,
    required this.onTap,
  });

  @override
  State<_ContinueButton> createState() => _ContinueButtonState();
}

class _ContinueButtonState extends State<_ContinueButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown:
          widget.enabled ? (_) => setState(() => _pressed = true) : null,
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
                    'Продолжить',
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