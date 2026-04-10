import 'package:flutter/material.dart';

/// Палитра цветов приложения.
///
/// Все цвета определены здесь — в виджетах используем
/// только `AppColors.xxx`, никаких `Color(0xFF...)` в коде.

/// Цвета приложения Nova из Figma дизайна.
abstract final class AppColors {
  // ── Background ──────────────────────────────────────────────
  static const Color backgroundPrimary = Color(0xFF101010);
  static const Color backgroundSecondary = Color(0xFF2C2F36);
  static const Color backgroundSecondaryLight = Color(0xFF24262B);
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color backgroundGrey = Color(0xFF5D5D5D);
  static const Color backgroundGreyLight = Color(0xFFB3B3B3);

  // ── Button ──────────────────────────────────────────────────
  static const Color button = Color(0xFF35E7C7);
  static const Color buttonInactive = Color(0xFF2AA790);

  // ── Text ────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF000000);
  static const Color textActive = Color(0xFF050505);

  // ── Accent ──────────────────────────────────────────────────
  static const Color accentRed = Color(0xFFE01545);
  static const Color accentCrimson = Color(0xFFA8123B);
  static const Color accentBlue = Color(0xFF1DA1F2);
  static const Color accentCyan = Color(0xFF1DA1F2);

  // ── Inactive / Muted ───────────────────────────────────────
  static const Color inactiveGrey = Color(0xFFB7B7B7);
  static const Color inactiveLight = Color(0xFFBFE4DD);
}
