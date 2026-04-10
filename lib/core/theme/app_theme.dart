import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

/// Тема приложения (пока только светлая).
///
/// [ThemeData] собирает в себе цвета, стили текста,
/// настройки AppBar, кнопок и прочих компонентов.
/// Чтобы добавить тёмную тему — создайте аналогичный метод `dark()`.

class AppTheme {
  /// Светлая тема.
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,

      // ── Цветовая схема ───────────────────────────────────────
      colorScheme: const ColorScheme.dark(
        primary: AppColors.button,
        onPrimary: AppColors.backgroundPrimary,
        secondary: AppColors.backgroundSecondary,
        onSecondary: AppColors.textPrimary,
        surface: AppColors.backgroundSecondaryLight,
        onSurface: AppColors.backgroundWhite,
        error: AppColors.accentRed,
        onError: AppColors.backgroundWhite,
      ),

      scaffoldBackgroundColor: AppColors.backgroundPrimary,

      // ── AppBar ───────────────────────────────────────────────
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundPrimary,
        foregroundColor: AppColors.backgroundWhite,
        centerTitle: true,
        elevation: 0,
      ),

      // ── Кнопки ───────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.button,
          foregroundColor: AppColors.backgroundPrimary,
          disabledBackgroundColor: AppColors.buttonInactive,
          disabledForegroundColor: AppColors.backgroundPrimary,
          textStyle: AppTextStyles.button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      // ── Текстовая тема ───────────────────────────────────────
      textTheme: const TextTheme(
        headlineLarge: AppTextStyles.headlineLarge,
        headlineMedium: AppTextStyles.headlineMedium,
        bodyLarge: AppTextStyles.bodyLarge,
        bodySmall: AppTextStyles.bodySmall,
        labelSmall: AppTextStyles.label,
      ),

      // ── Навигация ────────────────────────────────────────────
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.backgroundSecondary,
        selectedItemColor: AppColors.button,
        unselectedItemColor: AppColors.inactiveGrey,
        showUnselectedLabels: true,
      ),

      dividerColor: AppColors.backgroundGrey,
    );
  }
}
