import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:moodly/features/mood/data/mood_repository.dart';
import 'package:moodly/features/mood/domain/mood_model.dart';
import 'package:moodly/features/mood/domain/activity_model.dart';
import 'package:moodly/features/mood/domain/mood_entry_model.dart';

part 'mood_provider.g.dart';

@riverpod
SupabaseClient supabaseClient(SupabaseClientRef ref) {
  return Supabase.instance.client;
}

@riverpod
MoodRepository moodRepository(MoodRepositoryRef ref) {
  return MoodRepository(ref.watch(supabaseClientProvider));
}

@riverpod
Future<List<MoodModel>> moods(MoodsRef ref) async {
  final repo = ref.watch(moodRepositoryProvider);
  return repo.fetchMoods();
}

@riverpod
Future<List<ActivityModel>> activities(ActivitiesRef ref) async {
  final repo = ref.watch(moodRepositoryProvider);
  return repo.fetchActivities();
}

@riverpod
Future<List<MoodEntryModel>> moodEntries(
  MoodEntriesRef ref,
  String userId,
) async {
  if (userId.isEmpty) return [];
  final repo = ref.watch(moodRepositoryProvider);
  return repo.fetchMoodEntries(userId);
}

final weeklyEntriesProvider = FutureProvider.family<List<Map<String, dynamic>>, String>(
  (ref, userId) async {
    if (userId.isEmpty) return [];
    final repo = ref.watch(moodRepositoryProvider);
    return repo.fetchWeeklyEntries(userId);
  },
);
