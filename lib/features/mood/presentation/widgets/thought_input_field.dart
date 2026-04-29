import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moodly/features/mood/application/mood_entry_notifier.dart';

class ThoughtInputField extends ConsumerWidget {
  const ThoughtInputField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        onChanged: (value) =>
            ref.read(moodEntryNotifierProvider.notifier).setThought(value),
        maxLines: 5,
        style: GoogleFonts.dmSans(
          fontSize: 15,
          color: const Color(0xFF444444),
          height: 1.6,
        ),
        decoration: InputDecoration(
          hintText: 'Escribe aquí...',
          hintStyle: GoogleFonts.dmSans(
            fontSize: 15,
            color: const Color(0xFFCCCCCC),
          ),
          contentPadding: const EdgeInsets.all(18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Color(0xFFEEEEEE), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Color(0xFFF4A0C0), width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
