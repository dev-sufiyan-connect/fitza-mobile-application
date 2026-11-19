import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitza_mobile_application/features/fitness/domain/entities/fitness_entity.dart';

/// TODO: replace with use case + repository once the fitness feature has a
/// real data layer. Kept as a provider so the UI contract stays stable.
final fitnessProvider = FutureProvider<FitnessEntity>((ref) async {
  await Future<void>.delayed(const Duration(milliseconds: 300));

  return const FitnessEntity(
    week: [
      FitnessWeekDayEntity(
          day: 'Mon', label: 'D1', isSelected: true, isCompleted: true),
      FitnessWeekDayEntity(
          day: 'Tue', label: 'D2', isSelected: false, isCompleted: false),
      FitnessWeekDayEntity(
          day: 'Wed', label: 'D3', isSelected: false, isCompleted: false),
      FitnessWeekDayEntity(
          day: 'Thu', label: 'D4', isSelected: false, isCompleted: false),
      FitnessWeekDayEntity(
          day: 'Fri', label: 'D5', isSelected: false, isCompleted: false),
      FitnessWeekDayEntity(
          day: 'Sat', label: 'Rest', isSelected: false, isCompleted: false),
      FitnessWeekDayEntity(
          day: 'Sun', label: 'Rest', isSelected: false, isCompleted: false),
    ],
    workoutPlan: [
      WorkoutDayEntity(
        title: 'Day 1 – Chest, Shoulders & Triceps',
        exercises: '7 Exercises',
        isCompleted: true,
      ),
      WorkoutDayEntity(
        title: 'Day 2 – Back, Biceps & Forearms',
        exercises: '6 Exercises',
        isCompleted: false,
      ),
      WorkoutDayEntity(
        title: 'Day 3 – Legs',
        exercises: '6 Exercises',
        isCompleted: false,
      ),
      WorkoutDayEntity(
        title: 'Day 4 – Mixed Upper & Lower Body',
        exercises: '8 Exercises',
        isCompleted: false,
      ),
      WorkoutDayEntity(
        title: 'Day 5 – Back, Arms & Legs',
        exercises: '7 Exercises',
        isCompleted: false,
      ),
    ],
  );
});

const _workoutTitles = [
  'Chest, Shoulders & Triceps',
  'Back, Biceps & Forearms',
  'Legs',
  'Mixed Upper & Lower Body',
  'Back, Arms & Legs',
];

const _dayOneExercises = [
  ExerciseEntity(name: 'Incline DB Bench Press', setsReps: '3 sets x 8–10 reps'),
  ExerciseEntity(name: 'Seated DB Press', setsReps: '2 sets x 10–12 reps'),
  ExerciseEntity(name: 'Cable Cross Over', setsReps: '2 sets x 10–15 reps'),
  ExerciseEntity(
      name: 'DB Side Lateral Raises', setsReps: '3 sets x 10–15 reps'),
  ExerciseEntity(
      name: 'Dual Cross Body Tricep Push Down',
      setsReps: '4 sets x 10–15 reps'),
  ExerciseEntity(name: 'Cable Crunches', setsReps: '2 sets x 10–15 reps'),
  ExerciseEntity(name: 'Neck Flexion', setsReps: '2 sets x 15–20 reps'),
];

/// Details for a single workout day. [day] is 1-based.
final workoutDetailsProvider =
    FutureProvider.family<WorkoutDetailsEntity, int>((ref, day) async {
  await Future<void>.delayed(const Duration(milliseconds: 300));

  final index = (day - 1).clamp(0, _workoutTitles.length - 1);

  return WorkoutDetailsEntity(
    tag: 'DAY 0$day',
    title: _workoutTitles[index],
    focus: 'Push day · ${_dayOneExercises.length} exercises',
    exercises: _dayOneExercises,
  );
});
