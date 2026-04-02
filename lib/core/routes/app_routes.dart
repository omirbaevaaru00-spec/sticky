import 'package:go_router/go_router.dart';

import '../../features/auth/screens/welcome_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/auth/screens/language_selection_screen.dart';
import '../../features/auth/screens/interest_quiz_screen.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/auth/screens/profile_setup_screen.dart';
import '../../features/home/screens/main_navigation_screen.dart';
import '../../features/home/screens/favorites_screen.dart';
import '../../features/home/screens/saved_searches_screen.dart';
import '../../features/home/screens/news_feed_screen.dart';
import '../../features/home/screens/notifications_screen.dart';
import '../../features/profile/screens/help_center_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/language',
        builder: (context, state) => const LanguageSelectionScreen(),
      ),
      GoRoute(
        path: '/quiz',
        builder: (context, state) => const InterestQuizScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/profile-setup',
        builder: (context, state) => const ProfileSetupScreen(),
      ),
      GoRoute(
        path: '/main',
        builder: (context, state) => const MainNavigationScreen(),
      ),
      GoRoute(
        path: '/favorites',
        builder: (context, state) => const FavoritesScreen(),
      ),
      GoRoute(
        path: '/saved-searches',
        builder: (context, state) => const SavedSearchesScreen(),
      ),
      GoRoute(
        path: '/news',
        builder: (context, state) => const NewsFeedScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/help-center',
        builder: (context, state) => const HelpCenterScreen(),
      ),
    ],
  );
}