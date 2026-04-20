// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// import '../../features/auth/screens/welcome_screen.dart';
// import '../../features/auth/screens/interest_quiz_screen.dart';
// import '../../features/auth/screens/login_screen.dart';
// import '../../features/auth/screens/register_screen.dart';
// import '../../features/auth/screens/forgot_password_screen.dart';
// import '../../features/home/screens/main_navigation_screen.dart';
// import '../../features/home/screens/home_screen.dart';
// import '../../features/home/screens/search_screen.dart';
// // import '../../features/home/screens/filters_screen.dart';
// import '../../features/home/screens/favorites_screen.dart';
// import '../../features/home/screens/saved_searches_screen.dart';
// import '../../features/home/screens/news_feed_screen.dart';
// import '../../features/home/screens/notifications_screen.dart';
// import '../../features/profile/screens/profile_screen.dart';
// import '../../features/profile/screens/profile_entry_screen.dart';
// import '../../features/university/screens/university_detail_screen.dart';
// import '../../features/splash/ui/splash_page.dart';
// import '../../features/profile/screens/profile_settings_screen.dart';
// import 'route_names.dart';

// class AppRouter {
//   AppRouter._();

//   static final GoRouter router = GoRouter(
//     // Сплэш всегда первый — он сам решает куда идти
//     initialLocation: RouteNames.splash,

//     routes: [
//       // ── Сплэш ─────────────────────────────────────────────
//       GoRoute(
//         path: RouteNames.splash,
//         builder: (context, state) => const SplashPage(),
//       ),

//       // ── Онбординг (только Welcome + Quiz) ─────────────────
//       // Язык выбирается прямо на WelcomeScreen
//       GoRoute(
//         path: RouteNames.welcome,
//         builder: (context, state) => const WelcomeScreen(),
//       ),
//       GoRoute(
//         path: RouteNames.interestQuiz,
//         builder: (context, state) => const InterestQuizScreen(),
//       ),

//       // ── Авторизация (по требованию, не обязательно) ────────
//       GoRoute(
//         path: RouteNames.login,
//         builder: (context, state) => const LoginScreen(),
//       ),
//       GoRoute(
//         path: RouteNames.register,
//         builder: (context, state) => const RegisterScreen(),
//       ),
//       GoRoute(
//         path: RouteNames.forgotPassword,
//         builder: (context, state) => const ForgotPasswordScreen(),
//       ),

//       // ── Основная оболочка с BottomNav ──────────────────────
//       ShellRoute(
//         builder: (context, state, child) => MainNavigationScreen(child: child),
//         routes: [
//           GoRoute(
//             path: RouteNames.home,
//             builder: (context, state) => const HomeScreen(),
//           ),
//           GoRoute(
//             path: RouteNames.notifications,
//             builder: (context, state) => const NotificationsScreen(),
//           ),
//           GoRoute(
//             path: RouteNames.profile,
//             builder: (context, state) => const ProfileScreen(),
//           ),
//         ],
//       ),

//       // ── Детальные экраны ───────────────────────────────────
//       GoRoute(
//         path: '/university/:id',
//         builder: (context, state) {
//           final id = state.pathParameters['id'] ?? '';
//           return UniversityDetailScreen(id: id);
//         },
//       ),
//       // GoRoute(
//       //   path: RouteNames.filters,
//       //   builder: (context, state) => const FiltersScreen(),
//       // ),
//       GoRoute(
//         path: RouteNames.favorites,
//         builder: (context, state) => const FavoritesScreen(),
//       ),
//       GoRoute(
//         path: RouteNames.savedSearches,
//         builder: (context, state) => const SavedSearchesScreen(),
//       ),
//       GoRoute(
//         path: RouteNames.newsFeed,
//         builder: (context, state) => const NewsFeedScreen(),
//       ),
//       GoRoute(
//         path: RouteNames.helpCenter,
//         builder: (context, state) => const ProfileEntryScreen(),
//       ),
//       GoRoute(
//         path: RouteNames.search,
//         builder: (context, state) => const SearchScreen(),
//       ),
//       GoRoute(
//         path: '/profile',
//         name: 'profile',
//         builder: (context, state) => const ProfileEntryScreen(),
//       ),

//       GoRoute(
//         path: '/profile-settings',
//         name: 'profile-settings',
//         builder: (context, state) => const SettingsScreen(),
//       ),
//     ],

//     errorBuilder: (context, state) => Scaffold(
//       body: Center(
//         child: Text(
//           'Страница не найдена: ${state.uri}',
//           style: Theme.of(context).textTheme.bodyLarge,
//         ),
//       ),
//     ),
//   );
// }

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/screens/welcome_screen.dart';
import '../../features/auth/screens/interest_quiz_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/home/screens/main_navigation_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/home/screens/search_screen.dart';
import '../../features/home/screens/favorites_screen.dart';
import '../../features/home/screens/saved_searches_screen.dart';
import '../../features/home/screens/news_feed_screen.dart';
import '../../features/home/screens/notifications_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/profile/screens/profile_entry_screen.dart';
import '../../features/university/screens/university_detail_screen.dart';
import '../../features/splash/ui/splash_page.dart';
import '../../features/profile/screens/profile_settings_screen.dart'; // <- класс SettingsScreen
import '../../features/auth/screens/profile_setup_screen.dart';
import 'route_names.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.splash,

    routes: [
      // ── Сплэш ─────────────────────────────────────────────
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const SplashPage(),
      ),

      // ── Онбординг ─────────────────────────────────────────
      GoRoute(
        path: RouteNames.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: RouteNames.interestQuiz,
        builder: (context, state) => const InterestQuizScreen(),
      ),

      // ── Авторизация ────────────────────────────────────────
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: RouteNames.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      GoRoute(
        path: RouteNames.profileSetup,
        builder: (context, state) => const ProfileSetupScreen(),
      ),

      // ── Основная оболочка с BottomNav ──────────────────────
      ShellRoute(
        builder: (context, state, child) => MainNavigationScreen(child: child),
        routes: [
          GoRoute(
            path: RouteNames.home,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: RouteNames.notifications,
            builder: (context, state) => const NotificationsScreen(),
          ),
          GoRoute(
            path: RouteNames.profile,
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),

      // ── Детальные экраны (без навбара) ────────────────────
      GoRoute(
        path: '/university/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return UniversityDetailScreen(id: id);
        },
      ),
      GoRoute(
        path: RouteNames.favorites,
        builder: (context, state) => const FavoritesScreen(),
      ),
      GoRoute(
        path: RouteNames.savedSearches,
        builder: (context, state) => const SavedSearchesScreen(),
      ),
      GoRoute(
        path: RouteNames.newsFeed,
        builder: (context, state) => const NewsFeedScreen(),
      ),
      GoRoute(
        path: RouteNames.helpCenter,
        builder: (context, state) => const ProfileEntryScreen(),
      ),
      GoRoute(
        path: RouteNames.search,
        builder: (context, state) => const SearchScreen(),
      ),

      // ── Настройки профиля (без навбара) ───────────────────
      GoRoute(
        path: '/profile-settings',
        name: 'profile-settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],

    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text(
          'Страница не найдена: ${state.uri}',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    ),
  );
}
