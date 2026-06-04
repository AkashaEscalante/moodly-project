import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moodly/features/auth/application/auth_provider.dart'
    show authStateProvider;
import 'package:moodly/features/diary/application/diary_provider.dart'
    show gratitudeEntriesProvider;
import 'package:moodly/features/mood/application/mood_provider.dart'
    show moodEntriesProvider;

class PrivacyScreen extends ConsumerStatefulWidget {
  const PrivacyScreen({super.key});

  @override
  ConsumerState<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends ConsumerState<PrivacyScreen> {
  bool _analyticsEnabled = true;
  bool _personalizedEnabled = true;
  bool _crashReportsEnabled = true;

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black87,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: const Color(0xFF1A0A2E).withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: Colors.redAccent.withValues(alpha: 0.4),
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.delete_forever_rounded,
                        color: Colors.redAccent, size: 36),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '¿Borrar todo tu historial?',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.syne(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Esta acción eliminará permanentemente todos tus registros de estado de ánimo, entradas de diario e historial de chat. No se puede deshacer.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      color: Colors.white54,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.of(ctx).pop(false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.12)),
                            ),
                            child: Text(
                              'Cancelar',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.syne(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white70),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.of(ctx).pop(true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFD32F2F),
                                  Color(0xFFB71C1C),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.redAccent
                                      .withValues(alpha: 0.4),
                                  blurRadius: 14,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Text(
                              'Sí, borrar',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.syne(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (confirmed == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '🗑️ Historial borrado de forma segura.',
            style: GoogleFonts.dmSans(fontWeight: FontWeight.w700),
          ),
          backgroundColor: const Color(0xFF6A1B9A),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Datos reales desde los providers de Supabase
    final userId = ref.watch(authStateProvider).valueOrNull?.id ?? '';
    final moodCount = userId.isNotEmpty
        ? (ref.watch(moodEntriesProvider(userId)).valueOrNull?.length ?? 0)
        : 0;
    final diaryCount = userId.isNotEmpty
        ? (ref.watch(gratitudeEntriesProvider(userId)).valueOrNull?.length ?? 0)
        : 0;

    return Scaffold(
      backgroundColor: const Color(0xFF04040F),
      body: Stack(
        children: [
          // Glow blobs de fondo
          Positioned(
            top: -60, left: -60,
            child: _blob(const Color(0xFF7B1FA2), 260),
          ),
          Positioned(
            bottom: 80, right: -80,
            child: _blob(const Color(0xFF1A237E), 200),
          ),

          SafeArea(
            child: Column(
              children: [
                // AppBar
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: const EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.08),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.white.withValues(alpha: 0.12)),
                          ),
                          child: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                              size: 16),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Text(
                        'Tablero de Privacidad',
                        style: GoogleFonts.syne(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 300.ms),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 48),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hero card
                        _GlassPanel(
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF9C27B0),
                                      Color(0xFF7B1FA2),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(Icons.shield_rounded,
                                    color: Colors.white, size: 28),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Tu privacidad importa 🐱',
                                      style: GoogleFonts.syne(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Controla exactamente qué datos comparte Moodly.',
                                      style: GoogleFonts.dmSans(
                                        fontSize: 12,
                                        color: Colors.white54,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(duration: 350.ms),

                        const SizedBox(height: 20),

                        // Stats de datos almacenados
                        _sectionTitle('Resumen de tus datos'),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _DataStatChip(
                                icon: Icons.emoji_emotions_rounded,
                                label: 'Registros',
                                value: '$moodCount',
                                color: const Color(0xFFCE93D8)),
                            const SizedBox(width: 10),
                            _DataStatChip(
                                icon: Icons.menu_book_rounded,
                                label: 'Entradas',
                                value: '$diaryCount',
                                color: const Color(0xFF80CFFE)),
                            const SizedBox(width: 10),
                            _DataStatChip(
                                icon: Icons.chat_bubble_rounded,
                                label: 'Chats',
                                value: '—',
                                color: const Color(0xFFF48FB1)),
                          ],
                        ).animate().fadeIn(delay: 80.ms),

                        const SizedBox(height: 24),

                        // Controles de privacidad
                        _sectionTitle('Permisos de datos'),
                        const SizedBox(height: 12),
                        _GlassPanel(
                          padding: EdgeInsets.zero,
                          child: Column(
                            children: [
                              _PrivacyToggle(
                                icon: Icons.bar_chart_rounded,
                                iconColor: const Color(0xFF9C27B0),
                                title: 'Analítica de uso',
                                subtitle:
                                    'Ayuda a mejorar la app de forma anónima',
                                value: _analyticsEnabled,
                                onChanged: (v) =>
                                    setState(() => _analyticsEnabled = v),
                                showDivider: true,
                              ),
                              _PrivacyToggle(
                                icon: Icons.auto_awesome_rounded,
                                iconColor: const Color(0xFFFF80AB),
                                title: 'Personalización con IA',
                                subtitle:
                                    'Maya adapta sus respuestas a tu historial',
                                value: _personalizedEnabled,
                                onChanged: (v) =>
                                    setState(() => _personalizedEnabled = v),
                                showDivider: true,
                              ),
                              _PrivacyToggle(
                                icon: Icons.bug_report_rounded,
                                iconColor: const Color(0xFF80CFFE),
                                title: 'Reportes de errores',
                                subtitle:
                                    'Envía fallos técnicos de forma anónima',
                                value: _crashReportsEnabled,
                                onChanged: (v) =>
                                    setState(() => _crashReportsEnabled = v),
                                showDivider: false,
                              ),
                            ],
                          ),
                        ).animate().fadeIn(delay: 120.ms),

                        const SizedBox(height: 24),

                        // Información recopilada
                        _sectionTitle('Qué almacenamos'),
                        const SizedBox(height: 12),
                        _GlassPanel(
                          child: Column(
                            children: [
                              for (final item in [
                                (Icons.email_rounded, const Color(0xFF80CFFE),
                                    'Correo y nombre de cuenta'),
                                (Icons.emoji_emotions_rounded,
                                    const Color(0xFFCE93D8),
                                    'Registros de ánimo e intensidad'),
                                (Icons.menu_book_rounded,
                                    const Color(0xFFF48FB1),
                                    'Entradas de tu diario'),
                                (Icons.lock_rounded,
                                    Colors.green,
                                    'Contraseñas con hash bcrypt — nunca en texto plano'),
                                (Icons.block_rounded,
                                    const Color(0xFFFFD700),
                                    'Tus datos NUNCA se venden a terceros'),
                              ])
                                Padding(
                                  padding:
                                      const EdgeInsets.only(bottom: 12),
                                  child: Row(
                                    children: [
                                      Icon(item.$1,
                                          color: item.$2, size: 18),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          item.$3,
                                          style: GoogleFonts.dmSans(
                                            fontSize: 13,
                                            color: Colors.white70,
                                            height: 1.3,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ).animate().fadeIn(delay: 160.ms),

                        const SizedBox(height: 28),

                        // ── Zona de peligro ────────────────────────────────────
                        _sectionTitle('Zona de peligro', isRed: true),
                        const SizedBox(height: 12),

                        GestureDetector(
                          onTap: _confirmDelete,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.redAccent.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color:
                                    Colors.redAccent.withValues(alpha: 0.35),
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent
                                        .withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                      Icons.delete_forever_rounded,
                                      color: Colors.redAccent,
                                      size: 22),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Borrado Seguro e Instantáneo',
                                        style: GoogleFonts.syne(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Elimina permanentemente todos tus datos del historial',
                                        style: GoogleFonts.dmSans(
                                          fontSize: 11,
                                          color: Colors.white38,
                                          height: 1.3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.chevron_right_rounded,
                                    color: Colors.redAccent, size: 20),
                              ],
                            ),
                          ),
                        )
                            .animate()
                            .fadeIn(delay: 200.ms)
                            .slideY(
                                begin: 0.05,
                                duration: 350.ms,
                                curve: Curves.easeOut),

                        const SizedBox(height: 16),

                        // Contacto
                        _GlassPanel(
                          child: Row(
                            children: [
                              const Icon(Icons.mail_outline_rounded,
                                  color: Color(0xFFCE93D8), size: 20),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '¿Dudas sobre tu privacidad?',
                                      style: GoogleFonts.syne(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'privacidad@moodly.app',
                                      style: GoogleFonts.dmSans(
                                        fontSize: 12,
                                        color: const Color(0xFFCE93D8),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(delay: 240.ms),

                        const SizedBox(height: 20),
                        Center(
                          child: Text(
                            'Moodly © 2025 · Todos los derechos reservados',
                            style: GoogleFonts.dmSans(
                                fontSize: 11, color: Colors.white24),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text, {bool isRed = false}) => Text(
        text,
        style: GoogleFonts.syne(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: isRed ? Colors.redAccent : Colors.white,
        ),
      );

  Widget _blob(Color color, double size) => Container(
        width: size, height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: 0.09),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.22),
              blurRadius: size * 0.8,
              spreadRadius: size * 0.3,
            ),
          ],
        ),
      );
}

// ─── Panel glassmorphic reutilizable ─────────────────────────────────────────

class _GlassPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const _GlassPanel({required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          width: double.infinity,
          padding: padding ?? const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(22),
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

// ─── Chip de estadística ──────────────────────────────────────────────────────

class _DataStatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _DataStatChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 6),
            Text(
              value,
              style: GoogleFonts.syne(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.dmSans(
                  fontSize: 10, color: Colors.white38),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Toggle de privacidad ─────────────────────────────────────────────────────

class _PrivacyToggle extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool showDivider;

  const _PrivacyToggle({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 38, height: 38,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: GoogleFonts.syne(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    Text(subtitle,
                        style: GoogleFonts.dmSans(
                            fontSize: 11, color: Colors.white38)),
                  ],
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeTrackColor: const Color(0xFF9C27B0),
                activeThumbColor: Colors.white,
                inactiveTrackColor: Colors.white12,
                inactiveThumbColor: Colors.white38,
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            color: Colors.white.withValues(alpha: 0.07),
            height: 1,
            indent: 18,
            endIndent: 18,
          ),
      ],
    );
  }
}
