import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:moodly/features/stats/domain/wellness_model.dart';
import 'package:moodly/features/stats/domain/mood_stats_model.dart';

class StatsRepository {
  final SupabaseClient _client;

  StatsRepository(this._client);

  Future<MoodStats> fetchWeeklyStats(String userId) async {
    final data = await _client.rpc(
      'get_weekly_mood_stats',
      params: {'user_id': userId},
    );
    return MoodStats.fromJson(data);
  }

  Future<WellnessData> fetchWellnessData(String userId) async {
    try {
      final data = await _client
          .from('wellness_data')
          .select()
          .eq('user_id', userId)
          .maybeSingle();
      if (data == null) return const WellnessData(sleepHours: 0, energyPct: 0, meditationMin: 0, hydrationL: 0);
      return WellnessData.fromJson(data);
    } catch (_) {
      return const WellnessData(sleepHours: 0, energyPct: 0, meditationMin: 0, hydrationL: 0);
    }
  }
}
