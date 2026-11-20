import 'package:flutter/material.dart';

import 'package:fitza_mobile_application/core/theme/app_colors.dart';
import 'package:fitza_mobile_application/core/theme/app_theme.dart';
import 'package:fitza_mobile_application/core/widgets/shimmer.dart';

/// Shimmer placeholder that mirrors the Today dashboard layout while the
/// `get_home_dashboard` RPC is in flight.
class HomeDashboardSkeleton extends StatelessWidget {
  const HomeDashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        _HeaderSkeleton(),
        SizedBox(height: AppSpacing.lg),
        _GreetingSkeleton(),
        SizedBox(height: AppSpacing.lg),
        _ProgressCardSkeleton(),
        SizedBox(height: AppSpacing.md),
        _StatsSkeleton(),
        SizedBox(height: AppSpacing.xl),
        _PlanHeaderSkeleton(),
        SizedBox(height: AppSpacing.md),
        _PlanCardSkeleton(),
        SizedBox(height: 10),
        _PlanCardSkeleton(),
        SizedBox(height: 10),
        _PlanCardSkeleton(),
        SizedBox(height: AppSpacing.sm),
        _ButtonSkeleton(),
      ],
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
          ShimmerBox(width: 34, height: 34, radius: 10),
          SizedBox(width: AppSpacing.sm),
          ShimmerBox(width: 62, height: 22),
          Spacer(),
          ShimmerBox(width: 44, height: 44, radius: 16),
          SizedBox(width: AppSpacing.md),
          ShimmerBox(width: 42, height: 42, shape: BoxShape.circle),
        ],
      ),
    );
  }
}

class _GreetingSkeleton extends StatelessWidget {
  const _GreetingSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Shimmer(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(width: 150, height: 16),
                SizedBox(height: 10),
                ShimmerBox(width: 200, height: 30, radius: 10),
                SizedBox(height: 10),
                ShimmerBox(width: 230, height: 14),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          ShimmerBox(width: 96, height: 40, radius: 14),
        ],
      ),
    );
  }
}

class _ProgressCardSkeleton extends StatelessWidget {
  const _ProgressCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.textDark.withValues(alpha: 0.05),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Shimmer(
        child: Row(
          children: [
            SizedBox(width: 4),
            ShimmerBox(width: 124, height: 124, shape: BoxShape.circle),
            SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                children: [
                  _ChecklistRowSkeleton(),
                  SizedBox(height: 14),
                  _ChecklistRowSkeleton(),
                  SizedBox(height: 14),
                  _ChecklistRowSkeleton(),
                  SizedBox(height: 14),
                  _ChecklistRowSkeleton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChecklistRowSkeleton extends StatelessWidget {
  const _ChecklistRowSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        ShimmerBox(width: 32, height: 32, radius: 10),
        SizedBox(width: AppSpacing.sm),
        Expanded(child: ShimmerBox(width: double.infinity, height: 14)),
        SizedBox(width: AppSpacing.sm),
        ShimmerBox(width: 34, height: 14),
      ],
    );
  }
}

class _StatsSkeleton extends StatelessWidget {
  const _StatsSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Shimmer(
        child: Row(
          children: [
            Expanded(child: _StatSkeleton()),
            ShimmerBox(width: 1, height: 34),
            Expanded(child: _StatSkeleton()),
            ShimmerBox(width: 1, height: 34),
            Expanded(child: _StatSkeleton()),
          ],
        ),
      ),
    );
  }
}

class _StatSkeleton extends StatelessWidget {
  const _StatSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShimmerBox(width: 24, height: 24, radius: 8),
        SizedBox(width: 8),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerBox(width: 52, height: 12),
            SizedBox(height: 5),
            ShimmerBox(width: 42, height: 10),
          ],
        ),
      ],
    );
  }
}

class _PlanHeaderSkeleton extends StatelessWidget {
  const _PlanHeaderSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Shimmer(
      child: Row(
        children: [
          ShimmerBox(width: 130, height: 24),
          Spacer(),
          ShimmerBox(width: 64, height: 16),
        ],
      ),
    );
  }
}

class _PlanCardSkeleton extends StatelessWidget {
  const _PlanCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF0F3EF)),
      ),
      child: const Shimmer(
        child: Row(
          children: [
            ShimmerBox(width: 48, height: 48, radius: 15),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(width: 84, height: 16),
                  SizedBox(height: 6),
                  ShimmerBox(width: 150, height: 12),
                ],
              ),
            ),
            SizedBox(width: 10),
            ShimmerBox(width: 54, height: 29, radius: 12),
            SizedBox(width: 10),
            ShimmerBox(width: 20, height: 20),
          ],
        ),
      ),
    );
  }
}

class _ButtonSkeleton extends StatelessWidget {
  const _ButtonSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Shimmer(
      child: ShimmerBox(
        width: double.infinity,
        height: 56,
        radius: 28,
      ),
    );
  }
}
