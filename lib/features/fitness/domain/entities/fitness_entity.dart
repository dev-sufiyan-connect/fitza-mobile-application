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
  const ExerciseEntity({required this.name, required this.setsReps});

  final String name;
  final String setsReps;
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
  const CompletedExerciseEntity({required this.name, required this.detail});

  final String name;
  final String detail;
}
