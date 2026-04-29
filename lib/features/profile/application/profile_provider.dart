import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:moodly/features/profile/data/profile_repository.dart';
import 'package:moodly/features/profile/domain/profile_model.dart';

part 'profile_provider.g.dart';

@riverpod
SupabaseClient supabaseClient(SupabaseClientRef ref) {
  return Supabase.instance.client;
}

@riverpod
ProfileRepository profileRepository(ProfileRepositoryRef ref) {
  return ProfileRepository(ref.watch(supabaseClientProvider));
}

@riverpod
Future<Profile> currentProfile(CurrentProfileRef ref, String userId) async {
  final repo = ref.watch(profileRepositoryProvider);
  return repo.fetchProfile(userId);
}

@riverpod
Future<void> updateProfile(UpdateProfileRef ref, Profile profile) async {
  final repo = ref.watch(profileRepositoryProvider);
  return repo.updateProfile(profile);
}

/// Reads {current_streak, longest_streak, total_entries} from the streaks table.
/// Defined manually so no build_runner regeneration is needed.
final streakDataProvider = FutureProvider.autoDispose
    .family<Map<String, int>, String>((ref, userId) async {
  if (userId.isEmpty) {
    return {'current_streak': 0, 'longest_streak': 0, 'total_entries': 0};
  }
  final repo = ref.read(profileRepositoryProvider);
  return repo.fetchStreak(userId);
});
