/// Fitness tab data: weekly schedule and workout plan.
/// Pure business objects — no Flutter imports.
class FitnessEntity {
  const FitnessEntity({
    required this.week,
    required this.workoutPlan,
  });

  final List<FitnessWeekDayEntity> week;
  final List<WorkoutDayEntity> workoutPlan;
}

class FitnessWeekDayEntity {
  const FitnessWeekDayEntity({
    required this.day,
    required this.label,
    required this.isSelected,
    required this.isCompleted,
  });

  final String day;
  final String label;
  final bool isSelected;
  final bool isCompleted;
}

class WorkoutDayEntity {
  const WorkoutDayEntity({
    required this.title,
    required this.exercises,
    required this.isCompleted,
  });

  final String title;
  final String exercises;
  final bool isCompleted;
}

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
