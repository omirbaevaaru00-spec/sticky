import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:stiky/features/auth/screens/interest_quiz_screen.dart';

import '../../../core/localization/locale_controller.dart';
import '../../../core/router/route_names.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _currentLocale => LocaleController.instance.locale.languageCode;

  void _switchLocale() {
    HapticFeedback.selectionClick();
    final next = _currentLocale == 'ru' ? 'kk' : 'ru';
    LocaleController.instance.setLocale(Locale(next));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isRu = _currentLocale == 'ru';

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF4C6EF5),
                Color(0xFF3B5BDB),
                Color(0xFF2F4AC7),
              ],
            ),
          ),
          child: SafeArea(
            child: FadeTransition(
              opacity: _fadeIn,
              child: Stack(
                children: [
                  // ── Переключатель языка (правый угол) ──────
                  Positioned(
                    top: 12,
                    right: 16,
                    child: _LocaleSwitcher(
                      current: _currentLocale,
                      onSwitch: _switchLocale,
                    ),
                  ),

                  // ── Центральный контент ─────────────────────
                  Positioned.fill(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),

                        // WELCOME
                        Text(
                          'WELCOME',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 46,
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.italic,
                            letterSpacing: -1.0,
                            height: 1.0,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Описание
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            child: Text(
                              isRu
                                  ? 'Удобный сервис для абитуриентов —\nсравнивай вузы, узнавай проходные\nбаллы, выбирай специальность\nи подавай документы в один клик.'
                                  : 'Түлектерге арналған ыңғайлы қызмет —\nуниверситеттерді салыстырып, өту\nбалдарын біліп, мамандық таңда\nжәне құжаттарды бір рет басып тапсыр.',
                              key: ValueKey('desc_$_currentLocale'),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.85),
                                fontSize: 15,
                                height: 1.55,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Кнопка «Пропустить» ─────────────────────
                  Positioned(
                    bottom: 48,
                    left: 28,
                    right: 28,
                    child: _SkipButton(
                      label: isRu ? 'Пропустить' : 'Өткізіп жіберу',
                      onTap: () {
                        HapticFeedback.lightImpact();
                        context.go(RouteNames.interestQuiz);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Переключатель языка
// ─────────────────────────────────────────────

class _LocaleSwitcher extends StatelessWidget {
  final String current;
  final VoidCallback onSwitch;

  const _LocaleSwitcher({required this.current, required this.onSwitch});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSwitch,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomPaint(
              size: const Size(16, 16),
              painter: _GlobePainter(color: Colors.white),
            ),
            const SizedBox(width: 6),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Text(
                current == 'ru' ? 'РУ' : 'ҚАЗ',
                key: ValueKey(current),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Кнопка «Пропустить»
// ─────────────────────────────────────────────

class _SkipButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _SkipButton({required this.label, required this.onTap});

  @override
  State<_SkipButton> createState() => _SkipButtonState();
}

class _SkipButtonState extends State<_SkipButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          height: 54,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.25),
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              widget.label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// CustomPainter — иконка глобуса
// ─────────────────────────────────────────────

class _GlobePainter extends CustomPainter {
  final Color color;
  const _GlobePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3
      ..strokeCap = StrokeCap.round;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2 - 0.5;

    canvas.drawCircle(Offset(cx, cy), r, paint);
    canvas.drawLine(Offset(1, cy), Offset(size.width - 1, cy), paint);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx, cy),
        width: size.width * 0.5,
        height: size.height - 1,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(_GlobePainter old) => old.color != color;
}
