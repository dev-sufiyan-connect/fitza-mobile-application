/// Data returned by the `get_fitness_dashboard` RPC.
/// Pure business objects — no Flutter imports.
class FitnessDashboardEntity {
  const FitnessDashboardEntity({
    required this.selectedDate,
    required this.day,
  });

  final String selectedDate;
  final FitnessDayEntity day;
}

class FitnessDayEntity {
  const FitnessDayEntity({
    required this.dayNumber,
    required this.title,
    required this.status,
    required this.exerciseCount,
    required this.exercises,
  });

  final int? dayNumber;
  final String title;

  /// `pending`, `completed`, `rest` or `upcoming`.
  final String status;
  final int exerciseCount;
  final List<FitnessExerciseEntity> exercises;

  bool get isRest => status == 'rest';
  bool get isCompleted => status == 'completed';
}

class FitnessExerciseEntity {
  const FitnessExerciseEntity({
    required this.planExerciseId,
    required this.exerciseId,
    required this.name,
    required this.description,
    required this.instructions,
    required this.thumbnailPath,
    required this.videoPath,
    required this.sortOrder,
    required this.notes,
    required this.sets,
  });

  final String planExerciseId;
  final String exerciseId;
  final String name;
  final String description;
  final List<String> instructions;
  final String thumbnailPath;
  final String videoPath;
  final int sortOrder;
  final String? notes;
  final List<FitnessExerciseSetEntity> sets;
}

class FitnessExerciseSetEntity {
  const FitnessExerciseSetEntity({
    required this.setNumber,
    required this.targetRepsMin,
    required this.targetRepsMax,
    required this.targetWeightKg,
    required this.targetDurationSeconds,
    required this.restSeconds,
    required this.targetRpe,
    required this.notes,
  });

  final int? setNumber;
  final int? targetRepsMin;
  final int? targetRepsMax;
  final double? targetWeightKg;
  final int? targetDurationSeconds;
  final int? restSeconds;
  final double? targetRpe;
  final String? notes;
}
