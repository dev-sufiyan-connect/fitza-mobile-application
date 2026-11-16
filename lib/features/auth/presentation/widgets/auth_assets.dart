import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

/// Tinted asset icon from the Fitza icon set.
class AuthIcon extends StatelessWidget {
  const AuthIcon(this.asset, {super.key, this.size = 22, this.color});

  final String asset;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      asset,
      width: size,
      height: size,
      colorFilter: color == null
          ? null
          : ColorFilter.mode(color!, BlendMode.srcIn),
    );
  }
}
