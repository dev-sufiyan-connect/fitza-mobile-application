import 'package:flutter/material.dart';

/// Fitza Design System — single source of truth for brand colors.
///
/// Screens must never hard-code hex values; always reference [AppColors]
/// or read from `context.colorScheme` (which is built from these).
///
/// Style: Material 3 · Clean · Modern
abstract final class AppColors {
  // Brand palette
  static const Color primary = Color(0xFF22A34A); // Sage Green
  static const Color secondary = Color(0xFF14532D); // Forest Green
  static const Color background = Color(0xFFF8FAF8); // Warm White

  // Supporting tones (derived from the brand palette)
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF101511); // Dark equivalent of warm white
  static const Color textDark = Color(0xFF15201A); // Headings on light bg
  static const Color mutedText = Color(0xFF5B6660); // Secondary text on light bg

  // Semantic
  static const Color error = Color(0xFFD6483B);
  static const Color success = primary;

  // Loading skeletons
  static const Color shimmerBase = Color(0xFFE4EAE4);
  static const Color shimmerHighlight = Color(0xFFF4F8F2);
}
