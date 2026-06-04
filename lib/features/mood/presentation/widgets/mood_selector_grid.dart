import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moodly/features/mood/application/mood_entry_notifier.dart';
import 'package:moodly/features/mood/domain/mood_model.dart';

class MoodSelectorGrid extends ConsumerWidget {
  const MoodSelectorGrid({super.key, required this.moods});

  final List<MoodModel> moods;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMood = ref.watch(moodEntryNotifierProvider).selectedMood;
    final displayMoods = moods.isNotEmpty ? moods : _defaultMoods;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.88,
      ),
      itemCount: displayMoods.length,
      itemBuilder: (context, index) {
        final mood = displayMoods[index];
        final isSelected = selectedMood?.id == mood.id;
        final baseColor = _hexToColor(mood.colorHex);
        final bgColor = baseColor.withValues(alpha: 0.2);

        return GestureDetector(
          onTap: () => ref.read(moodEntryNotifierProvider.notifier).selectMood(mood),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected ? baseColor.withValues(alpha: 0.35) : bgColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? baseColor : Colors.transparent,
                width: 2.5,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: baseColor.withValues(alpha: 0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: Builder(
              builder: (ctx) {
                final isDark = Theme.of(ctx).brightness == Brightness.dark;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(mood.emoji, style: const TextStyle(fontSize: 36)),
                    const SizedBox(height: 8),
                    Text(
                      mood.name.toUpperCase(),
                      style: GoogleFonts.dmSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? (isDark ? Colors.white : const Color(0xFF222222))
                            : (isDark ? const Color(0xFFCCCCCC) : const Color(0xFF444444)),
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  static List<MoodModel> get _defaultMoods => const [
    MoodModel(id: 1, name: 'Feliz',       emoji: '😊', colorHex: '#FFE8A3', category: 'positive'),
    MoodModel(id: 2, name: 'Triste',      emoji: '😢', colorHex: '#A8C5E6', category: 'negative'),
    MoodModel(id: 3, name: 'Neutral',     emoji: '😐', colorHex: '#D4D4E0', category: 'neutral'),
    MoodModel(id: 4, name: 'Enamorado',   emoji: '💗', colorHex: '#FFB3C6', category: 'positive'),
    MoodModel(id: 5, name: 'Enojado',     emoji: '😠', colorHex: '#FF9B9B', category: 'negative'),
    MoodModel(id: 6, name: 'Relajado',    emoji: '☕', colorHex: '#A8E6CF', category: 'positive'),
  ];
}

Color _hexToColor(String hex) {
  final clean = hex.replaceFirst('#', '');
  final full = clean.length == 6 ? 'FF$clean' : clean;
  return Color(int.parse(full, radix: 16));
}
