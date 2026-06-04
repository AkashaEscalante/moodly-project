import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TestimonialCard extends StatelessWidget {
  const TestimonialCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: isDark
            ? const LinearGradient(
                colors: [Color(0xFF1A0A2E), Color(0xFF2A1A45)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : const LinearGradient(
                colors: [Color(0xFFF3E5F5), Color(0xFFEDE7F6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? const Color(0xFF9C27B0).withValues(alpha: 0.3)
              : const Color(0xFFCE93D8).withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quote icon
          Icon(
            Icons.format_quote_rounded,
            color: const Color(0xFF9C27B0).withValues(alpha: 0.5),
            size: 32,
          ),
          const SizedBox(height: 10),

          // Quote text
          Text(
            '"Moodly es una herramienta que recomiendo activamente a mis pacientes. '
            'Registrar las emociones diariamente genera autoconciencia y facilita '
            'el proceso terapéutico de forma muy significativa."',
            style: GoogleFonts.dmSans(
              fontSize: 13,
              fontStyle: FontStyle.italic,
              color: isDark ? Colors.white70 : const Color(0xFF555555),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 16),

          // Stars
          Row(
            children: List.generate(
              5,
              (i) => const Icon(
                Icons.star_rounded,
                color: Color(0xFFFFD700),
                size: 16,
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Author row
          Row(
            children: [
              // Avatar placeholder
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7E57C2), Color(0xFF4A148C)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF9C27B0).withValues(alpha: 0.4),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dra. Valentina Morales',
                      style: GoogleFonts.syne(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Psicóloga Clínica · Cédula 8742901',
                      style: GoogleFonts.dmSans(
                        fontSize: 11,
                        color: isDark
                            ? const Color(0xFF9E9E9E)
                            : const Color(0xFF888888),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF9C27B0).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Verificada ✓',
                  style: GoogleFonts.dmSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF9C27B0),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
