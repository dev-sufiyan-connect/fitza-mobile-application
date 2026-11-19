import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:fitza_mobile_application/core/router/route_names.dart';
import 'package:fitza_mobile_application/core/router/route_paths.dart';
import 'package:fitza_mobile_application/core/theme/app_colors.dart';
import 'package:fitza_mobile_application/core/widgets/asset_icon.dart';
import 'package:fitza_mobile_application/features/fitness/domain/entities/fitness_entity.dart';
import 'package:fitza_mobile_application/features/fitness/presentation/providers/fitness_providers.dart';
import 'package:fitza_mobile_application/features/fitness/presentation/widgets/fitness_assets.dart';
import 'package:fitza_mobile_application/features/home/presentation/widgets/home_assets.dart';

/// Celebration screen shown when a workout day is marked complete.
class WorkoutCompletedScreen extends ConsumerWidget {
  const WorkoutCompletedScreen({super.key, required this.day});

  final int day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(workoutCompletedProvider(day));

    return Scaffold(
      backgroundColor: const Color(0xFFFBFDF9),
      body: Stack(
        children: [
          const _BackgroundBlobs(),
          SafeArea(
            child: summary.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
              error: (e, _) => Center(child: Text('$e')),
              data: (data) => Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 6, 20, 0),
                    child: _TopBar(),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(20, 2, 20, 16),
                      children: [
                        const _CelebrationBadge(),
                        const SizedBox(height: 4),
                        const Text(
                          'Workout Completed! 🎉',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Great job! You've finished ${data.dayTag}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.mutedText,
                          ),
                        ),
                        const SizedBox(height: 18),
                        _SummaryHero(data: data),
                        const SizedBox(height: 12),
                        _StatsRow(data: data),
                        const SizedBox(height: 12),
                        _PerformanceCard(data: data),
                        const SizedBox(height: 20),
                        _ExercisesHeader(total: data.totalExercises),
                        const SizedBox(height: 10),
                        for (final exercise in data.exercisePreview)
                          _CompletedExerciseRow(exercise: exercise),
                        const SizedBox(height: 2),
                        _ViewAllRow(total: data.totalExercises),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                    child: _BottomActions(day: day),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackgroundBlobs extends StatelessWidget {
  const _BackgroundBlobs();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFF1F9EC), Color(0xFFFBFDF9)],
                  stops: [0.0, 0.45],
                ),
              ),
            ),
          ),
          Positioned(
            top: -140,
            left: -130,
            child: Container(
              width: 340,
              height: 340,
              decoration: const BoxDecoration(
                color: Color(0xFFE7F4DF),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: -100,
            right: -140,
            child: Container(
              width: 320,
              height: 320,
              decoration: const BoxDecoration(
                color: Color(0xFFEDF7E7),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () => context.go(RoutePaths.fitness),
          borderRadius: BorderRadius.circular(20),
          child: const Padding(
            padding: EdgeInsets.all(4),
            child: Icon(
              Icons.close_rounded,
              size: 24,
              color: AppColors.textDark,
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AssetIcon(HomeAsset.leafMark, size: 22),
                const SizedBox(width: 5),
                const Text(
                  'fitza',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 32),
      ],
    );
  }
}

class _CelebrationBadge extends StatelessWidget {
  const _CelebrationBadge();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 132,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Positioned(
            left: 64,
            top: 22,
            child: _Confetti(color: Color(0xFFF1B63C), angle: -0.5),
          ),
          const Positioned(
            left: 42,
            top: 62,
            child: _Confetti(color: Color(0xFF7DC35B), angle: 0.9),
          ),
          const Positioned(
            left: 90,
            bottom: 26,
            child: _Confetti(color: Color(0xFF3C8F45), angle: 0.3),
          ),
          const Positioned(
            right: 68,
            top: 20,
            child: _Confetti(color: Color(0xFFE98A3C), angle: 0.6),
          ),
          const Positioned(
            right: 44,
            bottom: 46,
            child: _Confetti(color: Color(0xFF9AA59B), angle: -0.8),
          ),
          const Positioned(
            right: 96,
            bottom: 20,
            child: _Confetti(color: Color(0xFFF1B63C), angle: 0.2),
          ),
          Positioned(
            bottom: 0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.rotate(angle: -0.3, child: const _Ribbon()),
                const SizedBox(width: 12),
                Transform.rotate(angle: 0.3, child: const _Ribbon()),
              ],
            ),
          ),
          ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (rect) => const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF8ECF6C), Color(0xFF2F7D33)],
            ).createShader(rect),
            child: const Icon(
              Icons.verified_rounded,
              size: 100,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _Ribbon extends StatelessWidget {
  const _Ribbon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 42,
      decoration: BoxDecoration(
        color: const Color(0xFF2C6E32),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class _Confetti extends StatelessWidget {
  const _Confetti({required this.color, required this.angle});

  final Color color;
  final double angle;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: Container(
        width: 5,
        height: 12,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

class _SummaryHero extends StatelessWidget {
  const _SummaryHero({required this.data});

  final WorkoutCompletedEntity data;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 138,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFFEAF6E2), Color(0xFFD7EFC8)],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Stack(
        children: [
          Row(
            children: [
              SizedBox(
                width: 124,
                height: 138,
                child: Image.asset(FitnessAsset.hero, fit: BoxFit.cover),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 4, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 9, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.65),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          data.dayTag,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: AppColors.secondary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        data.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textDark,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data.focus,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: AppColors.mutedText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            right: 8,
            bottom: -4,
            child: AssetIcon(
              HomeAsset.dumbbell,
              size: 64,
              color: const Color(0xFFAFD79C).withValues(alpha: 0.55),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.data});

  final WorkoutCompletedEntity data;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatTile(
            icon: Icons.schedule_rounded,
            label: 'Duration',
            value: data.duration,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatTile(
            icon: Icons.layers_rounded,
            label: 'Exercises',
            value: data.exercisesCompleted,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatTile(
            icon: Icons.bar_chart_rounded,
            label: 'Sets',
            value: data.setsCompleted,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatTile(
            icon: Icons.local_fire_department_outlined,
            label: 'Est. Calories',
            value: data.calories,
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEFF1EC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(height: 6),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w600,
              color: AppColors.mutedText,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _PerformanceCard extends StatelessWidget {
  const _PerformanceCard({required this.data});

  final WorkoutCompletedEntity data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFFEFF8E8), Color(0xFFE3F3D8)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.trending_up_rounded,
                  size: 16, color: AppColors.primary),
              SizedBox(width: 6),
              Text(
                'Workout Performance',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: _PerfMetric(
                  icon: HomeAsset.dumbbell,
                  label: 'Volume Lifted',
                  value: data.volume,
                  footer: Row(
                    children: [
                      const Icon(
                        Icons.arrow_upward_rounded,
                        size: 11,
                        color: AppColors.primary,
                      ),
                      Text(
                        data.volumeChange,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 3,
                child: _PerfMetric(
                  iconData: Icons.speed_rounded,
                  label: 'Avg. Intensity',
                  value: data.intensity,
                  footer: Row(
                    children: [
                      for (var i = 0; i < 4; i++) ...[
                        if (i > 0) const SizedBox(width: 3),
                        Container(
                          width: 13,
                          height: 4,
                          decoration: BoxDecoration(
                            color: i < data.intensityBars
                                ? AppColors.primary
                                : const Color(0xFFD5E4CE),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 3,
                child: _PerfMetric(
                  iconData: Icons.track_changes_rounded,
                  label: 'Completion',
                  value: data.completion,
                  footer: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: 1,
                      minHeight: 4,
                      backgroundColor: const Color(0xFFD5E4CE),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PerfMetric extends StatelessWidget {
  const _PerfMetric({
    this.icon,
    this.iconData,
    required this.label,
    required this.value,
    required this.footer,
  });

  final String? icon;
  final IconData? iconData;
  final String label;
  final String value;
  final Widget footer;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null)
              AssetIcon(icon!, size: 12, color: AppColors.secondary)
            else
              Icon(iconData, size: 12, color: AppColors.secondary),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.mutedText,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 5),
        footer,
      ],
    );
  }
}

class _ExercisesHeader extends StatelessWidget {
  const _ExercisesHeader({required this.total});

  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Exercises ($total)',
          style: const TextStyle(
            fontSize: 15.5,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
        const Spacer(),
        const Text(
          'View Details',
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 2),
        const Icon(
          Icons.chevron_right_rounded,
          size: 18,
          color: AppColors.primary,
        ),
      ],
    );
  }
}

class _CompletedExerciseRow extends StatelessWidget {
  const _CompletedExerciseRow({required this.exercise});

  final CompletedExerciseEntity exercise;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEFF1EC)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              FitnessAsset.hero,
              width: 44,
              height: 44,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  exercise.detail,
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                    color: AppColors.mutedText,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, size: 14, color: Colors.white),
          ),
          const SizedBox(width: 2),
        ],
      ),
    );
  }
}

class _ViewAllRow extends StatelessWidget {
  const _ViewAllRow({required this.total});

  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFEDF6E6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.menu_rounded, size: 16, color: AppColors.secondary),
          const SizedBox(width: 8),
          Text(
            'View all $total exercises',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const Spacer(),
          const Icon(
            Icons.chevron_right_rounded,
            size: 18,
            color: AppColors.textDark,
          ),
        ],
      ),
    );
  }
}

class _BottomActions extends StatelessWidget {
  const _BottomActions({required this.day});

  final int day;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: SizedBox(
            height: 46,
            child: OutlinedButton(
              onPressed: () => context.go(RoutePaths.fitness),
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: Color(0xFF9FBF9A)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(23),
                ),
              ),
              child: const Text(
                'Back to Fitness',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 3,
          child: SizedBox(
            height: 46,
            child: FilledButton(
              onPressed: () {
                if (day < 5) {
                  context.goNamed(
                    RouteNames.fitnessWorkout,
                    pathParameters: {'day': '${day + 1}'},
                  );
                } else {
                  context.go(RoutePaths.fitness);
                }
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.secondary,
                minimumSize: Size.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(23),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Next Workout',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 17,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
