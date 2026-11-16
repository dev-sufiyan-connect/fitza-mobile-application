/// Canonical route names.
///
/// Always navigate by name (`context.goNamed(RouteNames.home)`) —
/// never with string literals scattered across screens.
abstract final class RouteNames {
  static const String splash = 'splash';
  static const String login = 'login';
  static const String signup = 'signup';
  static const String home = 'home';
}
