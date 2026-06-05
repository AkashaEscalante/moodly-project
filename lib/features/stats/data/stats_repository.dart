import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:moodly/features/stats/domain/wellness_model.dart';
import 'package:moodly/features/stats/domain/mood_stats_model.dart';

class StatsRepository {
  final SupabaseClient _client;

  StatsRepository(this._client);

  Future<MoodStats> fetchWeeklyStats(String userId) async {
    if (userId.isEmpty) return MoodStats.empty();
    try {
      final weekAgo = DateTime.now().subtract(const Duration(days: 7));
      final data = await _client
          .from('mood_entries')
          .select('id, created_at, intensity, mood:emotions(name, emoji)')
          .eq('user_id', userId)
          .gte('created_at', weekAgo.toIso8601String())
          .order('created_at', ascending: true);

      final entries = List<Map<String, dynamic>>.from(data);
      if (entries.isEmpty) return MoodStats.empty();

      // Días de la semana (hoy incluido, 7 días hacia atrás)
      final now = DateTime.now();
      final days = List.generate(7, (i) => now.subtract(Duration(days: 6 - i)));
      const dayLabels = ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'];

      final weekData = days.map((d) {
        final dayEntries = entries.where((e) {
          final dt = DateTime.parse(e['created_at'] as String).toLocal();
          return dt.day == d.day &&
              dt.month == d.month &&
              dt.year == d.year;
        }).toList();

        final avgIntensity = dayEntries.isEmpty
            ? 0.0
            : dayEntries
                    .map((e) => (e['intensity'] as num? ?? 3).toDouble())
                    .reduce((a, b) => a + b) /
                dayEntries.length;

        return {
          'day': dayLabels[d.weekday % 7],
          'value': avgIntensity,
          'count': dayEntries.length,
        };
      }).toList();

      // Emoción más frecuente
      final moodCounts = <String, int>{};
      for (final e in entries) {
        final moodMap = e['mood'];
        final name = (moodMap is Map ? moodMap['name'] : null) as String? ?? '—';
        moodCounts[name] = (moodCounts[name] ?? 0) + 1;
      }
      final mostFrequent = moodCounts.isEmpty
          ? 'Sin datos'
          : moodCounts.entries
              .reduce((a, b) => a.value >= b.value ? a : b)
              .key;

      // Racha: días consecutivos con al menos 1 registro (hacia atrás desde hoy)
      int streak = 0;
      for (final d in days.reversed) {
        final hasEntry = entries.any((e) {
          final dt = DateTime.parse(e['created_at'] as String).toLocal();
          return dt.day == d.day &&
              dt.month == d.month &&
              dt.year == d.year;
        });
        if (hasEntry) {
          streak++;
        } else {
          break;
        }
      }

      return MoodStats(
        mostFrequentMood: mostFrequent,
        streak: streak,
        weekData: weekData,
      );
    } catch (_) {
      return MoodStats.empty();
    }
  }

  Future<WellnessData> fetchWellnessData(String userId) async {
    try {
      final data = await _client
          .from('wellness_data')
          .select()
          .eq('user_id', userId)
          .maybeSingle();
      if (data == null) {
        return const WellnessData(
            sleepHours: 0, energyPct: 0, meditationMin: 0, hydrationL: 0);
      }
      return WellnessData.fromJson(data);
    } catch (_) {
      return const WellnessData(
          sleepHours: 0, energyPct: 0, meditationMin: 0, hydrationL: 0);
    }
  }
}
