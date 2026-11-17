import 'package:flutter/material.dart';

import 'package:fitza_mobile_application/core/widgets/placeholder_screen.dart';

/// Placeholder — will be replaced by the real Fitness feature.
class FitnessScreen extends StatelessWidget {
  const FitnessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(title: 'Fitness');
  }
}
