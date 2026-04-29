import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:moodly/features/auth/data/auth_repository.dart';
import 'package:moodly/features/auth/domain/auth_model.dart';

part 'auth_provider.g.dart';

@riverpod
SupabaseClient supabaseClient(SupabaseClientRef ref) {
  return Supabase.instance.client;
}

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepository(ref.watch(supabaseClientProvider));
}

@riverpod
Stream<AppUser?> authState(AuthStateRef ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.authStateChanges;
}

@riverpod
Future<AppUser> signIn(SignInRef ref, String email, String password) async {
  final repo = ref.watch(authRepositoryProvider);
  return repo.signIn(email, password);
}

@riverpod
Future<AppUser> signUp(
  SignUpRef ref,
  String email,
  String password,
  String fullName,
) async {
  final repo = ref.watch(authRepositoryProvider);
  return repo.signUp(email, password, fullName);
}

@riverpod
Future<void> signOut(SignOutRef ref) async {
  final repo = ref.watch(authRepositoryProvider);
  return repo.signOut();
}
