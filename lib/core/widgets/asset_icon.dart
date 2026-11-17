import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Tinted SVG icon rendered from an asset. The shared icon widget for the
/// whole app (auth pack, home pack, etc. use the same 24x24 stroke style).
class AssetIcon extends StatelessWidget {
  const AssetIcon(this.asset, {super.key, this.size = 22, this.color});

  final String asset;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      asset,
      width: size,
      height: size,
      colorFilter:
          color == null ? null : ColorFilter.mode(color!, BlendMode.srcIn),
    );
  }
}
