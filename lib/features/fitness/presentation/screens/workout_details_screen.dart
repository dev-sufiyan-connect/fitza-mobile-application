import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:fitza_mobile_application/core/error/failures.dart';
import 'package:fitza_mobile_application/core/router/route_names.dart';
import 'package:fitza_mobile_application/core/theme/app_colors.dart';
import 'package:fitza_mobile_application/core/widgets/asset_icon.dart';
import 'package:fitza_mobile_application/features/fitness/domain/entities/fitness_dashboard_entity.dart';
import 'package:fitza_mobile_application/features/fitness/presentation/providers/fitness_providers.dart';
import 'package:fitza_mobile_application/features/fitness/presentation/widgets/fitness_assets.dart';
import 'package:fitza_mobile_application/features/home/presentation/widgets/home_assets.dart';

/// Detail page for a single workout day (opened from the Fitness tab).
class WorkoutDetailsScreen extends ConsumerWidget {
  const WorkoutDetailsScreen({super.key, required this.day});

  final int day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(fitnessDashboardProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: dashboard.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (e, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                _failureMessage(e),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.mutedText,
                ),
              ),
            ),
          ),
          data: (data) {
            final workoutDay = data.day;
            final exercises = workoutDay.exercises;
            final dayNumber = workoutDay.dayNumber ?? day;

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                const _TopBar(),
                const SizedBox(height: 18),
                _WorkoutHero(
                  tag: 'DAY ${dayNumber.toString().padLeft(2, '0')}',
                  title: workoutDay.title.isEmpty
                      ? 'Workout'
                      : workoutDay.title,
                  focus: _focusLabel(workoutDay),
                ),
                const SizedBox(height: 16),
                _ProgressCard(
                  completed: workoutDay.isCompleted ? exercises.length : 0,
                  total: exercises.length,
                ),
                const SizedBox(height: 14),
                if (exercises.isEmpty)
                  const _EmptyWorkoutCard()
                else
                  for (final (i, exercise) in exercises.indexed)
                    _ExerciseRow(
                      name: exercise.name,
                      detail: _exerciseSummary(exercise),
                      index: i,
                      onTap: () => context.pushNamed(
                        RouteNames.exerciseDetails,
                        pathParameters: {
                          'planExerciseId': exercise.planExerciseId,
                        },
                      ),
                    ),
                const SizedBox(height: 4),
                const _WarmUpCard(),
              ],
            );
          },
        ),
      ),
    );
  }
}

String _failureMessage(Object? error) =>
    error is Failure ? error.message : '$error';

String _focusLabel(FitnessDayEntity day) {
  final parts = <String>[
    if (day.exerciseCount > 0) '${day.exerciseCount} exercises',
    if (day.status.isNotEmpty) _statusLabel(day.status),
  ];
  return parts.join(' · ');
}

String _statusLabel(String status) {
  if (status.isEmpty) return '';
  return status[0].toUpperCase() + status.substring(1);
}

String _exerciseSummary(FitnessExerciseEntity exercise) {
  final parts = <String>[];
  final sets = exercise.sets;

  if (sets.isNotEmpty) {
    parts.add('${sets.length} ${sets.length == 1 ? 'set' : 'sets'}');
    final first = sets.first;

    if (first.targetDurationSeconds != null) {
      parts.add('${first.targetDurationSeconds}s');
    } else if (first.targetRepsMin != null) {
      final min = first.targetRepsMin!;
      final max = first.targetRepsMax;
      parts.add(max != null && max != min ? '$min–$max reps' : '$min reps');
    }

    if (first.targetWeightKg != null) {
      final weight = first.targetWeightKg!;
      parts.add(
        '${weight == weight.roundToDouble() ? weight.toInt() : weight} kg',
      );
    }
  }

  if (parts.isEmpty && exercise.description.isNotEmpty) {
    return exercise.description;
  }
  return parts.join(' · ');
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () => context.pop(),
          borderRadius: BorderRadius.circular(20),
          child: const Padding(
            padding: EdgeInsets.all(4),
            child: Icon(
              Icons.arrow_back_rounded,
              size: 24,
              color: AppColors.textDark,
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          'Workout details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
        const Spacer(),
        const CircleAvatar(
          radius: 18,
          backgroundImage: AssetImage(HomeAsset.avatar),
        ),
      ],
    );
  }
}

class _WorkoutHero extends StatelessWidget {
  const _WorkoutHero({
    required this.tag,
    required this.title,
    required this.focus,
  });

  final String tag;
  final String title;
  final String focus;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            FitnessAsset.hero,
            width: 152,
            height: 150,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5F4DC),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tag,
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.secondary,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              const SizedBox(height: 7),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                focus,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.mutedText,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 36,
                child: FilledButton.icon(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    minimumSize: Size.zero,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  icon: const Icon(
                    Icons.play_arrow_rounded,
                    size: 19,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Start workout',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.completed, required this.total});

  final int completed;
  final int total;

  @override
  Widget build(BuildContext context) {
    final percent = total == 0 ? 0 : (completed / total * 100).round();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEFF1EC)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                '$completed of $total exercises completed',
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              const Spacer(),
              Text(
                '$percent%',
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: total == 0 ? 0 : completed / total,
              minHeight: 6,
              backgroundColor: const Color(0xFFE7F0E2),
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExerciseRow extends StatelessWidget {
  const _ExerciseRow({
    required this.name,
    required this.detail,
    required this.index,
    this.onTap,
  });

  final String name;
  final String detail;
  final int index;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    const alignments = [
      Alignment.topLeft,
      Alignment.center,
      Alignment.bottomRight,
      Alignment.topRight,
      Alignment.bottomLeft,
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFEFF1EC)),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    FitnessAsset.hero,
                    width: 52,
                    height: 52,
                    fit: BoxFit.cover,
                    alignment: alignments[index % alignments.length],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textDark,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        detail,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: AppColors.mutedText,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF5E3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AssetIcon(
                        HomeAsset.dumbbell,
                        size: 13,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Log weight',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                const AssetIcon(
                  HomeAsset.chevronRight,
                  size: 18,
                  color: AppColors.mutedText,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyWorkoutCard extends StatelessWidget {
  const _EmptyWorkoutCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEFF1EC)),
      ),
      child: const Text(
        'No exercises are scheduled for this day.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.mutedText,
        ),
      ),
    );
  }
}

class _WarmUpCard extends StatelessWidget {
  const _WarmUpCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFFEFF8E8), Color(0xFFDFF2D0)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFFDDF0CF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.directions_run_rounded,
              size: 20,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Warm up first',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Complete 5–10 minutes of warm-up before starting.',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.mutedText,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const AssetIcon(
            HomeAsset.chevronRight,
            size: 18,
            color: AppColors.textDark,
          ),
        ],
      ),
    );
  }
}
