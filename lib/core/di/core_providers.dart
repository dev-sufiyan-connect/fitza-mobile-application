import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Single source of truth for the Supabase client.
///
/// Never access `Supabase.instance` directly in features — inject this
/// provider so data sources remain testable (override in tests with a mock).
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});
