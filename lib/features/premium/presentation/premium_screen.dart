import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moodly/features/premium/application/premium_provider.dart';

class PremiumScreen extends ConsumerStatefulWidget {
  const PremiumScreen({super.key});

  @override
  ConsumerState<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends ConsumerState<PremiumScreen> {
  int _selectedPlan = 2; // default: Mensual

  static const _plans = <_PlanData>[
    _PlanData(
      title: 'Gratis',
      subtitle: '5 mensajes IA al día',
      price: '\$0',
      priceNum: '0',
      period: 'siempre gratis',
      badge: null,
      isFree: true,
      isGold: false,
    ),
    _PlanData(
      title: 'Estudiante',
      subtitle: 'Para alumnos CBTIS',
      price: '\$49',
      priceNum: '49',
      period: 'MXN / mes',
      badge: 'CBTIS',
      isFree: false,
      isGold: false,
    ),
    _PlanData(
      title: 'Mensual',
      subtitle: 'Acceso completo mensual',
      price: '\$89',
      priceNum: '89',
      period: 'MXN / mes',
      badge: null,
      isFree: false,
      isGold: false,
    ),
    _PlanData(
      title: 'Anual',
      subtitle: 'Ahorra vs mensual',
      price: '\$599',
      priceNum: '599',
      period: 'MXN / año',
      badge: 'Mejor valor',
      isFree: false,
      isGold: true,
    ),
  ];

  void _onCTA() {
    final p = _plans[_selectedPlan];
    if (p.isFree) return;
    context.push('/payment', extra: <String, String>{
      'planName': p.title,
      'price': p.priceNum,
      'period': p.period,
    });
  }

  @override
  Widget build(BuildContext context) {
    final isPremium = ref.watch(isPremiumProvider);
    final plan = _plans[_selectedPlan];

    return Scaffold(
      backgroundColor: const Color(0xFF04040F),
      body: Stack(
        children: [
          // Glow blobs — substrato del efecto glass
          Positioned(
            top: -80, left: -80,
            child: _GlowBlob(color: const Color(0xFF7B1FA2), size: 320),
          ),
          Positioned(
            top: 260, right: -100,
            child: _GlowBlob(color: const Color(0xFFAD1457), size: 240),
          ),
          Positioned(
            bottom: 60, left: -50,
            child: _GlowBlob(color: const Color(0xFF1A237E), size: 200),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Botón cerrar
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        margin: const EdgeInsets.only(top: 12),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.12),
                          ),
                        ),
                        child: const Icon(Icons.close_rounded,
                            color: Colors.white54, size: 20),
                      ),
                    ),
                  ).animate().fadeIn(duration: 300.ms),

                  const SizedBox(height: 16),

                  // Hero avatar con glow
                  Container(
                    width: 100, height: 100,
                    decoration: BoxDecoration(
                      gradient: const RadialGradient(
                        colors: [Color(0xFFCE93D8), Color(0xFF4A148C)],
                        center: Alignment(-0.4, -0.4),
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF9C27B0).withValues(alpha: 0.7),
                          blurRadius: 60,
                          spreadRadius: 8,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text('🐱', style: TextStyle(fontSize: 50)),
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 80.ms, duration: 500.ms)
                      .scale(
                        begin: const Offset(0.7, 0.7),
                        duration: 600.ms,
                        curve: Curves.elasticOut,
                      ),

                  const SizedBox(height: 20),

                  Text(
                    'Moodly Premium',
                    style: GoogleFonts.syne(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ).animate().fadeIn(delay: 150.ms, duration: 400.ms),

                  const SizedBox(height: 6),

                  Text(
                    'Desbloquea tu bienestar emocional completo',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      color: Colors.white54,
                      height: 1.4,
                    ),
                  ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

                  const SizedBox(height: 28),

                  // Tarjeta glassmorphic de beneficios
                  _GlassCard(
                    child: const _BenefitsList(),
                  )
                      .animate()
                      .fadeIn(delay: 250.ms, duration: 400.ms)
                      .slideY(
                        begin: 0.12,
                        duration: 400.ms,
                        curve: Curves.easeOut,
                      ),

                  const SizedBox(height: 28),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Elige tu plan',
                      style: GoogleFonts.syne(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ).animate().fadeIn(delay: 300.ms),

                  const SizedBox(height: 14),

                  // Plan cards
                  for (var i = 0; i < _plans.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _PlanCard(
                        data: _plans[i],
                        selected: _selectedPlan == i,
                        onTap: () => setState(() => _selectedPlan = i),
                      )
                          .animate()
                          .fadeIn(
                            delay: Duration(milliseconds: 320 + i * 65),
                            duration: 350.ms,
                          )
                          .slideX(
                            begin: 0.05,
                            duration: 350.ms,
                            curve: Curves.easeOut,
                          ),
                    ),

                  const SizedBox(height: 28),

                  // CTA
                  if (isPremium)
                    _GlassCard(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1B5E20), Color(0xFF388E3C)],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle_rounded,
                              color: Colors.white, size: 22),
                          const SizedBox(width: 10),
                          Text(
                            '¡Ya tienes Premium! 🐱',
                            style: GoogleFonts.syne(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    )
                  else if (plan.isFree)
                    _GlassCard(
                      child: Text(
                        'Actualmente usas el plan Gratis · Selecciona otro plan para mejorar',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.dmSans(
                            fontSize: 13, color: Colors.white54),
                      ),
                    )
                  else
                    GestureDetector(
                      onTap: _onCTA,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF80AB), Color(0xFF9C27B0)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF9C27B0)
                                  .withValues(alpha: 0.55),
                              blurRadius: 28,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Text(
                          'Continuar con ${plan.title}  ·  ${plan.price}',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.syne(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 600.ms, duration: 400.ms)
                        .scale(
                          begin: const Offset(0.95, 0.95),
                          duration: 400.ms,
                          curve: Curves.easeOut,
                        ),

                  const SizedBox(height: 14),

                  Text(
                    'Cancela cuando quieras  ·  Sin compromisos',
                    style: GoogleFonts.dmSans(
                        fontSize: 11, color: Colors.white24),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Data model ───────────────────────────────────────────────────────────────

class _PlanData {
  final String title;
  final String subtitle;
  final String price;
  final String priceNum;
  final String period;
  final String? badge;
  final bool isFree;
  final bool isGold;

  const _PlanData({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.priceNum,
    required this.period,
    this.badge,
    required this.isFree,
    required this.isGold,
  });
}

// ─── Decoración ───────────────────────────────────────────────────────────────

class _GlowBlob extends StatelessWidget {
  final Color color;
  final double size;
  const _GlowBlob({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.10),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.28),
            blurRadius: size * 0.75,
            spreadRadius: size * 0.35,
          ),
        ],
      ),
    );
  }
}

