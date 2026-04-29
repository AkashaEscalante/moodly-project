import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:moodly/features/mood/domain/mood_model.dart';
import 'package:moodly/features/mood/domain/activity_model.dart';
import 'package:moodly/features/mood/domain/mood_entry_model.dart';

class MoodRepository {
  final SupabaseClient _client;

  MoodRepository(this._client);

  Future<List<MoodModel>> fetchMoods() async {
    final data = await _client.from('emotions').select();
    return data.map((e) => MoodModel.fromJson(e)).toList();
  }

  Future<List<ActivityModel>> fetchActivities() async {
    final data = await _client.from('activities').select();
    return data.map((e) => ActivityModel.fromJson(e)).toList();
  }

  Future<List<MoodEntryModel>> fetchMoodEntries(String userId) async {
    final data = await _client
        .from('mood_entries')
        .select(
          '*, mood:emotions(*), activities:mood_entry_activities(activity:activities(*))',
        )
        .eq('user_id', userId);
    return data.map((e) => MoodEntryModel.fromJson(e)).toList();
  }

  Future<void> saveMoodEntry({
    required String userId,
    required int moodId,
    String? thought,
    List<int> activityIds = const [],
    int intensity = 3,
  }) async {
    final response = await _client
        .from('mood_entries')
        .insert({
          'user_id': userId,
          'emotion_id': moodId,
          'thought': thought,
          'intensity': intensity,
        })
        .select()
        .single();

    final entryId = response['id'] as String;

    if (activityIds.isNotEmpty) {
      await _client
          .from('mood_entry_activities')
          .insert(
            activityIds
                .map((id) => {'mood_entry_id': entryId, 'activity_id': id})
                .toList(),
          );
    }
  }

  Future<List<Map<String, dynamic>>> fetchWeeklyEntries(String userId) async {
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    final data = await _client
        .from('mood_entries')
        .select('*, mood:emotions(*)')
        .eq('user_id', userId)
        .gte('created_at', weekAgo.toIso8601String())
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(data);
  }
}
