import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moodly/core/widgets/shimmer_loader.dart';
import 'package:moodly/features/auth/application/auth_provider.dart';
import 'package:moodly/features/premium/application/premium_provider.dart';
import 'package:moodly/features/premium/presentation/premium_gate_modal.dart';
import 'package:moodly/features/stats/application/stats_provider.dart';
import 'package:moodly/features/stats/domain/mood_stats_model.dart';
import 'package:moodly/features/stats/domain/wellness_model.dart';

class StatsScreen extends ConsumerStatefulWidget {
  const StatsScreen({super.key});

  @override
  ConsumerState<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userId = ref.watch(authStateProvider).valueOrNull?.id ?? '';
    final statsAsync = ref.watch(weeklyStatsProvider(userId));
    final wellnessAsync = ref.watch(wellnessProvider(userId));

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0D0D1A) : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF0D0D1A) : Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.canPop() ? context.pop() : null,
          child: Icon(Icons.chevron_left_rounded, color: isDark ? Colors.white : const Color(0xFF555555)),
        ),
        title: Text(
          'Estadísticas',
          style: GoogleFonts.syne(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF333333),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.trending_up_rounded, color: Color(0xFF9C27B0)),
            onPressed: () {},
          ),
        ],
      ),
      body: statsAsync.when(
        loading: () => const ShimmerLoader(),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (stats) => wellnessAsync.when(
          loading: () => const ShimmerLoader(),
          error: (e, _) => Center(child: Text(e.toString())),
          data: (wellness) => _buildContent(stats, wellness),
        ),
      ),
      bottomNavigationBar: _MoodlyBottomNav(currentIndex: -1, isDark: isDark),
    );
  }

  Widget _buildContent(MoodStats stats, WellnessData wellness) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _TabSelector(
            selectedIndex: _tabIndex,
            onTap: (i) {
              if (i > 0 && !ref.read(isPremiumProvider)) {
                showPremiumGate(context, feature: 'Historial completo de estadísticas');
                return;
              }
              setState(() => _tabIndex = i);
            },
          ),
          const SizedBox(height: 24),
          Text(
            'TU PROGRESO',
            style: GoogleFonts.dmSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF9C27B0),
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Mood ',
                  style: GoogleFonts.syne(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF222222),
                  ),
                ),
                TextSpan(
                  text: 'Balance',
                  style: GoogleFonts.syne(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFF06292),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _MoodBarChart(stats: stats),
          const SizedBox(height: 28),
          Text(
            'Tus Insights',
            style: GoogleFonts.syne(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF222222),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _InsightCard(
                  label: 'FRECUENTE',
                  value: stats.mostFrequentMood,
                  icon: '😊',
                  bgColor: const Color(0xFFE8F5E8),
                  accentColor: const Color(0xFF4CAF50),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: _InsightCard(
                  label: 'AMOR PROPIO',
                  value: 'Alto',
                  icon: '❤️',
                  bgColor: Color(0xFFFFF0E8),
                  accentColor: Color(0xFFFF7043),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _StreakCard(streak: stats.streak),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _WellnessCard(
                  icon: '🌙',
                  label: 'SUEÑO',
                  value: '${wellness.sleepHours.toStringAsFixed(1)}h',
                  color: const Color(0xFF9C27B0),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _WellnessCard(
                  icon: '💗',
                  label: 'ENERGÍA',
                  value: '${wellness.energyPct.toInt()}%',
                  color: const Color(0xFFF06292),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Factores Clave',
                style: GoogleFonts.syne(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF222222),
                ),
              ),
              Text(
                'VER MÁS',
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF9C27B0),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _FactorRow(icon: '🧘', label: 'Meditación', value: '${wellness.meditationMin.toInt()} min'),
          const SizedBox(height: 12),
          _FactorRow(icon: '💧', label: 'Hidratación', value: '${wellness.hydrationL.toStringAsFixed(1)} L'),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _TabSelector extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;
  static const _tabs = ['Semana', 'Mes', 'Año'];

  const _TabSelector({required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: List.generate(_tabs.length, (i) {
          final selected = i == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: selected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: Text(
                    _tabs[i],
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      color: selected ? const Color(0xFF333333) : const Color(0xFF999999),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _MoodBarChart extends StatelessWidget {
  final MoodStats stats;
  static const _days = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];

  const _MoodBarChart({required this.stats});

  @override
  Widget build(BuildContext context) {
    final values = List.generate(7, (i) {
      if (i < stats.weekData.length) {
        final v = stats.weekData[i]['value'];
        return (v is num) ? v.toDouble() : 3.0;
      }
      return 3.0;
    });

    return Container(
      height: 160,
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF0F0F0), width: 1.5),
      ),
      child: BarChart(
        BarChartData(
          maxY: 5,
          minY: 0,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final i = value.toInt();
                  if (i < 0 || i >= _days.length) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      _days[i],
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        color: const Color(0xFF999999),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 1,
            getDrawingHorizontalLine: (_) => FlLine(
              color: const Color(0xFFF0F0F0),
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(7, (i) {
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: values[i],
                  width: 20,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF48FB1), Color(0xFFCE93D8)],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  final String label;
  final String value;
  final String icon;
  final Color bgColor;
  final Color accentColor;

  const _InsightCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.bgColor,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: accentColor.withValues(alpha: 0.7),
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.syne(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: accentColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _StreakCard extends StatelessWidget {
  final int streak;
  const _StreakCard({required this.streak});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDE7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Text('☀️', style: TextStyle(fontSize: 32)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'RACHA DE BIENESTAR',
                  style: GoogleFonts.dmSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFAA8800),
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '¡$streak días radiantes!',
                  style: GoogleFonts.syne(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF795548),
                  ),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (streak % 7) / 7,
                    minHeight: 5,
                    backgroundColor: const Color(0xFFE0E0E0),
                    valueColor: const AlwaysStoppedAnimation(Color(0xFFFFC107)),
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

class _WellnessCard extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  final Color color;

  const _WellnessCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF0F0F0), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: color.withValues(alpha: 0.6),
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.syne(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF222222),
            ),
          ),
        ],
      ),
    );
  }
}

class _FactorRow extends StatelessWidget {
  final String icon;
  final String label;
  final String value;

  const _FactorRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F0F0), width: 1.5),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF333333),
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.syne(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF9C27B0),
            ),
          ),
        ],
      ),
    );
  }
}

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
              _NavItem(icon: Icons.home_outlined, label: 'Inicio', index: 0, currentIndex: currentIndex, route: '/home', isDark: isDark),
              _NavItem(icon: Icons.emoji_emotions_outlined, label: 'Ánimo', index: 1, currentIndex: currentIndex, route: '/mood-checkin', isDark: isDark),
              _NavItem(icon: Icons.auto_stories_outlined, label: 'Guía', index: 2, currentIndex: currentIndex, route: '/consejos', isDark: isDark),
              _NavItem(icon: Icons.menu_book_outlined, label: 'Diario', index: 3, currentIndex: currentIndex, route: '/diary', isDark: isDark),
              _NavItem(icon: Icons.person_outline_rounded, label: 'Perfil', index: 4, currentIndex: currentIndex, route: '/profile', isDark: isDark),
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
            Icon(icon, size: 22, color: selected ? const Color(0xFF9C27B0) : const Color(0xFFAAAAAA)),
            const SizedBox(height: 3),
            Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 10,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? const Color(0xFF9C27B0) : const Color(0xFFAAAAAA),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
