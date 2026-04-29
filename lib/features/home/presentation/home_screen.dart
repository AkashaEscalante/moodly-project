import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:moodly/features/auth/application/auth_provider.dart';
import 'package:moodly/features/mood/application/mood_provider.dart';
import 'package:moodly/features/resources/application/resources_provider.dart'
    show dailyMessageProvider;

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userAsync = ref.watch(authStateProvider);
    final userId = userAsync.valueOrNull?.id ?? '';

    final entriesAsync = ref.watch(moodEntriesProvider(userId));
    final weeklyAsync = ref.watch(weeklyEntriesProvider(userId));

    final now = DateTime.now();
    final dateStr = DateFormat("EEEE, d 'de' MMMM", 'es').format(now);

    final greeting = _greeting(now.hour);
    final fullName = userAsync.valueOrNull?.fullName ?? '';
    final firstName = fullName.trim().isNotEmpty
        ? fullName.trim().split(' ').first
        : (userAsync.valueOrNull?.email.split('@').first ?? 'tú');

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0D0D1A) : const Color(0xFFF8F5FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(
                greeting: greeting,
                firstName: firstName,
                dateStr: dateStr,
                isDark: isDark,
              ),
              const SizedBox(height: 20),
              _MotivationalBanner(isDark: isDark),
              const SizedBox(height: 20),
              _QuickMoodCard(isDark: isDark),
              const SizedBox(height: 24),
              _WeeklySummary(weeklyAsync: weeklyAsync, isDark: isDark),
              const SizedBox(height: 24),
              _RecentEmotionsSection(
                entriesAsync: entriesAsync,
                isDark: isDark,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _RegisterFab(),
      bottomNavigationBar: _MoodlyBottomNav(currentIndex: 0, isDark: isDark),
    );
  }

  static String _greeting(int hour) {
    if (hour >= 6 && hour < 12) return '☀️ Buenos días,';
    if (hour >= 12 && hour < 19) return '🌤️ Buenas tardes,';
    return '🌙 Buenas noches,';
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final String greeting;
  final String firstName;
  final String dateStr;
  final bool isDark;

  const _Header({
    required this.greeting,
    required this.firstName,
    required this.dateStr,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? const Color(0xFF9E9E9E)
                      : const Color(0xFF888888),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                firstName,
                style: GoogleFonts.syne(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                dateStr,
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  color: isDark
                      ? const Color(0xFF9E9E9E)
                      : const Color(0xFF888888),
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => context.go('/profile'),
          child: Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF9C27B0), Color(0xFF7B1FA2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF9C27B0).withValues(alpha: 0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Motivational banner ──────────────────────────────────────────────────────

class _MotivationalBanner extends ConsumerWidget {
  final bool isDark;

  static const _fallbackQuotes = [
    ('Cada emoción que sientes es válida.', '🌸'),
    ('Hoy es un buen día para conocerte mejor.', '✨'),
    ('Tu bienestar emocional importa. Cuídate.', '💜'),
    ('Registrar cómo te sientes es un acto de amor propio.', '🌟'),
    ('Eres más fuerte de lo que crees. Sigue adelante.', '🦋'),
    ('Pequeños pasos llevan a grandes cambios.', '🌱'),
    ('Mereces sentirte bien hoy y siempre.', '💫'),
  ];

  const _MotivationalBanner({required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final msgAsync = ref.watch(dailyMessageProvider);
    final fallback = _fallbackQuotes[DateTime.now().day % _fallbackQuotes.length];
    final dbMessage = msgAsync.valueOrNull ?? '';
    final text = dbMessage.isNotEmpty ? dbMessage : fallback.$1;
    final emoji = dbMessage.isNotEmpty ? '💜' : fallback.$2;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF3D1A5C), const Color(0xFF1E0D3A)]
              : [const Color(0xFFEDE0FF), const Color(0xFFD9C0FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark
              ? const Color(0xFF6A2FA0).withValues(alpha: 0.4)
              : const Color(0xFF9C27B0).withValues(alpha: 0.15),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 30)),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.dmSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF4A1F6E),
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Quick mood card ──────────────────────────────────────────────────────────

class _QuickMoodCard extends StatelessWidget {
  final bool isDark;
  const _QuickMoodCard({required this.isDark});

  static const _moods = [
    ('😊', 'Feliz'),
    ('😐', 'Neutral'),
    ('😢', 'Triste'),
    ('😤', 'Estresada'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF9C27B0), Color(0xFF6A1FA8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9C27B0).withValues(alpha: 0.4),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '¿Cómo te sientes ahora?',
                      style: GoogleFonts.syne(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Toca para registrar tu emoción',
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.75),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => context.go('/mood-checkin'),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    'Ver todo →',
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _moods.map((m) {
              final (emoji, label) = m;
              return GestureDetector(
                onTap: () => context.go('/mood-checkin'),
                child: Column(
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.25),
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 28),
                        ),
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      label,
                      style: GoogleFonts.dmSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ─── Weekly summary ───────────────────────────────────────────────────────────

class _WeeklySummary extends StatelessWidget {
  final AsyncValue<List<Map<String, dynamic>>> weeklyAsync;
  final bool isDark;
  const _WeeklySummary({required this.weeklyAsync, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final cardColor = isDark ? const Color(0xFF1E1E2E) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF2A2A3E) : const Color(0xFFF0F0F0);

    final entries = weeklyAsync.valueOrNull ?? [];
    final count = entries.length;

    String topMoodEmoji = '💜';
    String topMoodName = 'Sin datos';
    if (entries.isNotEmpty) {
      final freq = <String, int>{};
      for (final e in entries) {
        final name = (e['mood'] as Map?)?['name'] as String? ?? '';
        freq[name] = (freq[name] ?? 0) + 1;
      }
      final topEntry = freq.entries.reduce((a, b) => a.value >= b.value ? a : b);
      topMoodName = topEntry.key;
      final topMoodData = (entries.firstWhere(
        (e) => (e['mood'] as Map?)?['name'] == topMoodName,
        orElse: () => {},
      )['mood'] as Map?);
      topMoodEmoji = topMoodData?['emoji'] as String? ?? '💜';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Esta semana',
              style: GoogleFonts.syne(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1A1A2E),
              ),
            ),
            GestureDetector(
              onTap: () => context.go('/stats'),
              child: Text(
                'Ver estadísticas →',
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF9C27B0),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                emoji: '📝',
                value: count > 0 ? '$count' : '—',
                label: 'Registros\nesta semana',
                gradientColors: [
                  const Color(0xFF9C27B0).withValues(alpha: isDark ? 0.25 : 0.1),
                  const Color(0xFF7B1FA2).withValues(alpha: isDark ? 0.15 : 0.05),
                ],
                valueColor: const Color(0xFF9C27B0),
                cardColor: cardColor,
                borderColor: borderColor,
                isDark: isDark,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SummaryCard(
                emoji: topMoodEmoji,
                value: topMoodName,
                label: 'Emoción más\nfrecuente',
                gradientColors: [
                  const Color(0xFFF48FB1).withValues(alpha: isDark ? 0.25 : 0.1),
                  const Color(0xFFE91E8C).withValues(alpha: isDark ? 0.15 : 0.05),
                ],
                valueColor: const Color(0xFFE91E8C),
                cardColor: cardColor,
                borderColor: borderColor,
                isDark: isDark,
                smallValue: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String emoji;
  final String value;
  final String label;
  final List<Color> gradientColors;
  final Color valueColor;
  final Color cardColor;
  final Color borderColor;
  final bool isDark;
  final bool smallValue;

  const _SummaryCard({
    required this.emoji,
    required this.value,
    required this.label,
    required this.gradientColors,
    required this.valueColor,
    required this.cardColor,
    required this.borderColor,
    required this.isDark,
    this.smallValue = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 26)),
          const SizedBox(height: 10),
          Text(
            value,
            style: GoogleFonts.syne(
              fontSize: smallValue ? 16 : 28,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 11,
              color: isDark ? const Color(0xFF9E9E9E) : const Color(0xFF888888),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Recent emotions ──────────────────────────────────────────────────────────

class _RecentEmotionsSection extends StatelessWidget {
  final AsyncValue entriesAsync;
  final bool isDark;

  const _RecentEmotionsSection({
    required this.entriesAsync,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Emociones recientes',
              style: GoogleFonts.syne(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1A1A2E),
              ),
            ),
            GestureDetector(
              onTap: () => context.go('/mood-history'),
              child: Text(
                'Ver todo →',
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF9C27B0),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        entriesAsync.when(
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (_, _) => _EmptyEmotionsCard(isDark: isDark),
          data: (entries) {
            final list = entries is List ? entries : [];
            if (list.isEmpty) return _EmptyEmotionsCard(isDark: isDark);
            return Column(
              children: list.take(3).map<Widget>((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _EmotionCard(entry: entry, isDark: isDark),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}

class _EmotionCard extends StatelessWidget {
  final dynamic entry;
  final bool isDark;
  const _EmotionCard({required this.entry, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final cardColor = isDark ? const Color(0xFF1E1E2E) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF2A2A3E) : const Color(0xFFF0F0F0);
    final emoji = entry.mood?.emoji ?? '🙂';
    final name = entry.mood?.name ?? 'Emoción';
    final createdAt = entry.createdAt as DateTime;
    final time = DateFormat('HH:mm').format(createdAt);
    final day = _dayLabel(createdAt);
    final hasThought =
        entry.thought != null && (entry.thought as String).isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
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
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFF9C27B0).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 26)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.syne(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$day · $time',
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
          if (hasThought)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFF9C27B0).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '📝',
                style: const TextStyle(fontSize: 14),
              ),
            ),
        ],
      ),
    );
  }

  String _dayLabel(DateTime dt) {
    final now = DateTime.now();
    if (dt.day == now.day && dt.month == now.month) return 'Hoy';
    if (dt.day == now.day - 1 && dt.month == now.month) return 'Ayer';
    return DateFormat('d MMM', 'es').format(dt);
  }
}

class _EmptyEmotionsCard extends StatelessWidget {
  final bool isDark;
  const _EmptyEmotionsCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark
              ? const Color(0xFF2A2A3E)
              : const Color(0xFFEDE0FF),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          const Text('🌱', style: TextStyle(fontSize: 44)),
          const SizedBox(height: 14),
          Text(
            'Aún no hay registros',
            style: GoogleFonts.syne(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white70 : const Color(0xFF444444),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Toca el botón + para registrar\ntu primera emoción del día',
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              fontSize: 13,
              color: isDark
                  ? const Color(0xFF9E9E9E)
                  : const Color(0xFF999999),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => context.go('/mood-checkin'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF9C27B0), Color(0xFF7B1FA2)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF9C27B0).withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                'Registrar mi primera emoción',
                style: GoogleFonts.syne(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── FAB ──────────────────────────────────────────────────────────────────────

class _RegisterFab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/mood-checkin'),
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 22),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF9C27B0), Color(0xFF7B1FA2)],
          ),
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF9C27B0).withValues(alpha: 0.45),
              blurRadius: 18,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add_rounded, color: Colors.white, size: 22),
            const SizedBox(width: 8),
            Text(
              'Registrar',
              style: GoogleFonts.syne(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
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
              _NavItem(icon: Icons.home_rounded, label: 'Inicio', index: 0, currentIndex: currentIndex, route: '/home', isDark: isDark),
              _NavItem(icon: Icons.emoji_emotions_outlined, label: 'Ánimo', index: 1, currentIndex: currentIndex, route: '/mood-checkin', isDark: isDark),
              _NavItem(icon: Icons.auto_stories_outlined, label: 'Guía', index: 2, currentIndex: currentIndex, route: '/consejos', isDark: isDark),
              _NavItem(icon: Icons.menu_book_outlined, label: 'Diario', index: 3, currentIndex: currentIndex, route: '/diary', isDark: isDark),
              _NavItem(icon: Icons.person_rounded, label: 'Perfil', index: 4, currentIndex: currentIndex, route: '/profile', isDark: isDark),
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF9C27B0).withValues(alpha: isDark ? 0.3 : 0.12)
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
                fontWeight:
                    selected ? FontWeight.w700 : FontWeight.w500,
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
