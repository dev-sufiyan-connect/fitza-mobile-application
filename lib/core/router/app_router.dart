import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:fitza_mobile_application/core/router/route_names.dart';
import 'package:fitza_mobile_application/core/router/route_paths.dart';
import 'package:fitza_mobile_application/features/auth/domain/entities/user_entity.dart';
import 'package:fitza_mobile_application/features/auth/presentation/providers/auth_providers.dart';
import 'package:fitza_mobile_application/features/auth/presentation/screens/login_screen.dart';
import 'package:fitza_mobile_application/features/auth/presentation/screens/splash_screen.dart';
import 'package:fitza_mobile_application/features/home/presentation/screens/home_screen.dart';

/// Listens to the auth stream and exposes it as a [ValueNotifier] so
/// GoRouter can re-run redirects whenever the session changes.
final _authListenableProvider = Provider<ValueNotifier<AsyncValue<UserEntity?>>>(
  (ref) {
    final notifier = ValueNotifier<AsyncValue<UserEntity?>>(
      const AsyncValue.loading(),
    );
    ref.listen(authStateProvider, (_, next) => notifier.value = next);
    ref.onDispose(notifier.dispose);
    return notifier;
  },
  dependencies: [authStateProvider],
);

final routerProvider = Provider<GoRouter>((ref) {
  final authListenable = ref.watch(_authListenableProvider);

  return GoRouter(
    initialLocation: RoutePaths.splash,
    refreshListenable: authListenable,
    debugLogDiagnostics: kDebugMode,
    redirect: (context, state) {
      final auth = authListenable.value;
      final isResolvingSession = auth.isLoading || !auth.hasValue && !auth.hasError;
      final isLoggedIn = auth.value != null;
      final isOnSplash = state.matchedLocation == RoutePaths.splash;
      final isOnAuth = state.matchedLocation == RoutePaths.login;

      // While the session is being resolved, hold on splash.
      if (isResolvingSession) {
        return isOnSplash ? null : RoutePaths.splash;
      }

      // Logged in users never see auth screens.
      if (isLoggedIn && (isOnSplash || isOnAuth)) {
        return RoutePaths.home;
      }

      // Guests never see protected screens.
      if (!isLoggedIn && !isOnAuth) {
        return RoutePaths.login;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        name: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RoutePaths.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RoutePaths.home,
        name: RouteNames.home,
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
});
