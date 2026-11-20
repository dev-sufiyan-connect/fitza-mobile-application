import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitza_mobile_application/core/error/failures.dart';
import 'package:fitza_mobile_application/core/theme/app_colors.dart';
import 'package:fitza_mobile_application/core/widgets/shimmer.dart';
import 'package:fitza_mobile_application/features/fitness/domain/entities/exercise_workout_history_entity.dart';
import 'package:fitza_mobile_application/features/fitness/presentation/providers/fitness_providers.dart';

/// Compact pill placed at the end of the "Track Your Sets" row.
///
/// Tapping it opens [ExerciseWorkoutHistorySheet], which performs the
/// `get_exercise_workout_history` RPC and renders the response.
class ExerciseWorkoutHistoryButton extends StatelessWidget {
  const ExerciseWorkoutHistoryButton({super.key, required this.exerciseId});

  final String exerciseId;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: () => showExerciseWorkoutHistorySheet(
          context,
          exerciseId: exerciseId,
        ),
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFDCE6D8)),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.history_rounded,
                size: 14,
                color: AppColors.secondary,
              ),
              SizedBox(width: 5),
              Text(
                'View History',
                style: TextStyle(
                  fontSize: 11.5,
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

Future<void> showExerciseWorkoutHistorySheet(
  BuildContext context, {
  required String exerciseId,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.35),
    builder: (_) => ExerciseWorkoutHistorySheet(exerciseId: exerciseId),
  );
}

class ExerciseWorkoutHistorySheet extends ConsumerStatefulWidget {
  const ExerciseWorkoutHistorySheet({super.key, required this.exerciseId});

  final String exerciseId;

  @override
  ConsumerState<ExerciseWorkoutHistorySheet> createState() =>
      _ExerciseWorkoutHistorySheetState();
}

class _ExerciseWorkoutHistorySheetState
    extends ConsumerState<ExerciseWorkoutHistorySheet> {
  @override
  void initState() {
    super.initState();
    // Fetch as soon as the sheet is shown — the user already tapped
    // "View History", so no extra button is needed here.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _load();
    });
  }

  void _load() {
    ref.read(exerciseWorkoutHistoryProvider(widget.exerciseId).notifier).load();
  }

  @override
  Widget build(BuildContext context) {
    final history = ref.watch(
      exerciseWorkoutHistoryProvider(widget.exerciseId),
    );

    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.85,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFDDE2DA),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 12, 4),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Workout History',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(18),
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child: Icon(
                        Icons.close_rounded,
                        size: 20,
                        color: AppColors.mutedText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                child: _sheetBody(history),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sheetBody(AsyncValue<ExerciseWorkoutHistoryEntity?> history) {
    final data = history.value;
    if (data != null) return _HistoryBody(history: data);

    if (history.hasError) {
      return _HistoryMessage(
        icon: Icons.cloud_off_rounded,
        title: 'Could not load history',
        message: _failureMessage(history.error),
        actionLabel: 'Try again',
        onAction: _load,
      );
    }

    if (history.isLoading) return const _HistorySkeleton();

    return _HistoryMessage(
      icon: Icons.event_note_rounded,
      title: 'No history yet',
      message: 'Complete a workout with this exercise and your sessions '
          'will appear here.',
      actionLabel: 'Refresh',
      onAction: _load,
    );
  }
}

class _HistorySkeleton extends StatelessWidget {
  const _HistorySkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Shimmer(
          child: Row(
            children: [
              ShimmerBox(width: 120, height: 12),
              Spacer(),
              ShimmerBox(width: 88, height: 12),
            ],
          ),
        ),
        for (var i = 0; i < 2; i++) ...[
          const SizedBox(height: 12),
          const _SkeletonSessionCard(),
        ],
      ],
    );
  }
}

class _SkeletonSessionCard extends StatelessWidget {
  const _SkeletonSessionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9F5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEFF1EC)),
      ),
      child: const Shimmer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ShimmerBox(width: 132, height: 13),
                Spacer(),
                ShimmerBox(width: 62, height: 16, radius: 8),
              ],
            ),
            SizedBox(height: 8),
            ShimmerBox(width: 148, height: 10),
            SizedBox(height: 14),
            Row(
              children: [
                Expanded(child: _SkeletonStat()),
                SizedBox(width: 20),
                Expanded(child: _SkeletonStat()),
                SizedBox(width: 20),
                Expanded(child: _SkeletonStat()),
              ],
            ),
            SizedBox(height: 12),
            Divider(height: 1, thickness: 1, color: Color(0xFFE9EDE6)),
            SizedBox(height: 8),
            _SkeletonSetRow(),
            _SkeletonSetRow(),
            _SkeletonSetRow(),
          ],
        ),
      ),
    );
  }
}

class _SkeletonStat extends StatelessWidget {
  const _SkeletonStat();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerBox(width: 32, height: 9),
        SizedBox(height: 5),
        ShimmerBox(width: 44, height: 13),
      ],
    );
  }
}

class _SkeletonSetRow extends StatelessWidget {
  const _SkeletonSetRow();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          ShimmerBox(width: 22, height: 22, shape: BoxShape.circle),
          SizedBox(width: 8),
          ShimmerBox(width: 112, height: 11),
          Spacer(),
          ShimmerBox(width: 15, height: 15, shape: BoxShape.circle),
        ],
      ),
    );
  }
}

class _HistoryBody extends StatelessWidget {
  const _HistoryBody({required this.history});

  final ExerciseWorkoutHistoryEntity history;

