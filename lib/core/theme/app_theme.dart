import 'package:flutter/material.dart';
import 'package:moodly/core/constants/app_colors.dart';
import 'package:moodly/core/constants/app_typography.dart';

// Transición de fade suave — elimina el parpadeo negro entre rutas
class _FadeTransitionBuilder extends PageTransitionsBuilder {
  const _FadeTransitionBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: Curves.easeIn),
      child: child,
    );
  }
}

const _fadeTransitions = PageTransitionsTheme(
  builders: <TargetPlatform, PageTransitionsBuilder>{
    TargetPlatform.android: _FadeTransitionBuilder(),
    TargetPlatform.iOS: _FadeTransitionBuilder(),
    TargetPlatform.macOS: _FadeTransitionBuilder(),
    TargetPlatform.linux: _FadeTransitionBuilder(),
    TargetPlatform.windows: _FadeTransitionBuilder(),
    TargetPlatform.fuchsia: _FadeTransitionBuilder(),
  },
);

class AppTheme {
  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    textTheme: AppTypography.lightTextTheme,
    pageTransitionsTheme: _fadeTransitions,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.bien,
      surface: AppColors.background,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: AppColors.textPrimary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide:
            const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide:
            const BorderSide(color: AppColors.primary, width: 2),
      ),
      hintStyle: const TextStyle(color: Color(0xFFBBBBBB)),
      labelStyle: const TextStyle(color: Color(0xFF888888)),
    ),
  );

  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryDark,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    textTheme: AppTypography.darkTextTheme,
    pageTransitionsTheme: _fadeTransitions,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryDark,
      secondary: AppColors.bien,
      surface: AppColors.backgroundDark,
      onPrimary: Colors.black,
      onSecondary: Colors.white,
      onSurface: AppColors.textPrimaryDark,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.black,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    // ── TextFields oscuros translúcidos con borde neón al tener foco ──────────
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1E1E2E),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF2A2A3E)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF2A2A3E)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: AppColors.primaryDark.withValues(alpha: 0.85),
          width: 2,
        ),
      ),
      hintStyle: const TextStyle(color: Color(0xFF555566)),
      labelStyle: const TextStyle(color: Color(0xFF9E9E9E)),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.primaryDark,
      selectionColor: AppColors.primaryDark.withValues(alpha: 0.35),
      selectionHandleColor: AppColors.primaryDark,
    ),
  );
}
