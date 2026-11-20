/// Data returned by the `get_exercise_workout_history` RPC.
/// Pure business objects — no Flutter imports.
class ExerciseWorkoutHistoryEntity {
  const ExerciseWorkoutHistoryEntity({
    required this.exerciseId,
    required this.exerciseName,
    required this.workspaceId,
    required this.timezone,
    required this.pagination,
    required this.history,
  });

  final String exerciseId;
  final String exerciseName;
  final String workspaceId;
  final String timezone;
  final ExerciseWorkoutHistoryPaginationEntity pagination;
  final List<ExerciseWorkoutHistorySessionEntity> history;

  bool get isEmpty => history.isEmpty;

  ExerciseWorkoutHistorySessionEntity? get latest =>
      history.isEmpty ? null : history.first;
}

class ExerciseWorkoutHistoryPaginationEntity {
  const ExerciseWorkoutHistoryPaginationEntity({
    required this.limit,
    required this.offset,
    required this.returned,
    required this.total,
    required this.hasMore,
  });

  final int limit;
  final int offset;
  final int returned;
  final int total;
  final bool hasMore;
}

/// One logged workout session that included the exercise.
class ExerciseWorkoutHistorySessionEntity {
  const ExerciseWorkoutHistorySessionEntity({
    required this.sessionId,
    required this.date,
    required this.startedAt,
    required this.endedAt,
    required this.workoutTitle,
    required this.status,
    required this.completedSets,
    required this.totalVolumeKg,
    required this.maxWeightKg,
    required this.maxReps,
    required this.sets,
  });

  final String sessionId;

  /// `yyyy-MM-dd` in the response's timezone.
  final String date;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final String workoutTitle;
  final String status;
  final int completedSets;
  final double totalVolumeKg;
  final double? maxWeightKg;
  final int? maxReps;
  final List<ExerciseWorkoutHistorySetEntity> sets;

  bool get isCompleted => status.toLowerCase() == 'completed';
}

class ExerciseWorkoutHistorySetEntity {
  const ExerciseWorkoutHistorySetEntity({
    required this.setId,
    required this.setNumber,
    required this.weightKg,
    required this.reps,
    required this.durationSeconds,
    required this.restSeconds,
    required this.rpe,
    required this.isCompleted,
    required this.completedAt,
    required this.notes,
  });

  final String setId;
  final int? setNumber;
  final double? weightKg;
  final int? reps;
  final int? durationSeconds;
  final int? restSeconds;
  final double? rpe;
  final bool isCompleted;
  final DateTime? completedAt;
  final String? notes;
}
