import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:moodly/core/widgets/shimmer_loader.dart';
import 'package:moodly/features/mood/application/mood_entry_notifier.dart';
import 'package:moodly/features/mood/application/mood_provider.dart';
import 'package:moodly/features/mood/domain/activity_model.dart';
import 'package:moodly/features/mood/domain/mood_model.dart';
import 'package:moodly/features/diary/application/diary_provider.dart';
import 'package:moodly/features/mood/presentation/widgets/activity_chip_list.dart';
import 'package:moodly/features/mood/presentation/widgets/mood_selector_grid.dart';
import 'package:moodly/features/mood/presentation/widgets/thought_input_field.dart';
import 'package:moodly/features/premium/application/premium_provider.dart';
import 'package:moodly/features/premium/presentation/premium_gate_modal.dart';

// Provider for passing diary text from _DiarySection to _SaveButton
final _diaryTextProvider = StateProvider<String>((ref) => '');

class MoodCheckinScreen extends ConsumerWidget {
  const MoodCheckinScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moodsAsync = ref.watch(moodsProvider);
    final activitiesAsync = ref.watch(activitiesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF0D0D1A) : const Color(0xFFFFF5F8);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.chevron_left_rounded,
              color: isDark ? Colors.white : const Color(0xFF555555),
            ),
          ),
        ),
        title: Text(
          'Registro de Ánimo',
          style: GoogleFonts.syne(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF333333),
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(
                Icons.favorite_border_rounded,
                color: Color(0xFFF4A0C0),
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: moodsAsync.when(
        loading: () => const ShimmerLoader(),
        error: (_, _) => activitiesAsync.when(
          loading: () => const ShimmerLoader(),
          error: (_, _) => _MoodCheckinContent(
            moods: const [],
            activities: const [],
            isDark: isDark,
          ),
          data: (activities) => _MoodCheckinContent(
            moods: const [],
            activities: activities,
            isDark: isDark,
          ),
        ),
        data: (moods) => activitiesAsync.when(
          loading: () => const ShimmerLoader(),
          error: (_, _) => _MoodCheckinContent(
            moods: moods,
            activities: const [],
            isDark: isDark,
          ),
          data: (activities) => _MoodCheckinContent(
            moods: moods,
            activities: activities,
            isDark: isDark,
          ),
        ),
      ),
    );
  }
}

class _MoodCheckinContent extends ConsumerWidget {
  final List<MoodModel> moods;
  final List<ActivityModel> activities;
  final bool isDark;

