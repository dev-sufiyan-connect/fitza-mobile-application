import 'package:fitza_mobile_application/core/widgets/asset_icon.dart';

/// Shared path of the login asset pack. Keep in sync with pubspec.yaml.
abstract final class AuthAsset {
  static const String _base = 'assets/fitza_login_assets';
  static const String hero = '$_base/login_hero_landscape.png';
  static const String foliage = '$_base/login_bottom_foliage.png';
  static const String leafMark = '$_base/leaf-mark.svg';
  static const String mail = '$_base/mail.svg';
  static const String lock = '$_base/lock.svg';
  static const String eye = '$_base/eye.svg';
  static const String eyeOff = '$_base/eye-off.svg';
  static const String arrowRight = '$_base/arrow-right.svg';
  static const String user = '$_base/user.svg';
  static const String google = '$_base/google.svg';
  static const String apple = '$_base/apple.svg';
}

/// Auth-pack icon. Alias of the shared [AssetIcon] so existing call sites
/// keep working.
typedef AuthIcon = AssetIcon;
