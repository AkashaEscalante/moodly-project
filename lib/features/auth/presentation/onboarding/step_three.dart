import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StepThree extends StatelessWidget {
  const StepThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0A1E10), Color(0xFF143322), Color(0xFF0D2B1A)],
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
                    colors: [Color(0xFFA5D6A7), Color(0xFF2E7D32)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFA5D6A7).withValues(alpha: 0.35),
                      blurRadius: 40,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text('🧘', style: TextStyle(fontSize: 64)),
                ),
              ),
              const SizedBox(height: 48),
              Text(
                'Cuida tu mente\ncada día',
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
                'El bienestar emocional es un hábito. Con Moodly tienes herramientas para construirlo paso a paso.',
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  color: Colors.white70,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 48),
              _HabitCard(
                emoji: '📔',
                title: 'Diario personal',
                subtitle: 'Escribe tus pensamientos y reflexiones',
              ),
              const SizedBox(height: 12),
              _HabitCard(
                emoji: '📈',
                title: 'Estadísticas semanales',
                subtitle: 'Visualiza el progreso de tu bienestar',
              ),
              const SizedBox(height: 12),
              _HabitCard(
                emoji: '💡',
                title: 'Consejos de bienestar',
                subtitle: 'Tips basados en psicología positiva',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HabitCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;

  const _HabitCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.syne(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
