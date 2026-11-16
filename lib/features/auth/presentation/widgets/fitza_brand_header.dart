import 'package:flutter/material.dart';

import 'package:fitza_mobile_application/core/theme/app_colors.dart';
import 'package:fitza_mobile_application/core/theme/app_theme.dart';
import 'package:fitza_mobile_application/features/auth/presentation/widgets/auth_assets.dart';

/// Fitza brand block: leaf mark + wordmark + tagline.
/// Reused on auth screens (login hero, signup header).
class FitzaBrandHeader extends StatelessWidget {
  const FitzaBrandHeader({super.key, this.markSize = 56});

  final double markSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AuthIcon(AuthAsset.leafMark, size: markSize),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'fitza',
          style: context.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
            height: 1,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'PLAN · MOVE · EAT · REST',
          style: context.textTheme.labelSmall?.copyWith(
            color: AppColors.textDark,
            letterSpacing: 2.4,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
