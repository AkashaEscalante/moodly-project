import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> showPremiumGate(BuildContext context, {required String feature}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _PremiumGateSheet(feature: feature),
  );
}

class _PremiumGateSheet extends StatelessWidget {
  final String feature;
  const _PremiumGateSheet({required this.feature});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A0A2E), Color(0xFF2D1B4E)],
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          // Cat icon
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFAB47BC), Color(0xFF4A148C)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF9C27B0).withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Center(
              child: Text('🐱', style: TextStyle(fontSize: 34)),
            ),
          ),
          const SizedBox(height: 20),

          Text(
            'Función Premium',
            style: GoogleFonts.syne(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '"$feature" está disponible\nexclusivamente en Moodly Premium.',
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              fontSize: 14,
              color: Colors.white60,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 28),

          // Benefits
          _BenefitRow(emoji: '💬', text: 'Chat ilimitado con Maya'),
          const SizedBox(height: 10),
          _BenefitRow(emoji: '📊', text: 'Historial completo de estadísticas'),
          const SizedBox(height: 10),
          _BenefitRow(emoji: '🧠', text: 'Análisis de emociones con IA'),
          const SizedBox(height: 10),
          _BenefitRow(emoji: '📤', text: 'Exportar tu diario'),
          const SizedBox(height: 32),

          // CTA button
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
              context.go('/premium');
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF80AB), Color(0xFF9C27B0)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF9C27B0).withValues(alpha: 0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Text(
                'Ver planes Premium',
                textAlign: TextAlign.center,
                style: GoogleFonts.syne(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Ahora no',
              style: GoogleFonts.dmSans(
                fontSize: 13,
                color: Colors.white38,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BenefitRow extends StatelessWidget {
  final String emoji;
  final String text;
  const _BenefitRow({required this.emoji, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 12),
        Text(
          text,
          style: GoogleFonts.dmSans(
            fontSize: 13,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}
