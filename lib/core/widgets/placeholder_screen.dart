import 'package:flutter/material.dart';

import 'package:fitza_mobile_application/core/theme/app_colors.dart';
import 'package:fitza_mobile_application/core/theme/app_theme.dart';

/// Simple placeholder for tabs/features that are not built yet.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Text(
          title,
          style: context.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
      ),
    );
  }
}
