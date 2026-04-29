import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:moodly/core/widgets/shimmer_loader.dart';
import 'package:moodly/features/auth/application/auth_provider.dart' show authStateProvider;
import 'package:moodly/features/diary/application/diary_provider.dart';
import 'package:moodly/features/diary/domain/gratitude_entry_model.dart';

class DiaryScreen extends ConsumerStatefulWidget {
  const DiaryScreen({super.key});

  @override
  ConsumerState<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends ConsumerState<DiaryScreen> {
  final _controller = TextEditingController();
  String? _selectedEmoji;
  bool _saving = false;
  bool _initialized = false;

  static const _moods = [
    ('😊', 'Feliz'),
    ('🙂', 'Bien'),
    ('😐', 'Normal'),
    ('😔', 'Triste'),
    ('😟', 'Mal'),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userId = ref.watch(authStateProvider).valueOrNull?.id ?? '';

    final entriesAsync = userId.isNotEmpty
        ? ref.watch(gratitudeEntriesProvider(userId))
        : const AsyncValue<List<GratitudeEntry>>.data([]);
    final todayAsync = userId.isNotEmpty
        ? ref.watch(todayEntryProvider(userId))
        : const AsyncValue<GratitudeEntry?>.data(null);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0D0D1A) : const Color(0xFFFAF8F5),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF0D0D1A) : const Color(0xFFFAF8F5),
        elevation: 0,
        title: Column(
          children: [
            Text(
              'Mi Diario',
              style: GoogleFonts.dancingScript(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF333333),
              ),
            ),
            Text(
              DateFormat("EEEE, d 'de' MMMM", 'es').format(DateTime.now()),
              style: GoogleFonts.dmSans(
                fontSize: 11,
                color: isDark ? const Color(0xFF9E9E9E) : const Color(0xFF999999),
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: entriesAsync.when(
        loading: () => const ShimmerLoader(),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (entries) => todayAsync.when(
          loading: () => const ShimmerLoader(),
          error: (e, _) => Center(child: Text(e.toString())),
          data: (today) => _buildContent(entries, today, userId, isDark),
        ),
      ),
      bottomNavigationBar: _MoodlyBottomNav(currentIndex: 3, isDark: isDark),
    );
  }

  Widget _buildContent(
    List<GratitudeEntry> entries,
    GratitudeEntry? today,
    String userId,
    bool isDark,
  ) {
    if (!_initialized && today != null) {
      _controller.text = today.content;
      _selectedEmoji = today.moodIcon;
      _initialized = true;
    }

    // Filter out today's entry from the past entries list
    final pastEntries = entries.where((e) {
      final todayStr = DateTime.now().toIso8601String().split('T')[0];
      return e.entryDate.toIso8601String().split('T')[0] != todayStr;
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _WritingCard(
            isDark: isDark,
            controller: _controller,
            selectedEmoji: _selectedEmoji,
            saving: _saving,
            existingEntry: today,
            moods: _moods,
            onEmojiSelected: (e) => setState(() => _selectedEmoji = e),
            onSave: () => _save(userId, today),
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              const Icon(Icons.menu_book_outlined, size: 20, color: Color(0xFF9C27B0)),
              const SizedBox(width: 8),
              Text(
                'Entradas anteriores',
                style: GoogleFonts.syne(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF333333),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (pastEntries.isEmpty && today == null)
            _EmptyState(isDark: isDark)
          else if (pastEntries.isEmpty)
            _FirstEntryHint(isDark: isDark)
          else
            ...pastEntries.asMap().entries.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _EntryCard(entry: e.value, colorIndex: e.key, isDark: isDark),
            )),
        ],
      ),
    );
  }

