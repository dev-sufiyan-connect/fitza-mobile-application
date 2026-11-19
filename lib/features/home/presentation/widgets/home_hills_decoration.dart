import 'package:flutter/material.dart';

import 'package:fitza_mobile_application/core/theme/app_colors.dart';

/// Soft sage hills + warm glow painted behind the home dashboard header.
class HomeHillsDecoration extends StatelessWidget {
  const HomeHillsDecoration({super.key, this.height = 300});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: CustomPaint(painter: _HomeHillsPainter(), size: Size.infinite),
    );
  }
}

class _HomeHillsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;

    // Warm pale glow (top-right, like Figma's sun wash)
    final glowPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.55, -0.35),
        radius: 0.75,
        colors: [
          const Color(0xFFFDF3DC).withValues(alpha: 0.95),
          const Color(0xFFFDF3DC).withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h * 0.7), glowPaint);

    // Far back hill — lightest
    final backPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          const Color(0xFFB7D9A5).withValues(alpha: 0.45),
          const Color(0xFFE4F2DB).withValues(alpha: 0.30),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    final back = Path()
      ..moveTo(0, h * 0.42)
      ..quadraticBezierTo(w * 0.28, h * 0.18, w * 0.58, h * 0.34)
      ..quadraticBezierTo(w * 0.82, h * 0.46, w, h * 0.28)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(back, backPaint);

    // Mid hill — medium sage
    final midPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          const Color(0xFF93C77E).withValues(alpha: 0.55),
          const Color(0xFFCFE9C2).withValues(alpha: 0.35),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    final mid = Path()
      ..moveTo(0, h * 0.62)
      ..quadraticBezierTo(w * 0.22, h * 0.36, w * 0.52, h * 0.52)
      ..quadraticBezierTo(w * 0.78, h * 0.64, w, h * 0.48)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(mid, midPaint);

    // Front hill — deeper green on the right, like Figma
    final frontPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          const Color(0xFF6DB45B).withValues(alpha: 0.70),
          const Color(0xFFB5DFA5).withValues(alpha: 0.35),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    final front = Path()
      ..moveTo(w * 0.38, h)
      ..quadraticBezierTo(w * 0.52, h * 0.52, w * 0.74, h * 0.44)
      ..quadraticBezierTo(w * 0.92, h * 0.38, w, h * 0.34)
      ..lineTo(w, h)
      ..close();
    canvas.drawPath(front, frontPaint);

    // Soft fade into page background at the bottom edge
    final fadePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.background.withValues(alpha: 0.0),
          AppColors.background.withValues(alpha: 0.9),
        ],
      ).createShader(Rect.fromLTWH(0, h * 0.55, w, h * 0.45));
    canvas.drawRect(Rect.fromLTWH(0, h * 0.55, w, h * 0.45), fadePaint);
  }

  @override
  bool shouldRepaint(covariant _HomeHillsPainter oldDelegate) => false;
}
