import 'dart:math';

import 'package:flutter/material.dart';

import 'package:fitza_mobile_application/core/theme/app_colors.dart';
import 'package:fitza_mobile_application/core/theme/app_theme.dart';

/// Circular progress ring for "Today's Progress".
class ProgressRing extends StatelessWidget {
  const ProgressRing({
    super.key,
    required this.percent,
    this.size = 132,
    this.strokeWidth = 13,
  });

  final int percent;
  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RingPainter(percent: percent, strokeWidth: strokeWidth),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$percent%',
                style: context.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                  height: 1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "Today's\nProgress",
                textAlign: TextAlign.center,
                style: context.textTheme.labelSmall?.copyWith(
                  color: AppColors.mutedText,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({required this.percent, required this.strokeWidth});

  final int percent;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (min(size.width, size.height) - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = const Color(0xFFE8F1E9);
    canvas.drawCircle(center, radius, track);

    final sweep = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF67C24F), AppColors.secondary],
      ).createShader(rect);

    canvas.drawArc(
      rect,
      -pi / 2,
      2 * pi * (percent / 100),
      false,
      sweep,
    );
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) =>
      oldDelegate.percent != percent || oldDelegate.strokeWidth != strokeWidth;
}
