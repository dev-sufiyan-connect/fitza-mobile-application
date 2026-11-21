/// One set logged for an exercise while finishing it. Sent to the
/// `mark_workout_exercise_complete` RPC.
class WorkoutSetLogEntity {
  const WorkoutSetLogEntity({
    required this.setNumber,
    required this.actualWeightKg,
    required this.actualReps,
    required this.isCompleted,
    required this.notes,
  });

  final int setNumber;
  final double? actualWeightKg;
  final int? actualReps;
  final bool isCompleted;
  final String? notes;
}

/// Result of saving an exercise inside the current workout session.
class MarkWorkoutExerciseCompleteEntity {
  const MarkWorkoutExerciseCompleteEntity({
    required this.success,
    required this.sessionId,
    required this.sessionExerciseId,
    required this.planExerciseId,
    required this.exerciseCompleted,
    required this.completedExercises,
    required this.totalExercises,
    required this.sessionCompleted,
    required this.savedSets,
    required this.message,
  });

  final bool success;
  final String sessionId;
  final String sessionExerciseId;
  final String planExerciseId;
  final bool exerciseCompleted;
  final int completedExercises;
  final int totalExercises;
  final bool sessionCompleted;
  final int savedSets;
  final String message;

  /// `true` when every exercise of the session is done.
  bool get isWorkoutFinished => sessionCompleted;
}
