import 'package:aashwaas/app/theme/theme_data.dart';
import 'package:aashwaas/core/providers/theme_mode_provider.dart';
import 'package:aashwaas/features/splash/presentation/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: getApplicationTheme(),
      darkTheme: getDarkTheme(),
      themeMode: themeMode,
      home: const SplashScreen(),
    );
  }
}
