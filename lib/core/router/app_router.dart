import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:fitza_mobile_application/core/di/core_providers.dart';
import 'package:fitza_mobile_application/core/router/route_names.dart';
import 'package:fitza_mobile_application/core/router/route_paths.dart';
import 'package:fitza_mobile_application/features/auth/domain/entities/user_entity.dart';
import 'package:fitza_mobile_application/features/auth/presentation/providers/auth_providers.dart';
import 'package:fitza_mobile_application/features/auth/presentation/screens/login_screen.dart';
import 'package:fitza_mobile_application/features/auth/presentation/screens/signup_screen.dart';
import 'package:fitza_mobile_application/features/auth/presentation/screens/splash_screen.dart';
import 'package:fitza_mobile_application/features/fitness/presentation/screens/fitness_screen.dart';
import 'package:fitza_mobile_application/features/fitness/presentation/screens/workout_details_screen.dart';
import 'package:fitza_mobile_application/features/home/presentation/screens/home_screen.dart';
import 'package:fitza_mobile_application/features/nutrition/presentation/screens/nutrition_screen.dart';
import 'package:fitza_mobile_application/features/profile/presentation/screens/profile_screen.dart';
import 'package:fitza_mobile_application/features/progress/presentation/screens/progress_screen.dart';
import 'package:fitza_mobile_application/core/widgets/fitza_shell.dart';

/// Bridges the Supabase auth stream into a [ValueNotifier] so GoRouter can
/// re-run redirects whenever the session changes.
///
/// Note: this subscribes to the stream directly instead of using
/// `ref.listen(authStateProvider)` — Riverpod 3 forbids `ref.listen` inside
/// providers unless every dependency is declared, and we don't want scoped
/// providers for routing.
final _authListenableProvider =
    Provider<ValueNotifier<AsyncValue<UserEntity?>>>((ref) {
  final client = ref.watch(supabaseClientProvider);
  final notifier = ValueNotifier<AsyncValue<UserEntity?>>(
    // Seed synchronously from the current session. The auth stream only
    // emits on *changes* — its initial event may already have fired during
    // Supabase.initialize, so waiting on it would leave us stuck on splash.
    AsyncValue.data(userFromSupabaseUser(client.auth.currentUser)),
  );

  final sub = client.auth.onAuthStateChange.listen(
    (event) => notifier.value = AsyncValue.data(userFromAuthState(event)),
    onError: (Object e) => notifier.value = AsyncValue.error(e, StackTrace.current),
  );

  ref.onDispose(() {
    sub.cancel();
    notifier.dispose();
  });
  return notifier;
});

final routerProvider = Provider<GoRouter>((ref) {
  final authListenable = ref.watch(_authListenableProvider);

  return GoRouter(
    initialLocation: RoutePaths.splash,
    refreshListenable: authListenable,
    debugLogDiagnostics: kDebugMode,
    redirect: (context, state) {
      final auth = authListenable.value;
      final isResolvingSession =
          auth.isLoading || (!auth.hasValue && !auth.hasError);
      final isLoggedIn = auth.value != null;
      final isOnSplash = state.matchedLocation == RoutePaths.splash;
      final isOnAuth = state.matchedLocation == RoutePaths.login ||
          state.matchedLocation == RoutePaths.signup;

      // While the session is being resolved, hold on splash.
      if (isResolvingSession) {
        return isOnSplash ? null : RoutePaths.splash;
      }

      // Logged in users never see auth screens.
      if (isLoggedIn && (isOnSplash || isOnAuth)) {
        return RoutePaths.home;
      }

      // TODO(temp): guest protection on protected tabs is disabled for the
      // UI preview. Splash must still move on — otherwise a signed-out user
      // would sit on the spinner forever.
      if (isOnSplash) {
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
        path: RoutePaths.signup,
        name: RouteNames.signup,
        builder: (context, state) => const SignUpScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            FitzaShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.home,
                name: RouteNames.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.fitness,
                name: RouteNames.fitness,
                builder: (context, state) => const FitnessScreen(),
                routes: [
                  GoRoute(
                    path: 'workout/:day',
                    name: RouteNames.fitnessWorkout,
                    builder: (context, state) => WorkoutDetailsScreen(
                      day: int.tryParse(state.pathParameters['day'] ?? '') ?? 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.nutrition,
                name: RouteNames.nutrition,
                builder: (context, state) => const NutritionScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.progress,
                name: RouteNames.progress,
                builder: (context, state) => const ProgressScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.profile,
                name: RouteNames.profile,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