// ─── Tarjeta glassmorphic base ────────────────────────────────────────────────

class _GlassCard extends StatelessWidget {
  final Widget child;
  final Gradient? gradient;

  const _GlassCard({required this.child, this.gradient});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: gradient,
            color:
                gradient == null ? Colors.white.withValues(alpha: 0.05) : null,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.10),
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

// ─── Lista de beneficios ──────────────────────────────────────────────────────

class _BenefitsList extends StatelessWidget {
  const _BenefitsList();

  @override
  Widget build(BuildContext context) {
    const items = <(String, String, String)>[
      ('💬', 'Chat ilimitado con Maya', 'Gratis: 5 mensajes / día'),
      ('📊', 'Estadísticas completas', 'Gratis: solo esta semana'),
      ('🧠', 'Análisis de emociones con IA', 'Exclusivo Premium'),
      ('📔', 'Diario integrado con IA', 'Todo en una pantalla'),
      ('📤', 'Exportar tu diario', 'Exclusivo Premium'),
    ];

    return Column(
      children: [
        for (var i = 0; i < items.length; i++)
          Padding(
            padding: EdgeInsets.only(bottom: i < items.length - 1 ? 16 : 0),
            child: Row(
              children: [
                Text(items[i].$1,
                    style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(items[i].$2,
                          style: GoogleFonts.dmSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                      Text(items[i].$3,
                          style: GoogleFonts.dmSans(
                              fontSize: 11, color: Colors.white38)),
                    ],
                  ),
                ),
                const Icon(Icons.check_circle_rounded,
                    color: Color(0xFFCE93D8), size: 18),
              ],
            ),
          ),
      ],
    );
  }
}

// ─── Tarjeta de plan ──────────────────────────────────────────────────────────

class _PlanCard extends StatelessWidget {
  final _PlanData data;
  final bool selected;
  final VoidCallback onTap;

  const _PlanCard({
    required this.data,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isGold = data.isGold;
    final selectedColor =
        isGold ? const Color(0xFFB8860B) : const Color(0xFF9C27B0);
    final selectedBorder =
        isGold ? const Color(0xFFFFD700) : const Color(0xFFCE93D8);
    final badgeColor =
        isGold ? const Color(0xFFFFD700) : const Color(0xFFFF80AB);

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            padding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              gradient: selected
                  ? LinearGradient(
                      colors: isGold
                          ? [
                              const Color(0xFF6D5000),
                              const Color(0xFFB8860B),
                            ]
                          : [
                              const Color(0xFF5E1A8A),
                              const Color(0xFF9C27B0),
                            ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: selected ? null : Colors.white.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: selected
                    ? selectedBorder.withValues(alpha: 0.8)
                    : Colors.white.withValues(alpha: 0.09),
                width: selected ? 1.5 : 1,
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: selectedColor.withValues(alpha: 0.35),
                        blurRadius: 22,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : [],
            ),
            child: Row(
              children: [
                // Radio
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: 22, height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.3),
                      width: 2,
                    ),
                    color: selected ? Colors.white : Colors.transparent,
                  ),
                  child: selected
                      ? Icon(Icons.check_rounded,
                          size: 13, color: selectedColor)
                      : null,
                ),
                const SizedBox(width: 14),

                // Título + subtítulo + badge
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            data.title,
                            style: GoogleFonts.syne(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          if (data.badge != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: badgeColor.withValues(alpha: 0.18),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: badgeColor.withValues(alpha: 0.55),
                                ),
                              ),
                              child: Text(
                                data.badge!,
                                style: GoogleFonts.dmSans(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: badgeColor,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        data.subtitle,
                        style: GoogleFonts.dmSans(
                          fontSize: 11,
                          color:
                              selected ? Colors.white54 : Colors.white30,
                        ),
                      ),
                    ],
                  ),
                ),

                // Precio
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      data.price,
                      style: GoogleFonts.syne(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      data.period,
                      style: GoogleFonts.dmSans(
                          fontSize: 9, color: Colors.white54),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
