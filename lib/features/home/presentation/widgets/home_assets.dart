/// Path constants for the home screen asset pack.
/// Keep in sync with pubspec.yaml.
abstract final class HomeAsset {
  static const String _base = 'assets/fitza_home_screen_assets';
  static const String avatar = '$_base/profile_avatar_reference.png';
  static const String bell = '$_base/bell.svg';
  static const String calendar = '$_base/calendar.svg';
  static const String user = '$_base/user.svg';
  static const String dumbbell = '$_base/dumbbell.svg';
  static const String meal = '$_base/meal.svg';
  static const String apple = '$_base/apple.svg';
  static const String droplet = '$_base/droplet.svg';
  static const String checkSquare = '$_base/check-square.svg';
  static const String scale = '$_base/scale.svg';
  static const String moonSleep = '$_base/moon-sleep.svg';
  static const String flame = '$_base/flame.svg';
  static const String chartProgress = '$_base/chart-progress.svg';
  static const String home = '$_base/home.svg';
  static const String chevronRight = '$_base/chevron-right.svg';
  static const String leafMark = '$_base/leaf-mark.svg';

  /// Maps the icon keys used by [HomeDashboardEntity] to asset paths.
  static String dashboardIcon(String key) => switch (key) {
        'scale' => scale,
        'moon' => moonSleep,
        'flame' => flame,
        'dumbbell' => dumbbell,
        'apple' => apple,
        'check-square' => checkSquare,
        'meal' => meal,
        'droplet' => droplet,
        _ => checkSquare,
      };
}
