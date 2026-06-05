import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moodly/features/mood/application/mood_entry_notifier.dart';
import 'package:moodly/features/mood/domain/activity_model.dart';

class ActivityChipList extends ConsumerWidget {
  const ActivityChipList({super.key, required this.activities});

  final List<ActivityModel> activities;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedActivities = ref.watch(moodEntryNotifierProvider).selectedActivities;
    final displayActivities = activities.isNotEmpty ? activities : _defaultActivities;

    final unselectedBg = isDark ? const Color(0xFF1E1E2E) : Colors.white;
    final unselectedBorder = isDark ? const Color(0xFF2A2A3E) : const Color(0xFFE8E8E8);
    final unselectedText = isDark ? const Color(0xFFCCCCCC) : const Color(0xFF555555);

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: displayActivities.map((activity) {
        final isSelected = selectedActivities.any((a) => a.id == activity.id);
        final emoji = _activityEmoji(activity.name);

        return GestureDetector(
          onTap: () =>
              ref.read(moodEntryNotifierProvider.notifier).toggleActivity(activity),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFF4A0C0) : unselectedBg,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isSelected ? const Color(0xFFF4A0C0) : unselectedBorder,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? const Color(0xFFF4A0C0).withValues(alpha: 0.3)
                      : Colors.black.withValues(alpha: isDark ? 0.15 : 0.04),
                  blurRadius: isSelected ? 10 : 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 6),
                Text(
                  activity.name,
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : unselectedText,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  static List<ActivityModel> get _defaultActivities => [
    const ActivityModel(id: 1, name: 'Trabajo', colorCode: '#F9A87B'),
    const ActivityModel(id: 2, name: 'Comida', colorCode: '#A8D8A8'),
    const ActivityModel(id: 3, name: 'Hobbies', colorCode: '#C4C8E8'),
    const ActivityModel(id: 4, name: 'Familia', colorCode: '#B8A8D8'),
    const ActivityModel(id: 5, name: 'Pareja', colorCode: '#F4A0A0'),
    const ActivityModel(id: 6, name: 'Descanso', colorCode: '#A8D8C8'),
  ];
}

String _activityEmoji(String name) {
  switch (name.toLowerCase()) {
    case 'trabajo':
      return '💼';
    case 'comida':
      return '🍕';
    case 'hobbies':
      return '🎨';
    case 'familia':
      return '🏠';
    case 'pareja':
      return '❤️';
    case 'descanso':
      return '💤';
    case 'ejercicio':
      return '🏃';
    case 'música':
    case 'musica':
      return '🎵';
    case 'naturaleza':
      return '🌿';
    default:
      return '⭐';
  }
}
