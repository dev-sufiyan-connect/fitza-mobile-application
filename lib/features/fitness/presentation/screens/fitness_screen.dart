import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:fitza_mobile_application/core/error/failures.dart';
import 'package:fitza_mobile_application/core/router/route_names.dart';
import 'package:fitza_mobile_application/core/theme/app_colors.dart';
import 'package:fitza_mobile_application/core/utils/date_utils.dart';
import 'package:fitza_mobile_application/core/widgets/asset_icon.dart';
import 'package:fitza_mobile_application/features/fitness/domain/entities/fitness_dashboard_entity.dart';
import 'package:fitza_mobile_application/features/fitness/domain/entities/weekly_workout_entity.dart';
import 'package:fitza_mobile_application/features/fitness/presentation/providers/fitness_providers.dart';
import 'package:fitza_mobile_application/features/fitness/presentation/widgets/fitness_assets.dart';
import 'package:fitza_mobile_application/features/fitness/presentation/widgets/fitness_dashboard_skeleton.dart';
import 'package:fitza_mobile_application/features/home/presentation/widgets/home_assets.dart';

/// "Fitness" tab — weekly plan and workout list.
class FitnessScreen extends ConsumerStatefulWidget {
  const FitnessScreen({super.key});

  @override
  ConsumerState<FitnessScreen> createState() => _FitnessScreenState();
}

class _FitnessScreenState extends ConsumerState<FitnessScreen> {
  static const _filters = ['Workout', 'Warm-up', 'Stretch', 'Activity'];
  int _selectedFilter = 0;

  @override
  Widget build(BuildContext context) {
    final day = ref.watch(fitnessDashboardProvider);
    final weekly = ref.watch(weeklyWorkoutStatusProvider);
    final selectedIsoDate = toIsoDate(ref.watch(selectedFitnessDateProvider));

    final dayData = day.value;
    final weeklyData = weekly.value;

    Widget body;
    if (day.hasError) {
      body = Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            _failureMessage(day.error),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              color: AppColors.mutedText,
            ),
          ),
        ),
      );
    } else if (dayData == null) {
      body = const FitnessDashboardSkeleton();
    } else {
      body = ListView(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
        children: [
          _Header(planName: weeklyData?.plan?.name ?? ''),
          const SizedBox(height: 18),
          _FilterChips(
            filters: _filters,
            selectedIndex: _selectedFilter,
            onSelected: (i) => setState(() => _selectedFilter = i),
          ),
          const SizedBox(height: 18),
          _HeroCard(
            day: dayData.day,
            onStart: dayData.day.dayNumber == null
                ? null
                : () => _openWorkout(context, dayData.day),
          ),
          const SizedBox(height: 26),
          const _SectionHeader(title: 'This Week', action: 'View Plan'),
          const SizedBox(height: 12),
          _WeekSection(
            weekly: weekly,
            selectedDate: selectedIsoDate,
            onSelect: (isoDate) {
              final date = DateTime.tryParse(isoDate);
              if (date == null) return;
              ref.read(selectedFitnessDateProvider.notifier).select(date);
            },
          ),
          const SizedBox(height: 24),
          const _SectionTitle('Workout Plan'),
          const SizedBox(height: 12),
          _SelectedDayCard(
            day: dayData.day,
            onTap: dayData.day.dayNumber == null
                ? null
                : () => _openWorkout(context, dayData.day),
          ),
          const SizedBox(height: 10),
          if (dayData.day.exercises.isEmpty)
            _EmptyDayCard(status: dayData.day.status)
          else
            for (final (i, exercise) in dayData.day.exercises.indexed) ...[
              _ExerciseCard(
                exercise: exercise,
                index: i,
                onTap: dayData.day.dayNumber == null ||
                        exercise.planExerciseId.isEmpty
                    ? null
                    : () => _openExercise(context, exercise),
              ),
              const SizedBox(height: 8),
            ],
        ],
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(child: body),
    );
  }
}

String _failureMessage(Object? error) =>
    error is Failure ? error.message : '$error';

void _openWorkout(BuildContext context, FitnessDayEntity day) {
  final dayNumber = day.dayNumber;
  if (dayNumber == null) return;
  context.pushNamed(
    RouteNames.fitnessWorkout,
    pathParameters: {'day': '$dayNumber'},
  );
}

void _openExercise(BuildContext context, FitnessExerciseEntity exercise) {
  if (exercise.planExerciseId.isEmpty) return;
  context.pushNamed(
    RouteNames.exerciseDetails,
    pathParameters: {'planExerciseId': exercise.planExerciseId},
  );
}

String _weekdayShort(String isoDate) {
  final date = DateTime.tryParse(isoDate);
  if (date == null) return '';
  const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  return names[date.weekday - 1];
}

