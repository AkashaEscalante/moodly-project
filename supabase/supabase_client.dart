import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const url = 'https://teieocyaslevyzzwjkeq.supabase.co';
  static const anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRlaWVvY3lhc2xldnl6endqa2VxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzY4MDM3MjgsImV4cCI6MjA5MjM3OTcyOH0.Jv7H9g_GUQNAnoHrVpYp0rOYrhq-k_xC11PHaNMMUyc';

  static Future<void> init() async {
    await Supabase.initialize(url: url, anonKey: anonKey);
  }

  static SupabaseClient get client => Supabase.instance.client;
}
