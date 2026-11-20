/// Workout details / completion data for the fitness flow.
/// Pure business objects — no Flutter imports.
class WorkoutDetailsEntity {
  const WorkoutDetailsEntity({
    required this.tag,
    required this.title,
    required this.focus,
    required this.exercises,
  });

  final String tag;
  final String title;
  final String focus;
  final List<ExerciseEntity> exercises;
}

class ExerciseEntity {
  const ExerciseEntity({
    required this.name,
    required this.setsReps,
  });

  final String name;
  final String setsReps;
}

class ExerciseDetailsEntity {
  const ExerciseDetailsEntity({
    required this.dayLabel,
    required this.position,
    required this.total,
    required this.name,
    required this.subtitle,
    required this.sets,
    required this.reps,
    required this.rest,
    required this.setRows,
  });

  final String dayLabel;
  final int position;
  final int total;
  final String name;
  final String subtitle;
  final String sets;
  final String reps;
  final String rest;
  final List<ExerciseSetEntity> setRows;
}

class ExerciseSetEntity {
  const ExerciseSetEntity({
    required this.weight,
    required this.reps,
    required this.isCompleted,
  });

  final double weight;
  final int reps;
  final bool isCompleted;

  String get weightText => weight == weight.roundToDouble()
      ? weight.toInt().toString()
      : weight.toStringAsFixed(1);
}

class WorkoutCompletedEntity {
  const WorkoutCompletedEntity({
    required this.dayTag,
    required this.title,
    required this.focus,
    required this.duration,
    required this.exercisesCompleted,
    required this.setsCompleted,
    required this.calories,
    required this.volume,
    required this.volumeChange,
    required this.intensity,
    required this.intensityBars,
    required this.completion,
    required this.exercisePreview,
    required this.totalExercises,
  });

  final String dayTag;
  final String title;
  final String focus;
  final String duration;
  final String exercisesCompleted;
  final String setsCompleted;
  final String calories;
  final String volume;
  final String volumeChange;
  final String intensity;
  final int intensityBars;
  final String completion;
  final List<CompletedExerciseEntity> exercisePreview;
  final int totalExercises;
}

class CompletedExerciseEntity {
  const CompletedExerciseEntity({
    required this.name,
    required this.detail,
  });

  final String name;
  final String detail;
}
