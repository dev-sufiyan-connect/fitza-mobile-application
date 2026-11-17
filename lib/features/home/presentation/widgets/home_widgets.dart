import 'package:flutter/material.dart';

import 'package:fitza_mobile_application/core/widgets/asset_icon.dart';
import 'package:fitza_mobile_application/core/theme/app_colors.dart';
import 'package:fitza_mobile_application/core/theme/app_theme.dart';
import 'package:fitza_mobile_application/features/home/domain/entities/home_dashboard_entity.dart';
import 'package:fitza_mobile_application/features/home/presentation/widgets/home_assets.dart';
import 'package:fitza_mobile_application/features/home/presentation/widgets/progress_ring.dart';

/// Card with the progress ring on the left and the workout/meals/water/tasks
/// checklist on the right.
class DashboardProgressCard extends StatelessWidget {
  const DashboardProgressCard({super.key, required this.dashboard});

  final HomeDashboardEntity dashboard;

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
      child: Row(
        children: [
          const SizedBox(width: 4),
          ProgressRing(percent: dashboard.progressPercent, size: 124),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              children: [
                for (final (i, item) in dashboard.checklist.indexed) ...[
                  if (i > 0) const SizedBox(height: 14),
                  _ChecklistRow(item: item),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChecklistRow extends StatelessWidget {
  const _ChecklistRow({required this.item});

  final ChecklistItemEntity item;

  @override
  Widget build(BuildContext context) {
    final icon = switch (item.label.toLowerCase()) {
      'workout' => HomeAsset.dumbbell,
      'meals' => HomeAsset.meal,
      'water' => HomeAsset.droplet,
      'tasks' => HomeAsset.checkSquare,
      _ => HomeAsset.checkSquare,
    };

    return Row(
      children: [
        // Tinted rounded square with a green icon (per reference)
        Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFE7F3E4),
            borderRadius: BorderRadius.circular(10),
          ),
          child: AssetIcon(icon, size: 19, color: AppColors.primary),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            item.label,
            style: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
        ),
        if (item.isComplete)
          Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, size: 14, color: Colors.white),
          )
        else
          Text(
            item.value,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: AppColors.mutedText,
            ),
          ),
      ],
    );
  }
}

/// Row of three rounded stat chips (weight / sleep / calories).
class StatChipRow extends StatelessWidget {
  const StatChipRow({super.key, required this.stats});

  final List<StatChipEntity> stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final (i, stat) in stats.indexed) ...[
          if (i > 0) const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.md),
              decoration: BoxDecoration(
                color: const Color(0xFFEDF3EC),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  // White rounded icon tile with a green icon
                  Container(
                    width: 38,
                    height: 38,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: AssetIcon(
                      HomeAsset.dashboardIcon(stat.icon),
                      size: 21,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stat.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          stat.subtitle,
                          maxLines: 2,
                          style: context.textTheme.labelSmall?.copyWith(
                              color: AppColors.mutedText, height: 1.15),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// A single "Today's Plan" row card.
class PlanCard extends StatelessWidget {
  const PlanCard({super.key, required this.item, this.onTap});

  final PlanItemEntity item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md + 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFEEF2EE)),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xFFEDF3EC),
                  shape: BoxShape.circle,
                ),
                child: AssetIcon(
                  HomeAsset.dashboardIcon(item.icon),
                  size: 22,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.subtitle,
                      style: context.textTheme.bodySmall
                          ?.copyWith(color: AppColors.mutedText, fontSize: 12.5),
                    ),
                  ],
                ),
              ),
              if (item.badge != null) ...[
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7F3E4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    item.badge!,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
              ],
              AssetIcon(
                HomeAsset.chevronRight,
                size: 22,
                color: AppColors.mutedText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
