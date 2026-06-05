import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moodly/features/mood/application/mood_entry_notifier.dart';

class ThoughtInputField extends ConsumerWidget {
  const ThoughtInputField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF1E1E2E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF444444);
    final hintColor = isDark ? const Color(0xFF555566) : const Color(0xFFCCCCCC);
    final enabledBorder = isDark ? const Color(0xFF2A2A3E) : const Color(0xFFEEEEEE);

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: enabledBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        onChanged: (value) =>
            ref.read(moodEntryNotifierProvider.notifier).setThought(value),
        maxLines: 5,
        style: GoogleFonts.dmSans(fontSize: 15, color: textColor, height: 1.6),
        decoration: InputDecoration(
          hintText: 'Escribe aquí...',
          hintStyle: GoogleFonts.dmSans(fontSize: 15, color: hintColor),
          contentPadding: const EdgeInsets.all(18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: enabledBorder, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Color(0xFFF4A0C0), width: 2),
          ),
          filled: true,
          fillColor: bg,
        ),
      ),
    );
  }
}
