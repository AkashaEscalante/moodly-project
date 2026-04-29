import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:moodly/features/diary/domain/gratitude_entry_model.dart';

class DiaryRepository {
  final SupabaseClient _client;

  DiaryRepository(this._client);

  Future<List<GratitudeEntry>> fetchGratitudeEntries(String userId) async {
    final data = await _client
        .from('gratitude_entries')
        .select()
        .eq('user_id', userId)
        .order('entry_date', ascending: false);
    return data.map((e) => GratitudeEntry.fromJson(e)).toList();
  }

  Future<GratitudeEntry?> fetchTodayEntry(String userId) async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    final data = await _client
        .from('gratitude_entries')
        .select()
        .eq('user_id', userId)
        .eq('entry_date', today)
        .maybeSingle();
    return data != null ? GratitudeEntry.fromJson(data) : null;
  }

  Future<void> saveEntry({
    required String userId,
    required String content,
    String? moodIcon,
    String? existingId,
  }) async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    if (existingId != null) {
      await _client.from('gratitude_entries').update({
        'content': content,
        'mood_icon': moodIcon,
      }).eq('id', existingId);
    } else {
      await _client.from('gratitude_entries').insert({
        'user_id': userId,
        'content': content,
        'mood_icon': moodIcon,
        'entry_date': today,
      });
    }
  }
}
