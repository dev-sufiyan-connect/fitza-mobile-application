import 'package:flutter/material.dart';

import 'package:fitza_mobile_application/core/theme/app_theme.dart';
import 'package:fitza_mobile_application/core/widgets/shimmer.dart';

/// Shimmer placeholder that mirrors the Fitness tab layout while the
/// `get_fitness_dashboard` RPC is in flight.
class FitnessDashboardSkeleton extends StatelessWidget {
  const FitnessDashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        _HeaderSkeleton(),
        SizedBox(height: 18),
        _FiltersSkeleton(),
        SizedBox(height: 18),
        _HeroSkeleton(),
        SizedBox(height: 26),
        _SectionHeaderSkeleton(),
        SizedBox(height: 12),
        FitnessWeekSkeleton(),
        SizedBox(height: 24),
        _SectionTitleSkeleton(),
        SizedBox(height: 12),
        _DayCardSkeleton(),
        SizedBox(height: 10),
        _ExerciseSkeleton(),
        SizedBox(height: 8),
        _ExerciseSkeleton(),
        SizedBox(height: 8),
        _ExerciseSkeleton(),
      ],
    );
  }
}

/// Week-calendar chips placeholder, reused while only the weekly RPC loads.
class FitnessWeekSkeleton extends StatelessWidget {
  const FitnessWeekSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < 7; i++) ...[
          if (i > 0) const SizedBox(width: 6),
          const Expanded(child: _WeekChipSkeleton()),
        ],
      ],
    );
  }
}

class _WeekChipSkeleton extends StatelessWidget {
  const _WeekChipSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFEFF1EE)),
      ),
      child: const Shimmer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShimmerBox(width: 22, height: 9),
            SizedBox(height: 5),
            ShimmerBox(width: 20, height: 12),
            SizedBox(height: 7),
            ShimmerBox(width: 17, height: 17, shape: BoxShape.circle),
          ],
        ),
      ),
    );
  }
}

class _HeaderSkeleton extends StatelessWidget {
  const _HeaderSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Shimmer(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(width: 120, height: 30),
                SizedBox(height: 8),
                ShimmerBox(width: 190, height: 14),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          ShimmerBox(width: 46, height: 46, radius: 14),
        ],
      ),
    );
  }
}

class _FiltersSkeleton extends StatelessWidget {
  const _FiltersSkeleton();

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Row(
        children: [
          for (var i = 0; i < 4; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            const Expanded(
              child: ShimmerBox(
                width: double.infinity,
                height: 34,
                radius: 18,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _HeroSkeleton extends StatelessWidget {
  const _HeroSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Shimmer(
      child: ShimmerBox(width: double.infinity, height: 196, radius: 20),
    );
  }
}

class _SectionHeaderSkeleton extends StatelessWidget {
  const _SectionHeaderSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Shimmer(
      child: Row(
        children: [
          ShimmerBox(width: 104, height: 22),
          Spacer(),
          ShimmerBox(width: 64, height: 16),
        ],
      ),
    );
  }
}

class _SectionTitleSkeleton extends StatelessWidget {
  const _SectionTitleSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Shimmer(
      child: Align(
        alignment: Alignment.centerLeft,
        child: ShimmerBox(width: 130, height: 22),
      ),
    );
  }
}

class _DayCardSkeleton extends StatelessWidget {
  const _DayCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEFF1EC)),
      ),
      child: const Shimmer(
        child: Row(
          children: [
            ShimmerBox(width: 46, height: 46, radius: 13),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ShimmerBox(width: 110, height: 15),
                      SizedBox(width: 8),
                      ShimmerBox(width: 54, height: 20, radius: 10),
                    ],
                  ),
                  SizedBox(height: 6),
                  ShimmerBox(width: 160, height: 11),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExerciseSkeleton extends StatelessWidget {
  const _ExerciseSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEFF1EC)),
      ),
      child: const Shimmer(
        child: Row(
          children: [
            ShimmerBox(width: 52, height: 52, radius: 10),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(width: 150, height: 13),
                  SizedBox(height: 6),
                  ShimmerBox(width: 120, height: 11),
                ],
              ),
            ),
            SizedBox(width: 8),
            ShimmerBox(width: 28, height: 28, shape: BoxShape.circle),
          ],
        ),
      ),
    );
  }
}
