import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StepFour extends StatelessWidget {
  const StepFour({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2A0A3E), Color(0xFF1A0A2E), Color(0xFF300D50)],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const RadialGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFF48FB1)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFD700).withValues(alpha: 0.4),
                      blurRadius: 50,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text('✨', style: TextStyle(fontSize: 72)),
                ),
              ),
              const SizedBox(height: 48),
              Text(
                '¡Todo listo!',
                textAlign: TextAlign.center,
                style: GoogleFonts.syne(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tu journey de bienestar\nemocional comienza ahora',
                textAlign: TextAlign.center,
                style: GoogleFonts.syne(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFFFF80AB),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'Recuerda: cada emoción que sientes es válida. Moodly está aquí para acompañarte sin juzgarte.',
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(
                  fontSize: 15,
                  color: Colors.white60,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 48),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: const Color(0xFFFF80AB).withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatChip(emoji: '🌟', label: 'Racha\ndiaria'),
                    _Divider(),
                    _StatChip(emoji: '💜', label: 'Auto-\nconocimiento'),
                    _Divider(),
                    _StatChip(emoji: '🧠', label: 'Bienestar\nemocional'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String emoji;
  final String label;

  const _StatChip({required this.emoji, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 28)),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.dmSans(
            fontSize: 11,
            color: Colors.white70,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 48,
      color: Colors.white.withValues(alpha: 0.15),
    );
  }
}
