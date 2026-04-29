import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:moodly/features/auth/domain/auth_model.dart';

class AuthRepository {
  final SupabaseClient _client;

  AuthRepository(this._client);

  Future<AppUser> signIn(String email, String password) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    final user = response.user!;
    return AppUser(
      id: user.id,
      email: user.email!,
      fullName: user.userMetadata?['full_name'] ?? '',
    );
  }

  Future<AppUser> signUp(String email, String password, String fullName) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName},
    );
    final user = response.user!;
    return AppUser(id: user.id, email: user.email!, fullName: fullName);
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  AppUser? get currentUser {
    final user = _client.auth.currentUser;
    if (user == null) return null;
    return AppUser(
      id: user.id,
      email: user.email!,
      fullName: user.userMetadata?['full_name'] ?? '',
    );
  }

  Stream<AppUser?> get authStateChanges {
    return _client.auth.onAuthStateChange.map((event) {
      final user = event.session?.user;
      if (user == null) return null;
      return AppUser(
        id: user.id,
        email: user.email!,
        fullName: user.userMetadata?['full_name'] ?? '',
      );
    });
  }
}
