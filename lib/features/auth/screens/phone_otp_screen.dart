import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_names.dart';

class PhoneOtpScreen extends StatefulWidget {
  const PhoneOtpScreen({super.key});

  @override
  State<PhoneOtpScreen> createState() => _PhoneOtpScreenState();
}

class _PhoneOtpScreenState extends State<PhoneOtpScreen>
    with SingleTickerProviderStateMixin {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  String? _verificationId;
  String? _phone;
  bool _loading = false;
  bool _sending = true;
  String? _error;
  int _resendSeconds = 60;

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final extra = GoRouterState.of(context).extra;
      if (extra is Map) {
        _phone = extra['phone'] as String?;
        _verificationId = extra['verificationId'] as String?;
      }
      setState(() => _sending = false);
      _startResendTimer();
    });
  }

  void _startResendTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      if (_resendSeconds > 0) {
        setState(() => _resendSeconds--);
        _startResendTimer();
      }
    });
  }

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    _animController.dispose();
    super.dispose();
  }

  String get _otpCode =>
      _controllers.map((c) => c.text).join();

  bool get _canVerify => _otpCode.length == 6;

  Future<void> _verify() async {
    if (!_canVerify || _loading || _verificationId == null) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _error = null;
      _loading = true;
    });
    HapticFeedback.lightImpact();

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: _otpCode,
      );

      final userCred =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCred.user;

      if (!mounted) return;
      if (user == null) {
        setState(() => _error = 'Ошибка. Попробуй снова.');
        return;
      }

      // Проверяем есть ли профиль
      // Переходим на profile_setup с phone
      context.go(
        RouteNames.profileSetup,
        extra: {'phone': _phone ?? ''},
      );
    } on FirebaseAuthException catch (e) {
      setState(() => _error = _firebaseMessage(e.code));
    } catch (_) {
      setState(() => _error = 'Что-то пошло не так. Попробуй снова.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _resend() async {
    if (_resendSeconds > 0 || _phone == null) return;
    setState(() {
      _resendSeconds = 60;
      _error = null;
      _sending = true;
    });

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: _phone!,
      verificationCompleted: (credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
        if (mounted) context.go(RouteNames.profileSetup,
            extra: {'phone': _phone ?? ''});
      },
      verificationFailed: (e) {
        if (mounted) setState(() => _error = _firebaseMessage(e.code));
      },
      codeSent: (verificationId, _) {
        if (mounted) {
          setState(() {
            _verificationId = verificationId;
            _sending = false;
          });
          _startResendTimer();
        }
      },
      codeAutoRetrievalTimeout: (_) {},
    );
  }

  String _firebaseMessage(String code) {
    switch (code) {
      case 'invalid-verification-code':
        return 'Неверный код. Проверь SMS.';
      case 'session-expired':
        return 'Код устарел. Запроси новый.';
      case 'too-many-requests':
        return 'Слишком много попыток. Подожди.';
      default:
        return 'Ошибка. Попробуй снова.';
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

                    const SizedBox(height: 40),

                    // ── Иконка ───────────────────────────────
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: Color(0xFFDDDBEE),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.sms_rounded,
                        color: Color(0xFF3B3B8E),
                        size: 40,
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      'Введи код из SMS',
                      style: TextStyle(
                        color: Color(0xFF2B2B8A),
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Мы отправили 6-значный код на\n${_phone ?? ''}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.45),
                        fontSize: 15,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // ── 6 ячеек кода ─────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(6, (i) {
                        return Container(
                          width: 48,
                          height: 56,
                          margin: EdgeInsets.only(right: i < 5 ? 8 : 0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: _focusNodes[i].hasFocus
                                  ? const Color(0xFF2B2B8A)
                                  : const Color(0xFFDDDBEE),
                              width: 1.5,
                            ),
                          ),
                          child: TextField(
                            controller: _controllers[i],
                            focusNode: _focusNodes[i],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2B2B8A),
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              counterText: '',
                              contentPadding: EdgeInsets.zero,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: (val) {
                              if (val.isNotEmpty && i < 5) {
                                _focusNodes[i + 1].requestFocus();
                              } else if (val.isEmpty && i > 0) {
                                _focusNodes[i - 1].requestFocus();
                              }
                              setState(() {});
                              if (_canVerify) _verify();
                            },
                          ),
                        );
                      }),
                    ),

                    // ── Ошибка ───────────────────────────────
                    if (_error != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        _error!,
                        style: const TextStyle(
                          color: Color(0xFFD32F2F),
                          fontSize: 13,
                        ),
                      ),
                    ],

                    const SizedBox(height: 32),

                    // ── Кнопка подтвердить ───────────────────
                    _sending
                        ? const CircularProgressIndicator(
                            color: Color(0xFF2B2B8A))
                        : _VerifyButton(
                            loading: _loading,
                            enabled: _canVerify,
                            onTap: _verify,
                          ),

                    const SizedBox(height: 24),

                    // ── Повторная отправка ────────────────────
                    GestureDetector(
                      onTap: _resendSeconds == 0 ? _resend : null,
                      child: Text(
                        _resendSeconds > 0
                            ? 'Отправить повторно через ${_resendSeconds}с'
                            : 'Отправить код повторно',
                        style: TextStyle(
                          color: _resendSeconds == 0
                              ? const Color(0xFF3B3B8E)
                              : Colors.black.withOpacity(0.4),
                          fontSize: 14,
                          fontWeight: _resendSeconds == 0
                              ? FontWeight.w600
                              : FontWeight.w400,
                          decoration: _resendSeconds == 0
                              ? TextDecoration.underline
                              : null,
                        ),
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

// ─── Кнопка подтвердить ──────────────────────────────────────
class _VerifyButton extends StatefulWidget {
  final bool loading;
  final bool enabled;
  final VoidCallback onTap;

  const _VerifyButton({
    required this.loading,
    required this.enabled,
    required this.onTap,
  });

  @override
  State<_VerifyButton> createState() => _VerifyButtonState();
}

class _VerifyButtonState extends State<_VerifyButton> {
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
                    'Подтвердить',
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