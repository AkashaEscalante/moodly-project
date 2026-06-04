import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:moodly/features/profile/domain/profile_model.dart';

class ProfileRepository {
  final SupabaseClient _client;

  ProfileRepository(this._client);

  Future<Profile> fetchProfile(String userId) async {
    final data = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();
    if (data == null) throw Exception('Perfil no encontrado para el usuario $userId');
    return Profile.fromJson(data);
  }

  Future<void> updateProfile(Profile profile) async {
    final json = profile.toJson();
    json.remove('id');
    await _client.from('profiles').update(json).eq('id', profile.id);
  }

  /// Returns {current_streak, longest_streak, total_entries} from the streaks table.
  Future<Map<String, int>> fetchStreak(String userId) async {
    try {
      final data = await _client
          .from('streaks')
          .select('current_streak, longest_streak, total_entries')
          .eq('user_id', userId)
          .maybeSingle();
      if (data == null) return {'current_streak': 0, 'longest_streak': 0, 'total_entries': 0};
      return {
        'current_streak': (data['current_streak'] as int?) ?? 0,
        'longest_streak': (data['longest_streak'] as int?) ?? 0,
        'total_entries': (data['total_entries'] as int?) ?? 0,
      };
    } catch (_) {
      return {'current_streak': 0, 'longest_streak': 0, 'total_entries': 0};
    }
  }

  /// Updates the app-open streak in the streaks table.
  /// Creates the row if it doesn't exist yet.
  Future<void> recordAppOpen(String userId) async {
    try {
      final today = DateTime.now().toIso8601String().split('T')[0];

      final data = await _client
          .from('streaks')
          .select('current_streak, longest_streak, last_entry_date, total_entries')
          .eq('user_id', userId)
          .maybeSingle();

      if (data == null) {
        await _client.from('streaks').insert({
          'user_id': userId,
          'current_streak': 1,
          'longest_streak': 1,
          'last_entry_date': today,
          'total_entries': 0,
        });
        return;
      }

      final lastEntryDate = data['last_entry_date'] as String?;
      if (lastEntryDate == today) return;

      final yesterday = DateTime.now()
          .subtract(const Duration(days: 1))
          .toIso8601String()
          .split('T')[0];

      final current = (data['current_streak'] as int?) ?? 0;
      final longest = (data['longest_streak'] as int?) ?? 0;
      final newCurrent = lastEntryDate == yesterday ? current + 1 : 1;
      final newLongest = newCurrent > longest ? newCurrent : longest;

      await _client.from('streaks').update({
        'current_streak': newCurrent,
        'longest_streak': newLongest,
        'last_entry_date': today,
      }).eq('user_id', userId);
    } catch (_) {}
  }
}
