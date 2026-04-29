import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:moodly/features/resources/data/resources_repository.dart';
import 'package:moodly/features/resources/domain/resource_model.dart';

part 'resources_provider.g.dart';

@riverpod
SupabaseClient supabaseClient(SupabaseClientRef ref) {
  return Supabase.instance.client;
}

@riverpod
ResourcesRepository resourcesRepository(ResourcesRepositoryRef ref) {
  return ResourcesRepository(ref.watch(supabaseClientProvider));
}

@riverpod
Future<Resource?> featuredResource(FeaturedResourceRef ref) async {
  final repo = ref.watch(resourcesRepositoryProvider);
  return repo.fetchFeaturedResource();
}

@riverpod
Future<List<Resource>> resourcesByCategory(
  ResourcesByCategoryRef ref,
  String category,
) async {
  final repo = ref.watch(resourcesRepositoryProvider);
  return repo.fetchResources(category: category);
}

/// Manual provider — no build_runner needed.
final dailyMessageProvider = FutureProvider.autoDispose<String>((ref) async {
  final repo = ref.read(resourcesRepositoryProvider);
  return repo.fetchDailyMessage();
});
