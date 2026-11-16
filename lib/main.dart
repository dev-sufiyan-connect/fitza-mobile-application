import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:fitza_mobile_application/app.dart';
import 'package:fitza_mobile_application/core/config/app_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _bootstrapSupabase();

  runApp(const ProviderScope(child: FitzaApp()));
}

Future<void> _bootstrapSupabase() async {
  assert(
    AppConfig.isSupabaseConfigured,
    'Missing SUPABASE_URL / SUPABASE_ANON_KEY dart-defines. '
    'See ARCHITECTURE.md → "Running the app".',
  );
  if (!AppConfig.isSupabaseConfigured) return;

  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    publishableKey: AppConfig.supabaseAnonKey,
    authOptions: const FlutterAuthClientOptions(
      autoRefreshToken: true,
    ),
  );
}
