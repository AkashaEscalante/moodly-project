import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:moodly/features/resources/domain/resource_model.dart';

class ResourcesRepository {
  final SupabaseClient _client;

  ResourcesRepository(this._client);

  Future<List<Resource>> fetchResources({String? category}) async {
    var query = _client.from('tips').select();
    if (category != null && category != 'all') {
      query = query.eq('category', category);
    }
    final data = await query.order('display_order');
    return data.map((e) => Resource.fromJson(e)).toList();
  }

  Future<Resource?> fetchFeaturedResource() async {
    try {
      final data = await _client
          .from('tips')
          .select()
          .order('display_order')
          .limit(1)
          .single();
      return Resource.fromJson(data);
    } catch (_) {
      return null;
    }
  }

  Future<String> fetchDailyMessage() async {
    try {
      final data = await _client
          .from('motivational_messages')
          .select('message')
          .eq('is_active', true);
      if (data.isEmpty) return '';
      final idx = DateTime.now().day % data.length;
      return (data[idx]['message'] as String?) ?? '';
    } catch (_) {
      return '';
    }
  }
}
