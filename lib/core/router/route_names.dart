/// Canonical route names.
///
/// Always navigate by name (`context.goNamed(RouteNames.home)`) —
/// never with string literals scattered across screens.
abstract final class RouteNames {
  static const String splash = 'splash';
  static const String login = 'login';
  static const String signup = 'signup';
  static const String home = 'home';
  static const String fitness = 'fitness';
  static const String fitnessWorkout = 'fitnessWorkout';
  static const String exerciseDetails = 'exerciseDetails';
  static const String workoutCompleted = 'workoutCompleted';
  static const String nutrition = 'nutrition';
  static const String progress = 'progress';
  static const String profile = 'profile';
}