String _weekdayLabel(WeeklyWorkoutDayEntity day) {
  if (day.dayName.length >= 3) return day.dayName.substring(0, 3);
  return _weekdayShort(day.date);
}

String _statusLabel(String status) {
  if (status.isEmpty) return 'Scheduled';
  return status[0].toUpperCase() + status.substring(1);
}

class _Header extends StatelessWidget {
  const _Header({required this.planName});

  final String planName;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Fitness',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                planName.isNotEmpty
                    ? planName
                    : 'Your workout plan and activity',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.mutedText,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 46,
          height: 46,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFEEF1EC)),
            boxShadow: [
              BoxShadow(
                color: AppColors.textDark.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const AssetIcon(
            HomeAsset.calendar,
            size: 20,
            color: AppColors.secondary,
          ),
        ),
      ],
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({
    required this.filters,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> filters;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final (i, label) in filters.indexed) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () => onSelected(i),
              child: Container(
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: i == selectedIndex
                      ? AppColors.secondary
                      : const Color(0xFFF1F4EF),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: i == selectedIndex
                        ? Colors.white
                        : AppColors.textDark,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.day, this.onStart});

  final FitnessDayEntity day;
  final VoidCallback? onStart;

  @override
  Widget build(BuildContext context) {
    final isRest = day.isRest;
    final dayNumber = day.dayNumber;
    final tag = isRest || dayNumber == null
        ? 'REST DAY'
        : 'DAY ${dayNumber.toString().padLeft(2, '0')}';
    final title = isRest
        ? 'Rest & Recover'
        : day.title.isNotEmpty
        ? day.title
        : 'Workout';
    final subtitle = isRest
        ? 'Recovery day · recharge for tomorrow'
        : '${day.exerciseCount} '
              '${day.exerciseCount == 1 ? 'Exercise' : 'Exercises'}';

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(FitnessAsset.hero, fit: BoxFit.fill),
          ),
          // Dark-green wash so the overlay text stays crisp (Figma ref).
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    const Color(0xE60C421F),
                    const Color(0x800C421F),
                    const Color(0x1A0C421F),
                  ],
                  stops: const [0.0, 0.55, 1.0],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9EFC9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
                if (!isRest) ...[
                  const SizedBox(height: 12),
                  _StartWorkoutButton(onTap: onStart),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StartWorkoutButton extends StatelessWidget {
  const _StartWorkoutButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 13, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.play_circle_fill, size: 20, color: AppColors.primary),
              SizedBox(width: 7),
              Text(
                'Start Workout',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.action});

  final String title;
  final String action;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18.5,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                action,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.arrow_forward_rounded,
                size: 17,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18.5,
        fontWeight: FontWeight.w800,
        color: AppColors.textDark,
      ),
    );
  }
}

class _WeekSection extends StatelessWidget {
  const _WeekSection({
    required this.weekly,
    required this.selectedDate,
    required this.onSelect,
  });

  final AsyncValue<WeeklyWorkoutStatusEntity> weekly;
  final String selectedDate;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return weekly.when(
      skipLoadingOnReload: true,
      loading: () => const FitnessWeekSkeleton(),
      error: (error, _) => _InlineMessage(
        icon: Icons.calendar_month_rounded,
        message: _failureMessage(error),
      ),
      data: (data) => data.weeklyStatus.isEmpty
          ? const _InlineMessage(
              icon: Icons.event_busy_rounded,
              message: 'No schedule for this week yet.',
            )
          : _WeekRow(
              days: data.weeklyStatus,
              selectedDate: selectedDate,
              onSelect: onSelect,
            ),
    );
  }
}

class _InlineMessage extends StatelessWidget {
  const _InlineMessage({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEFF1EE)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.mutedText,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeekRow extends StatelessWidget {
  const _WeekRow({
    required this.days,
    required this.selectedDate,
    required this.onSelect,
  });

  final List<WeeklyWorkoutDayEntity> days;
  final String selectedDate;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final (i, day) in days.indexed) ...[
          if (i > 0) const SizedBox(width: 6),
          Expanded(
            child: _WeekDayChip(
              day: day,
              isSelected: day.date == selectedDate,
              onTap: () => onSelect(day.date),
            ),
          ),
        ],
      ],
    );
  }
}

class _WeekDayChip extends StatelessWidget {
  const _WeekDayChip({
    required this.day,
    required this.isSelected,
    required this.onTap,
  });

