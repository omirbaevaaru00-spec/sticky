import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/locale_controller.dart';
import '../../../core/router/route_names.dart';
import '../../../widgets/university_card.dart';
import '../../../widgets/university_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<University> _universities = List.from(kazakhUniversities);

  String get _locale => LocaleController.instance.locale.languageCode;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: SafeArea(
          child: Column(
            children: [
              // ── App Bar ───────────────────────────────────
              _AppBar(),

              const Divider(height: 1, color: Color(0xFFEEEEEE)),

              // ── Лента вузов ───────────────────────────────
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 24),
                  itemCount: _universities.length,
                  itemBuilder: (context, index) {
                    final uni = _universities[index];
                    return UniversityFeedCard(
                      university: uni,
                      onTap: () {
                        context.push(
                          '/university/${uni.id}',
                          extra: uni,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// App Bar
// ─────────────────────────────────────────────

class _AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF3B3B8E),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // Пустое место слева для баланса
          const SizedBox(width: 40),

          // Логотип по центру
          Expanded(
            child: Center(
              child: Image.asset(
                'assets/images/nova_logo.png',
                height: 32,
                fit: BoxFit.contain,
                // Делаем логотип белым через colorFilter
                color: Colors.white,
                colorBlendMode: BlendMode.srcIn,
              ),
            ),
          ),

          // Поиск справа
          GestureDetector(
            onTap: () => context.push(RouteNames.search),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.search_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}