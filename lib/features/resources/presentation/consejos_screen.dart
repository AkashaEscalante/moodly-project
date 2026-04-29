import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ConsejosScreen extends ConsumerWidget {
  const ConsejosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF0D0D1A) : const Color(0xFFF8F5FF);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Consejos',
              style: GoogleFonts.syne(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF222222),
              ),
            ),
            Text(
              'Tips para mejorar tu bienestar emocional',
              style: GoogleFonts.dmSans(
                fontSize: 12,
                color: isDark
                    ? const Color(0xFF9E9E9E)
                    : const Color(0xFF999999),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Column(
          children: [
            _DailyTipCard(isDark: isDark),
            const SizedBox(height: 16),
            ..._categories.map(
              (cat) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _CategoryCard(category: cat, isDark: isDark),
              ),
            ),
            const SizedBox(height: 16),
            _DisclaimerCard(isDark: isDark),
          ],
        ),
      ),
      bottomNavigationBar: _MoodlyBottomNav(currentIndex: 2, isDark: isDark),
    );
  }
}

class _DailyTipCard extends StatelessWidget {
  final bool isDark;
  const _DailyTipCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF4A1F6E), const Color(0xFF2D1B4E)]
              : [const Color(0xFF9C27B0), const Color(0xFF7B1FA2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9C27B0).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('✨', style: TextStyle(fontSize: 32)),
          const SizedBox(height: 10),
          Text(
            'Consejo del día',
            style: GoogleFonts.syne(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'La gratitud es una poderosa herramienta emocional. '
            'Cada noche, escribe tres cosas por las que estés agradecida. '
            'Este simple ejercicio puede mejorar significativamente tu estado '
            'de ánimo y perspectiva de vida.',
            style: GoogleFonts.dmSans(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _TipCategory {
  final String icon;
  final String title;
  final Color iconColor;
  final Color bgColor;
  final List<String> tips;

  const _TipCategory({
    required this.icon,
    required this.title,
    required this.iconColor,
    required this.bgColor,
    required this.tips,
  });
}

const _categories = [
  _TipCategory(
    icon: '🧘',
    title: 'Manejo del estrés',
    iconColor: Color(0xFF9C27B0),
    bgColor: Color(0xFFF3E5F5),
    tips: [
      'Practica la respiración profunda durante 5 minutos',
      'Toma descansos regulares durante el día',
      'Identifica y evita los desencadenantes de estrés',
    ],
  ),
  _TipCategory(
    icon: '❤️',
    title: 'Bienestar emocional',
    iconColor: Color(0xFFF48FB1),
    bgColor: Color(0xFFFCE4EC),
    tips: [
      'Expresa tus emociones de manera saludable',
      'Rodéate de personas que te apoyen',
      'Practica la gratitud diariamente',
    ],
  ),
  _TipCategory(
    icon: '🌙',
    title: 'Mejora del sueño',
    iconColor: Color(0xFF7986CB),
    bgColor: Color(0xFFE8EAF6),
    tips: [
      'Establece una rutina de sueño consistente',
      'Evita pantallas 1 hora antes de dormir',
      'Crea un ambiente tranquilo y oscuro',
    ],
  ),
  _TipCategory(
    icon: '🏃',
    title: 'Actividad física',
    iconColor: Color(0xFF4CAF50),
    bgColor: Color(0xFFE8F5E9),
    tips: [
      'Haz 30 minutos de ejercicio al día',
      'Camina durante tus descansos',
      'Prueba yoga o meditación',
    ],
  ),
  _TipCategory(
    icon: '📚',
    title: 'Desarrollo personal',
    iconColor: Color(0xFFFFA726),
    bgColor: Color(0xFFFFF8E1),
    tips: [
      'Lee libros que te inspiren',
      'Aprende una nueva habilidad',
      'Establece metas realistas y alcanzables',
    ],
  ),
  _TipCategory(
    icon: '👥',
    title: 'Conexiones sociales',
    iconColor: Color(0xFF26A69A),
    bgColor: Color(0xFFE0F2F1),
    tips: [
      'Pasa tiempo de calidad con seres queridos',
      'Únete a grupos con intereses comunes',
      'Practica la escucha activa',
    ],
  ),
];

class _CategoryCard extends StatelessWidget {
  final _TipCategory category;
  final bool isDark;

  const _CategoryCard({required this.category, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final cardColor = isDark ? const Color(0xFF1E1E2E) : Colors.white;
    final headerBg = isDark
        ? category.iconColor.withValues(alpha: 0.15)
        : category.bgColor;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF2A2A3E) : const Color(0xFFF0F0F0),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
            decoration: BoxDecoration(
              color: headerBg,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Text(category.icon, style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 10),
                Text(
                  category.title,
                  style: GoogleFonts.syne(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF333333),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 16),
            child: Column(
              children: category.tips.map((tip) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(top: 6, right: 10),
                        decoration: BoxDecoration(
                          color: category.iconColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          tip,
                          style: GoogleFonts.dmSans(
                            fontSize: 13,
                            color: isDark
                                ? const Color(0xFFCCCCCC)
                                : const Color(0xFF555555),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _DisclaimerCard extends StatelessWidget {
  final bool isDark;
  const _DisclaimerCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : const Color(0xFFE8EAF6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        'Nota: Estos consejos son generales y no sustituyen la atención profesional. '
        'Si experimentas dificultades emocionales persistentes, considera consultar a un profesional de salud mental.',
        style: GoogleFonts.dmSans(
          fontSize: 12,
          color: isDark ? const Color(0xFF9E9E9E) : const Color(0xFF666666),
          height: 1.5,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}

// ─── Bottom Nav ───────────────────────────────

class _MoodlyBottomNav extends StatelessWidget {
  final int currentIndex;
  final bool isDark;
  const _MoodlyBottomNav({required this.currentIndex, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? const Color(0xFF1A1A2E) : Colors.white;
    return Container(
      decoration: BoxDecoration(
        color: bg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_outlined,
                label: 'Inicio',
                index: 0,
                currentIndex: currentIndex,
                route: '/home',
                isDark: isDark,
              ),
              _NavItem(
                icon: Icons.emoji_emotions_outlined,
                label: 'Ánimo',
                index: 1,
                currentIndex: currentIndex,
                route: '/mood-checkin',
                isDark: isDark,
              ),
              _NavItem(
                icon: Icons.auto_stories_outlined,
                label: 'Guía',
                index: 2,
                currentIndex: currentIndex,
                route: '/consejos',
                isDark: isDark,
              ),
              _NavItem(
                icon: Icons.menu_book_outlined,
                label: 'Diario',
                index: 3,
                currentIndex: currentIndex,
                route: '/diary',
                isDark: isDark,
              ),
              _NavItem(
                icon: Icons.person_outline_rounded,
                label: 'Perfil',
                index: 4,
                currentIndex: currentIndex,
                route: '/profile',
                isDark: isDark,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int currentIndex;
  final String route;
  final bool isDark;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.route,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final selected = index == currentIndex;
    return GestureDetector(
      onTap: () => context.go(route),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF9C27B0).withValues(alpha: isDark ? 0.3 : 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: selected
                  ? const Color(0xFF9C27B0)
                  : const Color(0xFFAAAAAA),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 10,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected
                    ? const Color(0xFF9C27B0)
                    : const Color(0xFFAAAAAA),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
