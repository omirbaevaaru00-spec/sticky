import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
 
import '../../../core/router/route_names.dart';
 
class InterestQuizScreen extends StatefulWidget {
  const InterestQuizScreen({super.key});
 
  @override
  State<InterestQuizScreen> createState() => _InterestQuizScreenState();
}
 
class _InterestQuizScreenState extends State<InterestQuizScreen> {
  static const _interests = [
    ('IT и технологии',     '💻'),
    ('Медицина',            '🩺'),
    ('Бизнес и экономика',  '📊'),
    ('Гранты',              '🎓'),
    ('Дизайн и креатив',    '🎨'),
    ('Юриспруденция',       '⚖️'),
    ('Педагогика',          '📚'),
    ('Инженерия',           '⚙️'),
    ('Бакалавриат',         '🏫'),
    ('Колледж',             '🏢'),
    ('Магистратура',        '🎯'),
  ];
 
  final Set<String> _selected = {};
 
  void _toggle(String interest) {
    HapticFeedback.selectionClick();
    setState(() {
      _selected.contains(interest)
          ? _selected.remove(interest)
          : _selected.add(interest);
    });
  }
 
  /// Rule-based: сохраняем выбранные интересы и переходим на главную.
  /// Если пропустили — пустой список, лента показывает всё подряд.
  void _proceed() {
    HapticFeedback.lightImpact();
    // TODO: сохранить _selected в UserRepository / SharedPreferences
    context.go(RouteNames.home);
  }
 
  void _skip() {
    HapticFeedback.selectionClick();
    // Пропуск — рекомендации по умолчанию (все направления)
    context.go(RouteNames.home);
  }
 
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF3B4FD8),
                Color(0xFF2F3FBF),
                Color(0xFF1E2D8A),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Верхняя часть ──────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Назад
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
 
                      const SizedBox(height: 28),
 
                      // Заголовок
                      const Text(
                        'Выбери, что тебе\nинтересно',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          height: 1.15,
                          letterSpacing: -0.5,
                        ),
                      ),
 
                      const SizedBox(height: 10),
 
                      // Подзаголовок
                      Text(
                        'Мы настроим ленту под твои цели, интересы\nи планы на будущее',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.65),
                          fontSize: 14,
                          height: 1.45,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
 
                      const SizedBox(height: 28),
                    ],
                  ),
                ),
 
                // ── Чипы интересов ─────────────────────────────
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _interests.map((item) {
                        final label = item.$1;
                        final isSelected = _selected.contains(label);
                        return _InterestChip(
                          label: label,
                          isSelected: isSelected,
                          onTap: () => _toggle(label),
                        );
                      }).toList(),
                    ),
                  ),
                ),
 
                // ── Счётчик выбранных ──────────────────────────
                if (_selected.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Center(
                      child: Text(
                        'Выбрано: ${_selected.length}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
 
                // ── Кнопки внизу ───────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                  child: Row(
                    children: [
                      // Пропустить
                      Expanded(
                        child: _BottomButton(
                          label: 'Пропустить',
                          color: Colors.white.withOpacity(0.15),
                          textColor: Colors.white,
                          onTap: _skip,
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Далее
                      Expanded(
                        child: _BottomButton(
                          label: 'Далее',
                          color: const Color(0xFF2ECC9A),
                          textColor: Colors.white,
                          onTap: _proceed,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
 
// ─────────────────────────────────────────────
// Чип интереса
// ─────────────────────────────────────────────
 
class _InterestChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
 
  const _InterestChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });
 
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF2ECC9A)
              : Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF2ECC9A)
                : Colors.white.withOpacity(0.18),
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.85),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
 
// ─────────────────────────────────────────────
// Нижняя кнопка
// ─────────────────────────────────────────────
 
class _BottomButton extends StatefulWidget {
  final String label;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;
 
  const _BottomButton({
    required this.label,
    required this.color,
    required this.textColor,
    required this.onTap,
  });
 
  @override
  State<_BottomButton> createState() => _BottomButtonState();
}
 
class _BottomButtonState extends State<_BottomButton> {
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
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Center(
            child: Text(
              widget.label,
              style: TextStyle(
                color: widget.textColor,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}