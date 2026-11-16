import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitza_mobile_application/core/config/app_config.dart';
import 'package:fitza_mobile_application/core/router/app_router.dart';
import 'package:fitza_mobile_application/core/theme/app_theme.dart';

/// Root widget. Owns nothing but composition: router + theme.
class FitzaApp extends ConsumerWidget {
  const FitzaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      routerConfig: ref.watch(routerProvider),
    );
  }
}