  Future<void> _save(String userId, GratitudeEntry? existing) async {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Escribe algo primero ✏️',
            style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
        backgroundColor: const Color(0xFF9C27B0),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ));
      return;
    }
    if (userId.isEmpty) return;

    setState(() => _saving = true);
    try {
      await ref.read(diaryRepositoryProvider).saveEntry(
        userId: userId,
        content: text,
        moodIcon: _selectedEmoji,
        existingId: existing?.id,
      );
      ref.invalidate(gratitudeEntriesProvider(userId));
      ref.invalidate(todayEntryProvider(userId));
      setState(() => _initialized = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('¡Entrada guardada 📖',
              style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
          backgroundColor: const Color(0xFF4CAF50),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error al guardar: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}

// ─── Writing Card ─────────────────────────────────────────────────────────────

class _WritingCard extends StatelessWidget {
  final bool isDark;
  final TextEditingController controller;
  final String? selectedEmoji;
  final bool saving;
  final GratitudeEntry? existingEntry;
  final List<(String, String)> moods;
  final ValueChanged<String> onEmojiSelected;
  final VoidCallback onSave;

  const _WritingCard({
    required this.isDark,
    required this.controller,
    required this.selectedEmoji,
    required this.saving,
    required this.existingEntry,
    required this.moods,
    required this.onEmojiSelected,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = isDark ? const Color(0xFF1E1E2E) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF333333);
    final textSecondary = isDark ? const Color(0xFF9E9E9E) : const Color(0xFF999999);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.07),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF9C27B0).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  existingEntry != null ? 'Editando hoy' : 'Nueva entrada',
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF9C27B0),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '¿Cómo te sientes hoy?',
            style: GoogleFonts.dancingScript(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          // Mood emoji selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: moods.map((m) {
              final isSelected = selectedEmoji == m.$1;
              return GestureDetector(
                onTap: () => onEmojiSelected(m.$1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF9C27B0).withValues(alpha: isDark ? 0.3 : 0.12)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: isSelected
                        ? Border.all(color: const Color(0xFF9C27B0), width: 1.5)
                        : Border.all(color: Colors.transparent),
                  ),
                  child: Column(
                    children: [
                      Text(m.$1, style: const TextStyle(fontSize: 24)),
                      const SizedBox(height: 2),
                      Text(
                        m.$2,
                        style: GoogleFonts.dmSans(
                          fontSize: 10,
                          color: isSelected
                              ? const Color(0xFF9C27B0)
                              : textSecondary,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Container(
            height: 1,
            color: isDark ? const Color(0xFF2A2A3E) : const Color(0xFFF0F0F0),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            maxLines: 6,
            style: GoogleFonts.dmSans(
              fontSize: 14,
              color: textPrimary,
              height: 1.6,
            ),
            decoration: InputDecoration(
              hintText: 'Escribe cómo te sientes, qué pasó hoy, lo que piensas...',
              hintStyle: GoogleFonts.dmSans(
                fontSize: 14,
                color: isDark ? const Color(0xFF555566) : const Color(0xFFCCCCCC),
                fontStyle: FontStyle.italic,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: saving ? null : onSave,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 11),
                decoration: BoxDecoration(
                  gradient: saving
                      ? null
                      : const LinearGradient(
                          colors: [Color(0xFF9C27B0), Color(0xFF7B1FA2)],
                        ),
                  color: saving ? Colors.grey.shade300 : null,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: saving
                      ? []
                      : [
                          BoxShadow(
                            color: const Color(0xFF9C27B0).withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                ),
                child: saving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        existingEntry != null ? 'ACTUALIZAR' : 'GUARDAR',
                        style: GoogleFonts.dmSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Entry Card (post-it style) ───────────────────────────────────────────────

class _EntryCard extends StatelessWidget {
  final GratitudeEntry entry;
  final int colorIndex;
  final bool isDark;

  static const _lightBg = [
    Color(0xFFFCE4EC),
    Color(0xFFEDE7F6),
    Color(0xFFE0F7FA),
    Color(0xFFF3E5F5),
    Color(0xFFE8F5E9),
    Color(0xFFFFF8E1),
  ];

  static const _darkBg = [
    Color(0xFF3D1020),
    Color(0xFF2A1A45),
    Color(0xFF0D2D30),
    Color(0xFF2D1040),
    Color(0xFF0D2D1A),
    Color(0xFF2D2000),
  ];

  static const _iconColors = [
    Color(0xFFF48FB1),
    Color(0xFFCE93D8),
    Color(0xFF4DB6AC),
    Color(0xFF9575CD),
    Color(0xFF81C784),
    Color(0xFFFFD54F),
  ];

  static const _icons = [
    Icons.favorite_rounded,
    Icons.auto_awesome_rounded,
    Icons.eco_rounded,
    Icons.celebration_rounded,
    Icons.local_florist_rounded,
    Icons.wb_sunny_rounded,
  ];

  const _EntryCard({required this.entry, required this.colorIndex, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final idx = colorIndex % _lightBg.length;
    final bg = isDark ? _darkBg[idx] : _lightBg[idx];
    final dateStr = DateFormat("d 'de' MMMM, yyyy", 'es').format(entry.entryDate);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (entry.moodIcon != null) ...[
                    Text(entry.moodIcon!, style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    dateStr,
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: isDark ? const Color(0xFF9E9E9E) : const Color(0xFF888888),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              Icon(_icons[idx], size: 18, color: _iconColors[idx]),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '"${entry.content}"',
            style: GoogleFonts.dancingScript(
              fontSize: 17,
              color: isDark ? Colors.white.withValues(alpha: 0.85) : const Color(0xFF444444),
              height: 1.5,
            ),
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ─── Empty state ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final bool isDark;
  const _EmptyState({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A1040) : const Color(0xFFF3E5F5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text('📖', style: TextStyle(fontSize: 40)),
          const SizedBox(height: 12),
          Text(
            'Tu diario está vacío',
            style: GoogleFonts.syne(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF555555),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Empieza a escribir cómo te sientes.\nTu diario es solo tuyo ✨',
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              fontSize: 13,
              color: isDark ? const Color(0xFF9E9E9E) : const Color(0xFF999999),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _FirstEntryHint extends StatelessWidget {
  final bool isDark;
  const _FirstEntryHint({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : const Color(0xFFEDE7F6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        'Las entradas de días anteriores aparecerán aquí 🗓️',
        textAlign: TextAlign.center,
        style: GoogleFonts.dmSans(
          fontSize: 13,
          color: isDark ? const Color(0xFF9E9E9E) : const Color(0xFF888888),
          fontStyle: FontStyle.italic,
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
