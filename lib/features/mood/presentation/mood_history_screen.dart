import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:moodly/features/mood/application/mood_provider.dart';

class MoodHistoryScreen extends ConsumerStatefulWidget {
  const MoodHistoryScreen({super.key});

  @override
  ConsumerState<MoodHistoryScreen> createState() => _MoodHistoryScreenState();
}

class _MoodHistoryScreenState extends ConsumerState<MoodHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF0D0D1A) : const Color(0xFFF8F5FF);
    final entriesAsync = ref.watch(moodEntriesProvider('userId'));

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.canPop() ? context.pop() : context.go('/home'),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Icon(
              Icons.chevron_left_rounded,
              color: isDark ? Colors.white : const Color(0xFF555555),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Historial',
              style: GoogleFonts.syne(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF222222),
              ),
            ),
            Text(
              'Tu registro emocional',
              style: GoogleFonts.dmSans(
                fontSize: 12,
                color: isDark ? const Color(0xFF9E9E9E) : const Color(0xFF999999),
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: _TabSelector(controller: _tabController, isDark: isDark),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _TimelineTab(entriesAsync: entriesAsync, isDark: isDark),
          _StatsTab(isDark: isDark),
        ],
      ),
      bottomNavigationBar: _MoodlyBottomNav(currentIndex: 1, isDark: isDark),
    );
  }
}

// ─── Tab selector ─────────────────────────────────────────────────────────────

class _TabSelector extends StatelessWidget {
  final TabController controller;
  final bool isDark;
  const _TabSelector({required this.controller, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(
          color: isDark ? const Color(0xFF2A2A3E) : const Color(0xFFEEEEEE),
          width: 1.5,
        ),
      ),
      child: TabBar(
        controller: controller,
        indicator: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF9C27B0), Color(0xFF7B1FA2)],
          ),
          borderRadius: BorderRadius.circular(19),
        ),
        labelStyle: GoogleFonts.syne(fontSize: 13, fontWeight: FontWeight.w700),
        unselectedLabelStyle: GoogleFonts.syne(fontSize: 13),
        labelColor: Colors.white,
        unselectedLabelColor:
            isDark ? const Color(0xFF9E9E9E) : const Color(0xFFAAAAAA),
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: const [
          Tab(text: 'Línea de tiempo'),
          Tab(text: 'Estadísticas'),
        ],
      ),
    );
  }
}

// ─── Timeline tab ─────────────────────────────────────────────────────────────

class _TimelineTab extends StatelessWidget {
  final AsyncValue entriesAsync;
  final bool isDark;
  const _TimelineTab({required this.entriesAsync, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return entriesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => _EmptyHistory(isDark: isDark),
      data: (entries) {
        final list = entries is List ? entries : [];
        if (list.isEmpty) return _EmptyHistory(isDark: isDark);
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          itemCount: list.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _TimelineCard(entry: list[index], isDark: isDark),
          ),
        );
      },
    );
  }
}

class _TimelineCard extends StatelessWidget {
  final dynamic entry;
  final bool isDark;
  const _TimelineCard({required this.entry, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final cardColor = isDark ? const Color(0xFF1E1E2E) : Colors.white;
    final borderColor = isDark ? const Color(0xFF2A2A3E) : const Color(0xFFF0F0F0);
    final emoji = entry.mood?.emoji ?? '🙂';
    final name = entry.mood?.name ?? 'Emoción';
    final thought = (entry.thought ?? '') as String;
    final createdAt = entry.createdAt as DateTime;
    final dateStr = DateFormat("d 'de' MMMM", 'es').format(createdAt);
    final timeStr = DateFormat('HH:mm').format(createdAt);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 34)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.syne(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF222222),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$dateStr · $timeStr',
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
            ],
          ),
          if (thought.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF9C27B0).withValues(alpha: 0.1)
                    : const Color(0xFFF3E5F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                thought,
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  color: isDark
                      ? const Color(0xFFCCCCCC)
                      : const Color(0xFF555555),
                  height: 1.5,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  final bool isDark;
  const _EmptyHistory({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('📅', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 16),
            Text(
              'Sin registros aún',
              style: GoogleFonts.syne(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : const Color(0xFF555555),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Comienza a registrar tus emociones\npara ver tu historial aquí',
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(
                fontSize: 14,
                color: isDark ? const Color(0xFF9E9E9E) : const Color(0xFF999999),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            GestureDetector(
              onTap: () => context.go('/mood-checkin'),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF9C27B0), Color(0xFF7B1FA2)],
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF9C27B0).withValues(alpha: 0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Text(
                  'Registrar emoción',
                  style: GoogleFonts.syne(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Stats tab ────────────────────────────────────────────────────────────────

class _StatsTab extends StatelessWidget {
  final bool isDark;
  const _StatsTab({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('📊', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 16),
            Text(
              'Estadísticas detalladas',
              style: GoogleFonts.syne(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : const Color(0xFF555555),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Visualiza tus tendencias emocionales\na lo largo del tiempo',
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(
                fontSize: 14,
                color: isDark ? const Color(0xFF9E9E9E) : const Color(0xFF999999),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () => context.go('/stats'),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF9C27B0).withValues(alpha: 0.2)
                      : const Color(0xFFF3E5F5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Ver estadísticas completas →',
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF9C27B0),
                  ),
                ),
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
