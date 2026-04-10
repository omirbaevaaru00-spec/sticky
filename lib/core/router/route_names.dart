/// Константы маршрутов NOVA.
class RouteNames {
  RouteNames._();

  // ── Сплэш ─────────────────────────────────────────────────
  static const String splash            = '/';

  // ── Онбординг (язык выбирается на WelcomeScreen) ──────────
  static const String welcome           = '/welcome';
  static const String interestQuiz      = '/interest-quiz';

  // ── Авторизация (по требованию) ───────────────────────────
  static const String login             = '/login';
  static const String register          = '/register';
  static const String forgotPassword    = '/forgot-password';
  static const String profileSetup      = '/profile-setup';

  // ── Основные экраны ───────────────────────────────────────
  static const String home              = '/main/home';
  static const String notifications     = '/main/notifications';
  static const String profile           = '/main/profile';

  // ── Детальные экраны ──────────────────────────────────────
  static const String search            = '/search';
  static const String filters           = '/filters';
  static const String favorites         = '/favorites';
  static const String savedSearches     = '/saved-searches';
  static const String newsFeed          = '/news';
  static const String helpCenter        = '/help-center';
}