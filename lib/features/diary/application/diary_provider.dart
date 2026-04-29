import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:moodly/features/diary/data/diary_repository.dart';
import 'package:moodly/features/diary/domain/gratitude_entry_model.dart';

part 'diary_provider.g.dart';

@riverpod
SupabaseClient supabaseClient(SupabaseClientRef ref) {
  return Supabase.instance.client;
}

@riverpod
DiaryRepository diaryRepository(DiaryRepositoryRef ref) {
  return DiaryRepository(ref.watch(supabaseClientProvider));
}

@riverpod
Future<List<GratitudeEntry>> gratitudeEntries(
  GratitudeEntriesRef ref,
  String userId,
) async {
  final repo = ref.watch(diaryRepositoryProvider);
  return repo.fetchGratitudeEntries(userId);
}

@riverpod
Future<GratitudeEntry?> todayEntry(TodayEntryRef ref, String userId) async {
  final repo = ref.watch(diaryRepositoryProvider);
  return repo.fetchTodayEntry(userId);
}