  @override
  Widget build(BuildContext context) {
    final latest = history.latest;

    if (history.isEmpty) {
      return _HistoryMessage(
        icon: Icons.event_note_rounded,
        title: 'No history yet',
        message: 'Complete a workout with this exercise and your sessions '
            'will appear here.',
        actionLabel: 'Refresh',
        onAction: null,
      );
    }

    final total = history.pagination.total;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '$total ${total == 1 ? 'session' : 'sessions'} logged',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
            ),
            if (latest != null)
              Text(
                'Last ${_dateLabel(latest.date)}',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.mutedText,
                ),
              ),
          ],
        ),
        for (final session in history.history) ...[
          const SizedBox(height: 10),
          _SessionCard(session: session),
        ],
        if (history.pagination.hasMore) ...[
          const SizedBox(height: 8),
          Text(
            'Showing ${history.pagination.returned} of $total sessions',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.mutedText,
            ),
          ),
        ],
      ],
    );
  }
}

class _SessionCard extends StatelessWidget {
  const _SessionCard({required this.session});

  final ExerciseWorkoutHistorySessionEntity session;

  @override
  Widget build(BuildContext context) {
    final meta = <String>[
      _dateLabel(session.date),
      if (_durationLabel(session.startedAt, session.endedAt) case final d?)
        d,
    ].join(' · ');

    final topSet = session.maxWeightKg == null
        ? '—'
        : '${_numberLabel(session.maxWeightKg!)} kg'
            '${session.maxReps == null ? '' : ' × ${session.maxReps}'}';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9F5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEFF1EC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  session.workoutTitle.isEmpty
                      ? 'Workout session'
                      : session.workoutTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              if (session.status.isNotEmpty) ...[
                const SizedBox(width: 8),
                _StatusPill(
                  label: _capitalize(session.status),
                  positive: session.isCompleted,
                ),
              ],
            ],
          ),
          const SizedBox(height: 3),
          Text(
            meta,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.mutedText,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _SessionStat(
                  label: 'Sets',
                  value: '${session.completedSets}',
                ),
              ),
              const _StatDivider(),
              Expanded(
                child: _SessionStat(
                  label: 'Volume',
                  value: '${_numberLabel(session.totalVolumeKg)} kg',
                ),
              ),
              const _StatDivider(),
              Expanded(
                child: _SessionStat(label: 'Top set', value: topSet),
              ),
            ],
          ),
          if (session.sets.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(height: 1, color: const Color(0xFFE9EDE6)),
            const SizedBox(height: 6),
            for (final (i, set) in session.sets.indexed)
              _SetRow(index: i, set: set),
          ],
        ],
      ),
    );
  }
}

class _SetRow extends StatelessWidget {
  const _SetRow({required this.index, required this.set});

  final int index;
  final ExerciseWorkoutHistorySetEntity set;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFFE5F4DC),
              shape: BoxShape.circle,
            ),
            child: Text(
              '${set.setNumber ?? index + 1}',
              style: const TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
                color: AppColors.secondary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _setLoad(set),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
          ),
          if (set.rpe != null) ...[
            Text(
              'RPE ${_numberLabel(set.rpe!)}',
              style: const TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                color: AppColors.mutedText,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Icon(
            set.isCompleted
                ? Icons.check_circle_rounded
                : Icons.remove_circle_outline_rounded,
            size: 15,
            color: set.isCompleted
                ? AppColors.primary
                : const Color(0xFFC9D2CA),
          ),
        ],
      ),
    );
  }
}

class _SessionStat extends StatelessWidget {
  const _SessionStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
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
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 24,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      color: const Color(0xFFE9EDE6),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.positive});

  final String label;
  final bool positive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: positive ? const Color(0xFFE5F4DC) : const Color(0xFFF0F1EF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 9.5,
          fontWeight: FontWeight.w800,
          color: positive ? AppColors.secondary : AppColors.mutedText,
        ),
      ),
    );
  }
}

class _HistoryMessage extends StatelessWidget {
  const _HistoryMessage({
    required this.icon,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9F5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEFF1EC)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.mutedText),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: AppColors.mutedText,
                    height: 1.4,
                  ),
                ),
                if (onAction != null) ...[
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: onAction,
                    child: Text(
                      actionLabel,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _failureMessage(Object? error) =>
    error is Failure ? error.message : '$error';

String _setLoad(ExerciseWorkoutHistorySetEntity set) {
  final parts = <String>[
    if (set.weightKg != null) '${_numberLabel(set.weightKg!)} kg',
    if (set.reps != null) '${set.reps} reps',
    if (set.durationSeconds != null) '${set.durationSeconds}s',
  ];
  return parts.isEmpty ? 'Logged set' : parts.join(' × ');
}

/// `16 Nov 2026` from the RPC's `yyyy-MM-dd` date.
String _dateLabel(String raw) {
  final parts = raw.split('-');
  if (parts.length != 3) return raw;

  final month = int.tryParse(parts[1]);
  final day = int.tryParse(parts[2]);
  if (month == null || day == null || month < 1 || month > 12) return raw;

  return '$day ${_months[month - 1]} ${parts[0]}';
}

String? _durationLabel(DateTime? startedAt, DateTime? endedAt) {
  if (startedAt == null || endedAt == null) return null;

  final minutes = endedAt.difference(startedAt).inMinutes;
  if (minutes <= 0) return null;
  if (minutes < 60) return '$minutes min';

  final hours = minutes ~/ 60;
  final remainder = minutes % 60;
  return remainder == 0 ? '$hours hr' : '$hours hr $remainder min';
}

String _numberLabel(double value) => value == value.roundToDouble()
    ? '${value.toInt()}'
    : value.toStringAsFixed(1);

String _capitalize(String value) =>
    value.isEmpty ? value : '${value[0].toUpperCase()}${value.substring(1)}';

const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];