  const _MoodCheckinContent({
    required this.moods,
    required this.activities,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    '¿Cómo te sientes? ✨',
                    style: GoogleFonts.syne(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF333333),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Center(
                  child: Text(
                    'Elige el color de tu energía hoy',
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      color: isDark
                          ? const Color(0xFF9E9E9E)
                          : const Color(0xFF999999),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                MoodSelectorGrid(moods: moods),
                const SizedBox(height: 28),
                _MoodInsight(isDark: isDark),
                const SizedBox(height: 28),
                _IntensitySelector(isDark: isDark),
                const SizedBox(height: 28),
                Text(
                  '✨ ¿Qué has hecho hoy?',
                  style: GoogleFonts.syne(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 14),
                ActivityChipList(activities: activities),
                const SizedBox(height: 28),
                Text(
                  'Un pensamiento dulce...',
                  style: GoogleFonts.syne(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 14),
                const ThoughtInputField(),
                const SizedBox(height: 28),
                _DiarySection(isDark: isDark),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
        _SaveButton(isDark: isDark),
      ],
    );
  }
}

// ─── Mood Insight (conversación corta) ─────────────────────────────────────

class _MoodInsight extends ConsumerWidget {
  final bool isDark;
  const _MoodInsight({required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entryState = ref.watch(moodEntryNotifierProvider);
    final mood = entryState.selectedMood;

    if (mood == null) {
      return const SizedBox.shrink();
    }

    final insight = _getInsightForMood(mood.name, mood.category);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF9C27B0).withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF9C27B0).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.psychology_rounded,
              color: Color(0xFF9C27B0),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '💭',
                  style: GoogleFonts.syne(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF9C27B0),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  insight,
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    color: isDark
                        ? const Color(0xFFCCCCCC)
                        : const Color(0xFF555555),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getInsightForMood(String moodName, String? category) {
    final insights = {
      'Feliz': [
        '¡Qué bueno que te sientes así! Recuerda que compartir tu alegría multiplica la felicidad. 🌟',
        'Tu energía positiva es contagiosa. ¿Por qué no le dices a alguien que lo aprecias?',
      ],
      'Triste': [
        'Está bien sentirse así a veces. Respira profundo y recuerda que este momento pasará. 💜',
        '¿Sabías que llorar libera tensiones? Si necesitas hablar, aquí estoy.',
      ],
      'Neutral': [
        'Los días estables son perfectos para reflexionar. ¿Qué te gustaría lograr hoy?',
        'Un momento平静 es una oportunidad para conectar contigo mismo.',
      ],
      'Enamorado': [
        '¡El amor nos llena de energía! ¿Por qué no le dedicas un momento a esa persona especial?',
        'El amor propio también cuenta. ¿Cómo te estás cuidando hoy? 💕',
      ],
      'Enojado': [
        'El enojo es válido. Antes de actuar, cuenta hasta 10 y respira. Así proteges tu paz.',
        'Expresar lo que sientes está bien. Escribe lo que te molesta y luego lo relees.',
      ],
      'Relajado': [
        '¡Qué buen momento para disfrutar! Mantén esta calma todo lo que puedas. ☕',
        'Aprovecha esta paz mental para planificar algo que te haga feliz.',
      ],
      'Ansioso': [
        'La ansiedad pasa. Enfócate en tu respiración: inhale... exhale... Estás bien. 🌿',
        'Un paso a la vez. No pienses en todo junto, solo en el siguiente momento.',
      ],
      'Cansado': [
        'Descansar no es perder el tiempo. Tu cuerpo te pide una pausa. 💤',
        'Si puedes, échate un rato. El sueño repara cuerpo y mente.',
      ],
    };

    final moodInsights =
        insights[moodName] ??
        ['Todos los sentimientos son válidos. Lo importante es aceptarlos.'];

    final index = DateTime.now().millisecond % moodInsights.length;
    return moodInsights[index];
  }
}

// ─── Intensity selector ───────────────────────────────────────────────────────

class _IntensitySelector extends ConsumerStatefulWidget {
  final bool isDark;
  const _IntensitySelector({required this.isDark});

  @override
  ConsumerState<_IntensitySelector> createState() => _IntensitySelectorState();
}

class _IntensitySelectorState extends ConsumerState<_IntensitySelector> {
  @override
  Widget build(BuildContext context) {
    final entryState = ref.watch(moodEntryNotifierProvider);
    final currentIntensity = entryState.intensity;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '🌡️ Intensidad',
              style: GoogleFonts.syne(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: widget.isDark ? Colors.white : const Color(0xFF333333),
              ),
            ),
            Text(
              '$currentIntensity / 5',
              style: GoogleFonts.dmSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFF48FB1),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(5, (index) {
            final level = index + 1;
            final selected = level <= currentIntensity;
            return GestureDetector(
              onTap: () => ref
                  .read(moodEntryNotifierProvider.notifier)
                  .setIntensity(level),
              child: AnimatedScale(
                scale: selected ? 1.18 : 1.0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutBack,
                child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  gradient: selected
                      ? const LinearGradient(
                          colors: [Color(0xFFF48FB1), Color(0xFFE91E8C)],
                        )
                      : null,
                  color: selected
                      ? null
                      : (widget.isDark
                            ? const Color(0xFF1E1E2E)
                            : Colors.white),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected
                        ? Colors.transparent
                        : (widget.isDark
                              ? const Color(0xFF2A2A3E)
                              : const Color(0xFFEEEEEE)),
                    width: 2,
                  ),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: const Color(
                              0xFFE91E8C,
                            ).withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    '$level',
                    style: GoogleFonts.syne(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: selected
                          ? Colors.white
                          : (widget.isDark
                                ? const Color(0xFF555555)
                                : const Color(0xFFCCCCCC)),
                    ),
                  ),
                ),
              ),   // cierra AnimatedContainer
              ),   // cierra AnimatedScale
            );
          }),
        ),
      ],
    );
  }
}

// ─── Save button ──────────────────────────────────────────────────────────────

class _SaveButton extends ConsumerStatefulWidget {
  final bool isDark;
  const _SaveButton({required this.isDark});

  @override
  ConsumerState<_SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends ConsumerState<_SaveButton> {
  bool _loading = false;

  Future<void> _save() async {
    final entryState = ref.read(moodEntryNotifierProvider);

    if (entryState.selectedMood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Primero selecciona cómo te sientes 💜',
            style: GoogleFonts.dmSans(fontWeight: FontWeight.w600),
          ),
          backgroundColor: const Color(0xFF9C27B0),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
      return;
    }

    // Usamos Supabase directamente — authStateProvider.valueOrNull puede ser
    // null si el Future aún no resolvió, causando un return silencioso.
    final userId = Supabase.instance.client.auth.currentUser?.id ?? '';
    if (userId.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Debes iniciar sesión para guardar tu registro.',
              style: GoogleFonts.dmSans(fontWeight: FontWeight.w600),
            ),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
      return;
    }

