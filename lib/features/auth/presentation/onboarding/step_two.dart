import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StepTwo extends StatelessWidget {
  const StepTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF0D1A2E), Color(0xFF1A2D4E), Color(0xFF0A1E3A)],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const RadialGradient(
                    colors: [Color(0xFF80DEEA), Color(0xFF1565C0)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF80DEEA).withValues(alpha: 0.35),
                      blurRadius: 40,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text('🎭', style: TextStyle(fontSize: 64)),
                ),
              ),
              const SizedBox(height: 48),
              Text(
                'Registra tu estado\nde ánimo',
                textAlign: TextAlign.center,
                style: GoogleFonts.syne(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Selecciona la emoción que mejor describe cómo te sientes y añade una nota personal.',
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  color: Colors.white70,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 48),
              _MoodPreview(),
            ],
          ),
        ),
      ),
    );
  }
}

class _MoodPreview extends StatelessWidget {
  static const _moods = [
    ('😊', 'Feliz', Color(0xFFFFE8A3)),
    ('😌', 'En paz', Color(0xFFA8E6CF)),
    ('😐', 'Neutral', Color(0xFFD4D4E0)),
    ('😔', 'Triste', Color(0xFFA8C5E6)),
    ('😤', 'Enojado', Color(0xFFFF9B9B)),
    ('😰', 'Ansioso', Color(0xFFFFB3C6)),
  ];

  const _MoodPreview();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
      ),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.center,
        children: _moods.map((m) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: m.$3.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: m.$3.withValues(alpha: 0.5)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(m.$1, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 6),
                Text(
                  m.$2,
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
