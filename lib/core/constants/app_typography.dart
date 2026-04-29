import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  static TextTheme lightTextTheme = TextTheme(
    displayLarge: GoogleFonts.syne(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: const Color(0xFF333333),
    ),
    displayMedium: GoogleFonts.syne(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: const Color(0xFF333333),
    ),
    displaySmall: GoogleFonts.syne(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: const Color(0xFF333333),
    ),
    headlineLarge: GoogleFonts.syne(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: const Color(0xFF333333),
    ),
    headlineMedium: GoogleFonts.syne(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: const Color(0xFF333333),
    ),
    headlineSmall: GoogleFonts.syne(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: const Color(0xFF333333),
    ),
    titleLarge: GoogleFonts.dmSans(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF333333),
    ),
    titleMedium: GoogleFonts.dmSans(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF333333),
    ),
    titleSmall: GoogleFonts.dmSans(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF333333),
    ),
    bodyLarge: GoogleFonts.dmSans(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: const Color(0xFF333333),
    ),
    bodyMedium: GoogleFonts.dmSans(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: const Color(0xFF333333),
    ),
    bodySmall: GoogleFonts.dmSans(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: const Color(0xFF666666),
    ),
  );

  static TextTheme darkTextTheme = TextTheme(
    displayLarge: GoogleFonts.syne(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: const Color(0xFFFFFFFF),
    ),
    displayMedium: GoogleFonts.syne(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: const Color(0xFFFFFFFF),
    ),
    displaySmall: GoogleFonts.syne(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: const Color(0xFFFFFFFF),
    ),
    headlineLarge: GoogleFonts.syne(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: const Color(0xFFFFFFFF),
    ),
    headlineMedium: GoogleFonts.syne(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: const Color(0xFFFFFFFF),
    ),
    headlineSmall: GoogleFonts.syne(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: const Color(0xFFFFFFFF),
    ),
    titleLarge: GoogleFonts.dmSans(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: const Color(0xFFFFFFFF),
    ),
    titleMedium: GoogleFonts.dmSans(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: const Color(0xFFFFFFFF),
    ),
    titleSmall: GoogleFonts.dmSans(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: const Color(0xFFFFFFFF),
    ),
    bodyLarge: GoogleFonts.dmSans(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: const Color(0xFFFFFFFF),
    ),
    bodyMedium: GoogleFonts.dmSans(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: const Color(0xFFFFFFFF),
    ),
    bodySmall: GoogleFonts.dmSans(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: const Color(0xFFB3B3B3),
    ),
  );
}