    setState(() => _loading = true);

    try {
      await ref
          .read(moodRepositoryProvider)
          .saveMoodEntry(
            userId: userId,
            moodId: entryState.selectedMood!.id,
            thought: entryState.thought,
            activityIds: entryState.selectedActivities
                .map((a) => a.id)
                .toList(),
            intensity: entryState.intensity,
          );

      ref.read(moodEntryNotifierProvider.notifier).reset();
      ref.invalidate(moodEntriesProvider(userId));
      ref.invalidate(weeklyEntriesProvider(userId));

      // Also save diary entry if user wrote something
      final diaryText = ref.read(_diaryTextProvider).trim();
      if (diaryText.isNotEmpty) {
        await ref.read(diaryRepositoryProvider).saveEntry(
          userId: userId,
          content: diaryText,
          moodIcon: entryState.selectedMood?.emoji,
        );
        ref.invalidate(gratitudeEntriesProvider(userId));
        ref.invalidate(todayEntryProvider(userId));
        ref.read(_diaryTextProvider.notifier).state = '';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '¡Registro guardado! 🐱',
              style: GoogleFonts.dmSans(fontWeight: FontWeight.w600),
            ),
            backgroundColor: const Color(0xFFF48FB1),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar: $e'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bg = widget.isDark
        ? const Color(0xFF0D0D1A)
        : const Color(0xFFFFF5F8);
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      decoration: BoxDecoration(
        color: bg,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF4A0C0).withValues(alpha: 0.15),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: _loading
                ? null
                : const LinearGradient(
                    colors: [Color(0xFFF48FB1), Color(0xFFE91E8C)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
            color: _loading ? Colors.grey[300] : null,
            borderRadius: BorderRadius.circular(28),
            boxShadow: _loading
                ? []
                : [
                    BoxShadow(
                      color: const Color(0xFFE91E8C).withValues(alpha: 0.3),
                      blurRadius: 18,
                      offset: const Offset(0, 7),
                    ),
                  ],
          ),
          child: ElevatedButton(
            onPressed: _loading ? null : _save,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: _loading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Text(
                    '✨ Guardar Registro',
                    style: GoogleFonts.syne(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

// ─── Diary section ────────────────────────────────────────────────────────────

class _DiarySection extends ConsumerStatefulWidget {
  final bool isDark;
  const _DiarySection({required this.isDark});

  @override
  ConsumerState<_DiarySection> createState() => _DiarySectionState();
}

class _DiarySectionState extends ConsumerState<_DiarySection> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPremium = ref.watch(isPremiumProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '📔 Tu momento del día',
              style: GoogleFonts.syne(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: widget.isDark ? Colors.white : const Color(0xFF333333),
              ),
            ),
            const SizedBox(width: 8),
            if (!isPremium)
              GestureDetector(
                onTap: () => showPremiumGate(context, feature: 'Análisis de emociones con IA'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF80AB), Color(0xFF9C27B0)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '✨ Premium',
                    style: GoogleFonts.dmSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'Opcional · Se guardará junto con tu emoción',
          style: GoogleFonts.dmSans(
            fontSize: 12,
            color: widget.isDark
                ? const Color(0xFF9E9E9E)
                : const Color(0xFF999999),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: widget.isDark ? const Color(0xFF1E1E2E) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.isDark
                  ? const Color(0xFF2A2A3E)
                  : const Color(0xFFEEEEEE),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _ctrl,
            maxLines: 4,
            textCapitalization: TextCapitalization.sentences,
            onChanged: (val) =>
                ref.read(_diaryTextProvider.notifier).state = val,
            style: GoogleFonts.dmSans(
              fontSize: 14,
              color: widget.isDark ? Colors.white : const Color(0xFF333333),
              height: 1.6,
            ),
            decoration: InputDecoration(
              hintText: 'Escribe algo sobre cómo fue tu día...',
              hintStyle: GoogleFonts.dmSans(
                fontSize: 14,
                color: widget.isDark
                    ? const Color(0xFF555566)
                    : const Color(0xFFCCCCCC),
              ),
              contentPadding: const EdgeInsets.all(16),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
