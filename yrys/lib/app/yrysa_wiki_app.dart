// made by Yrysa
import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';
import '../core/storage/local_storage.dart';
import '../core/theme/app_theme.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/splash/splash_screen.dart';
import 'main_navigation.dart';
import 'wiki_app_state.dart';
import 'wiki_state_scope.dart';

class YrysaWikiApp extends StatefulWidget {
  const YrysaWikiApp({super.key});

  @override
  State<YrysaWikiApp> createState() => _YrysaWikiAppState();
}

class _YrysaWikiAppState extends State<YrysaWikiApp> {
  WikiAppState? _state;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final storage = await LocalStorage.create();
    final state = WikiAppState(storage: storage);
    setState(() => _state = state);
    await state.initialize();
  }

  @override
  Widget build(BuildContext context) {
    final state = _state;

    if (state == null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppConstants.appName,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        home: const SplashScreen(),
      );
    }

    return WikiStateScope(
      state: state,
      child: AnimatedBuilder(
        animation: state,
        builder: (context, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: AppConstants.appName,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: state.themeMode,
            home: AnimatedSwitcher(
              duration: const Duration(milliseconds: 420),
              child: !state.initialized
                  ? const SplashScreen(key: ValueKey('splash'))
                  : !state.onboardingCompleted
                      ? const OnboardingScreen(key: ValueKey('onboarding'))
                      : const MainNavigation(key: ValueKey('main')),
            ),
          );
        },
      ),
    );
  }
}
