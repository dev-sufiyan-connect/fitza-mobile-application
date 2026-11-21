/// Data returned by the `get_workout_exercise_detail` RPC.
/// Pure business objects — no Flutter imports.
class WorkoutExerciseDetailEntity {
  const WorkoutExerciseDetailEntity({
    required this.sessionId,
    required this.selectedDate,
    required this.workoutDayNumber,
    required this.workoutTitle,
    required this.exercisePosition,
    required this.totalExercises,
    required this.exercise,
    required this.sets,
  });

  /// Active workout session this exercise belongs to. Empty when the RPC
  /// did not return one.
  final String sessionId;
  final String selectedDate;
  final int workoutDayNumber;
  final String workoutTitle;
  final int exercisePosition;
  final int totalExercises;
  final WorkoutExerciseInfoEntity exercise;
  final List<WorkoutExerciseSetEntity> sets;
}

class WorkoutExerciseInfoEntity {
  const WorkoutExerciseInfoEntity({
    required this.planExerciseId,
    required this.exerciseId,
    required this.name,
    required this.description,
    required this.instructions,
    required this.planInstructions,
    required this.difficulty,
    required this.isCompound,
    required this.isUnilateral,
    required this.categoryName,
    required this.thumbnailPath,
    required this.videoPath,
    required this.muscleGroups,
    required this.equipment,
  });

  final String planExerciseId;
  final String exerciseId;
  final String name;
  final String description;
  final List<String> instructions;
  final String? planInstructions;
  final String difficulty;
  final bool isCompound;
  final bool isUnilateral;
  final String categoryName;
  final String thumbnailPath;
  final String videoPath;
  final List<String> muscleGroups;
  final List<String> equipment;
}

class WorkoutExerciseSetEntity {
  const WorkoutExerciseSetEntity({
    required this.setNumber,
    required this.targetRepsMin,
    required this.targetRepsMax,
    required this.targetWeightKg,
    required this.targetDurationSeconds,
    required this.restSeconds,
    required this.targetRpe,
    required this.actualWeightKg,
    required this.actualReps,
    required this.actualDurationSeconds,
    required this.actualRpe,
    required this.isCompleted,
  });

  final int? setNumber;
  final int? targetRepsMin;
  final int? targetRepsMax;
  final double? targetWeightKg;
  final int? targetDurationSeconds;
  final int? restSeconds;
  final double? targetRpe;
  final double? actualWeightKg;
  final int? actualReps;
  final int? actualDurationSeconds;
  final double? actualRpe;
  final bool isCompleted;
}
