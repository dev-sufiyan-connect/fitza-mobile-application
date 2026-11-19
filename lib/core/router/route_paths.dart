/// Canonical route paths. Kept separate from [RouteNames] so paths and
/// names can evolve independently (e.g. adding nested routes/shell routes).
abstract final class RoutePaths {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String fitness = '/fitness';
  static const String fitnessWorkout = '/fitness/workout';
  static const String nutrition = '/nutrition';
  static const String progress = '/progress';
  static const String profile = '/profile';
}
