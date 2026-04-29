import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moodly/core/widgets/shimmer_loader.dart';
import 'package:moodly/features/resources/application/resources_provider.dart';
import 'package:moodly/features/resources/domain/resource_model.dart';

class ResourcesScreen extends ConsumerStatefulWidget {
  const ResourcesScreen({super.key});

  @override
  ConsumerState<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends ConsumerState<ResourcesScreen> {
  String _selectedCategory = 'all';

  static const _filters = [
    ('all', 'Todo'),
    ('ansiedad', 'Ansiedad'),
    ('sueño', 'Sueño'),
    ('energía', 'Energía'),
    ('mindfulness', 'Mindfulness'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final resourcesAsync = ref.watch(
      resourcesByCategoryProvider(_selectedCategory),
    );

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0D0D1A) : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF0D0D1A) : Colors.white,
        elevation: 0,
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Recursos ',
                style: GoogleFonts.syne(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF222222),
                ),
              ),
              TextSpan(
                text: 'Paz',
                style: GoogleFonts.syne(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF9C27B0),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          // ─── Filtros ────────────────────────────────────────────────────
          SizedBox(
            height: 38,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (_, i) {
                final selected = _filters[i].$1 == _selectedCategory;
                return GestureDetector(
                  onTap: () =>
                      setState(() => _selectedCategory = _filters[i].$1),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFF9C27B0)
                          : isDark
                          ? const Color(0xFF1E1E2E)
                          : const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _filters[i].$2,
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: selected
                            ? Colors.white
                            : isDark
                            ? const Color(0xFF9E9E9E)
                            : const Color(0xFF777777),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          // ─── Lista de tips ──────────────────────────────────────────────
          Expanded(
            child: resourcesAsync.when(
              loading: () => const ShimmerLoader(),
              error: (e, _) =>
                  _ErrorState(message: e.toString(), isDark: isDark),
              data: (tips) => tips.isEmpty
                  ? _EmptyState(isDark: isDark)
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
                      itemCount: tips.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (_, i) =>
                          _TipCard(tip: tips[i], isDark: isDark, colorIndex: i),
                    ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _MoodlyBottomNav(currentIndex: 2, isDark: isDark),
    );
  }
}

// ─── Tip card ─────────────────────────────────────────────────────────────────

class _TipCard extends StatelessWidget {
  final Resource tip;
  final bool isDark;
  final int colorIndex;

  static const _gradients = [
    [Color(0xFF80CBC4), Color(0xFF26A69A)],
    [Color(0xFFCE93D8), Color(0xFF9C27B0)],
    [Color(0xFFA5D6A7), Color(0xFF4CAF50)],
    [Color(0xFF90CAF9), Color(0xFF42A5F5)],
    [Color(0xFFFFCC80), Color(0xFFFFA726)],
    [Color(0xFFF48FB1), Color(0xFFE91E8C)],
  ];

  static const _iconMap = {
    'spa': Icons.spa_rounded,
    'nightlight': Icons.nightlight_round,
    'book': Icons.menu_book_rounded,
    'bolt': Icons.bolt_rounded,
    'air': Icons.air_rounded,
    'favorite': Icons.favorite_rounded,
    'self_improvement': Icons.self_improvement_rounded,
    'eco': Icons.eco_rounded,
    'star': Icons.star_rounded,
    'psychology': Icons.psychology_rounded,
  };

  const _TipCard({
    required this.tip,
    required this.isDark,
    required this.colorIndex,
  });

  @override
  Widget build(BuildContext context) {
    final idx = colorIndex % _gradients.length;
    final gradient = _gradients[idx];
    final icon = _iconMap[tip.iconName] ?? Icons.lightbulb_outline_rounded;
    final cardBg = isDark ? const Color(0xFF1E1E2E) : Colors.white;
    final borderColor = isDark
        ? const Color(0xFF2A2A3E)
        : const Color(0xFFF0F0F0);

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icono con gradiente
          Container(
            width: 72,
            height: 90,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(16),
              ),
            ),
            child: Icon(icon, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 14),
          // Contenido
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (tip.category.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: gradient[0].withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        tip.category.toUpperCase(),
                        style: GoogleFonts.dmSans(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: gradient[1],
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  Text(
                    tip.title,
                    style: GoogleFonts.syne(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF222222),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tip.content,
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: isDark
                          ? const Color(0xFF9E9E9E)
                          : const Color(0xFF888888),
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}

// ─── Estados vacío / error ───────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final bool isDark;
  const _EmptyState({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('📚', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          Text(
            'No hay recursos en esta categoría',
            style: GoogleFonts.syne(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF333333),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final bool isDark;
  const _ErrorState({required this.message, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: GoogleFonts.dmSans(
          color: isDark ? Colors.white54 : Colors.black54,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

// ─── Bottom Nav ───────────────────────────────────────────────────────────────

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
