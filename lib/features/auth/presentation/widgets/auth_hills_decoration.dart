import 'package:flutter/material.dart';

/// Soft green hills + pale sun painted behind auth screen headers.
class AuthHillsDecoration extends StatelessWidget {
  const AuthHillsDecoration({super.key, this.height = 260});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: CustomPaint(painter: _HillsPainter(), size: Size.infinite),
    );
  }
}

class _HillsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;

    // Pale sun
    final sunPaint = Paint()..color = const Color(0xFFFDF6D8);
    canvas.drawCircle(Offset(w * 0.78, h * 0.16), w * 0.075, sunPaint);

    // Back hill — light, airy
    final backPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          const Color(0xFFB9D9A6).withValues(alpha: 0.55),
          const Color(0xFFDDF0D2).withValues(alpha: 0.25),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    final back = Path()
      ..moveTo(w * 0.15, 0)
      ..quadraticBezierTo(w * 0.55, h * 0.10, w, h * 0.02)
      ..lineTo(w, h * 0.45)
      ..quadraticBezierTo(w * 0.5, h * 0.30, 0, h * 0.62)
      ..close();
    canvas.drawPath(back, backPaint);

    // Front hill — deeper sage
    final frontPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          const Color(0xFF7CB86B).withValues(alpha: 0.65),
          const Color(0xFFC6E6B8).withValues(alpha: 0.20),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    final front = Path()
      ..moveTo(w * 0.42, 0)
      ..quadraticBezierTo(w * 0.75, h * 0.14, w, h * 0.06)
      ..lineTo(w, h * 0.62)
      ..quadraticBezierTo(w * 0.62, h * 0.46, w * 0.30, h * 0.72)
      ..quadraticBezierTo(w * 0.34, h * 0.42, w * 0.42, 0)
      ..close();
    canvas.drawPath(front, frontPaint);
  }

  @override
  bool shouldRepaint(covariant _HillsPainter oldDelegate) => false;
}
