import 'package:flutter/material.dart';

/// Brief branding screen shown while the auth session is being resolved.
/// The router decides where to send the user next — never navigate manually.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.fitness_center, size: 64),
            SizedBox(height: 16),
            Text('Fitza'),
            SizedBox(height: 24),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
