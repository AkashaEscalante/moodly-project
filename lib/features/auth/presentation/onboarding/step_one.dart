import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StepOne extends StatelessWidget {
  const StepOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A0A2E), Color(0xFF2D1B4E), Color(0xFF1E1040)],
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
                    colors: [Color(0xFFFF80AB), Color(0xFF9C27B0)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF80AB).withValues(alpha: 0.4),
                      blurRadius: 40,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text('🌸', style: TextStyle(fontSize: 64)),
                ),
              ),
              const SizedBox(height: 48),
              Text(
                'Bienvenida a Moodly',
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
                'Tu espacio seguro para explorar, entender y cuidar tu mundo emocional cada día.',
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  color: Colors.white70,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 48),
              _FeatureRow(icon: '✨', text: 'Registra cómo te sientes en segundos'),
              const SizedBox(height: 14),
              _FeatureRow(icon: '📊', text: 'Descubre patrones en tus emociones'),
              const SizedBox(height: 14),
              _FeatureRow(icon: '💬', text: 'Habla con Maya, tu asistente de bienestar'),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final String icon;
  final String text;

  const _FeatureRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(child: Text(icon, style: const TextStyle(fontSize: 20))),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.dmSans(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
        ),
      ],
    );
  }
}
