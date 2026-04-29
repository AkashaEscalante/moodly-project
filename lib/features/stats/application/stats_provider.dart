import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:moodly/features/stats/data/stats_repository.dart';
import 'package:moodly/features/stats/domain/wellness_model.dart';
import 'package:moodly/features/stats/domain/mood_stats_model.dart';

part 'stats_provider.g.dart';

@riverpod
SupabaseClient supabaseClient(SupabaseClientRef ref) {
  return Supabase.instance.client;
}

@riverpod
StatsRepository statsRepository(StatsRepositoryRef ref) {
  return StatsRepository(ref.watch(supabaseClientProvider));
}

@riverpod
Future<MoodStats> weeklyStats(WeeklyStatsRef ref, String userId) async {
  final repo = ref.watch(statsRepositoryProvider);
  return repo.fetchWeeklyStats(userId);
}

@riverpod
Future<WellnessData> wellness(WellnessRef ref, String userId) async {
  final repo = ref.watch(statsRepositoryProvider);
  return repo.fetchWellnessData(userId);
}
