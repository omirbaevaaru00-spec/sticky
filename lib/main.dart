import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stiky/features/app/ui/app.dart';
import 'firebase_options.dart';

import 'core/router/app_router.dart';
import 'core/localization/locale_controller.dart';
import 'l10n/generated/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  await LocaleController.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return App(
      child: AnimatedBuilder(
        animation: LocaleController.instance,
        builder: (context, _) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: AppRouter.router,
      
            locale: LocaleController.instance.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
      
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF5B61F6),
                brightness: Brightness.light,
              ),
            ),
      
            darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF5B61F6),
                brightness: Brightness.dark,
              ),
              scaffoldBackgroundColor: Colors.transparent,
            ),
      
            themeMode: ThemeMode.light,
          );
        },
      ),
    );
  }
}