  final WeeklyWorkoutDayEntity day;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isUpcoming = day.status == 'upcoming';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE5F4DC) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFCDE8BE)
                : const Color(0xFFEFF1EE),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _weekdayLabel(day),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? const Color(0xFF3F6B3F)
                    : AppColors.mutedText,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              day.workoutDayNumber == null
                  ? 'Rest'
                  : 'D${day.workoutDayNumber}',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w800,
                color: isUpcoming && !isSelected
                    ? AppColors.mutedText
                    : AppColors.textDark,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 6),
            if (day.isCompleted)
              Container(
                width: 19,
                height: 19,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, size: 12, color: Colors.white),
              )
            else if (day.isRest)
              Container(
                width: 19,
                height: 19,
                decoration: const BoxDecoration(
                  color: Color(0xFFEDF1EA),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.bedtime_rounded,
                  size: 11,
                  color: AppColors.mutedText,
                ),
              )
            else
              Container(
                width: 17,
                height: 17,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFC9D2CA),
                    width: 1.4,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SelectedDayCard extends StatelessWidget {
  const _SelectedDayCard({required this.day, this.onTap});

  final FitnessDayEntity day;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isRest = day.isRest;
    final count = day.exerciseCount;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: isRest
                  ? const [Color(0xFFF4F6F2), Color(0xFFEDF1EA)]
                  : const [Color(0xFFEFF8E8), Color(0xFFDFF2D0)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: isRest
                    ? const Icon(
                        Icons.spa_rounded,
                        size: 22,
                        color: AppColors.primary,
                      )
                    : const AssetIcon(
                        HomeAsset.dumbbell,
                        size: 22,
                        color: AppColors.primary,
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            isRest
                                ? 'Rest Day'
                                : day.title.isNotEmpty
                                ? day.title
                                : 'Workout',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textDark,
                              height: 1.2,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _StatusBadge(status: day.status),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      isRest
                          ? 'Recovery day · no exercises'
                          : '$count ${count == 1 ? 'exercise' : 'exercises'} '
                                'in this session',
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: AppColors.mutedText,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isRest) ...[
                const SizedBox(width: 8),
                const AssetIcon(
                  HomeAsset.chevronRight,
                  size: 18,
                  color: AppColors.mutedText,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final isCompleted = status == 'completed';
    final isRest = status == 'rest';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: isCompleted ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        _statusLabel(status),
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w800,
          color: isCompleted
              ? Colors.white
              : isRest
              ? AppColors.mutedText
              : AppColors.secondary,
        ),
      ),
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  const _ExerciseCard({
    required this.exercise,
    required this.index,
    this.onTap,
  });

  final FitnessExerciseEntity exercise;
  final int index;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final summary = _exerciseSummary(exercise);

    return Material(
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
              _ExerciseThumbnail(exercise: exercise, index: index),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name.isNotEmpty ? exercise.name : 'Exercise',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                        height: 1.2,
                      ),
                    ),
                    if (summary.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        summary,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: AppColors.mutedText,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xFFEAF5E3),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.secondary,
                  ),
                ),
              ),
              if (onTap != null) ...[
                const SizedBox(width: 4),
                const AssetIcon(
                  HomeAsset.chevronRight,
                  size: 18,
                  color: AppColors.mutedText,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ExerciseThumbnail extends StatelessWidget {
  const _ExerciseThumbnail({required this.exercise, required this.index});

  final FitnessExerciseEntity exercise;
  final int index;

  static const _alignments = [
    Alignment.topLeft,
    Alignment.center,
    Alignment.bottomRight,
    Alignment.topRight,
    Alignment.bottomLeft,
  ];

  @override
  Widget build(BuildContext context) {
    final fallback = Image.asset(
      FitnessAsset.hero,
      width: 52,
      height: 52,
      fit: BoxFit.cover,
      alignment: _alignments[index % _alignments.length],
    );
    final thumbnailPath = exercise.thumbnailPath;
    final isRemote = thumbnailPath.startsWith('http');

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: isRemote
          ? Image.network(
              thumbnailPath,
              width: 52,
              height: 52,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => fallback,
            )
          : fallback,
    );
  }
}

class _EmptyDayCard extends StatelessWidget {
  const _EmptyDayCard({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final isRest = status == 'rest';
    final isCompleted = status == 'completed';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEFF1EC)),
      ),
      child: Column(
        children: [
          Icon(
            isRest
                ? Icons.spa_rounded
                : isCompleted
                ? Icons.verified_rounded
                : Icons.event_note_rounded,
            size: 26,
            color: AppColors.primary,
          ),
          const SizedBox(height: 8),
          Text(
            isRest
                ? 'Rest day — recover & recharge'
                : isCompleted
                ? 'Workout completed'
                : 'No exercises for this day',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            isRest
                ? 'No workout scheduled. Come back tomorrow for your next session.'
                : isCompleted
                ? 'Great work! Your exercises are logged for this day.'
                : 'Exercises will appear here once your plan is updated.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: AppColors.mutedText,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
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

    if (first.restSeconds != null) {
      parts.add('${first.restSeconds}s rest');
    }
  }

  if (parts.isEmpty && exercise.description.isNotEmpty) {
    return exercise.description;
  }
  return parts.join(' · ');
}
