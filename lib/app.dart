import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moodly/core/providers/theme_provider.dart';
import 'package:moodly/core/router/app_router.dart';
import 'package:moodly/core/theme/app_theme.dart';

class MoodlyApp extends ConsumerWidget {
  const MoodlyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp.router(
      title: 'Moodly',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
    );
  }
}
