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

const _exerciseMuscles = [
  'Upper Chest · Dumbbell',
  'Shoulders · Dumbbell',
  'Chest · Cable',
  'Shoulders · Dumbbell',
  'Triceps · Cable',
  'Core · Cable',
  'Neck · Bodyweight',
];

const _exerciseSets = [
  ExerciseSetEntity(weight: 20, reps: 10, isCompleted: true),
  ExerciseSetEntity(weight: 20, reps: 9, isCompleted: true),
  ExerciseSetEntity(weight: 22.5, reps: 8, isCompleted: false),
];

/// Details for one exercise inside a workout day.
/// [index] is 0-based within the day's exercise list.
final exerciseDetailsProvider =
    FutureProvider.family<ExerciseDetailsEntity, ({int day, int index})>(
        (ref, key) async {
  await Future<void>.delayed(const Duration(milliseconds: 250));

  final workout = await ref.watch(workoutDetailsProvider(key.day).future);
  final exercises = workout.exercises;
  final index = key.index.clamp(0, exercises.length - 1);

  return ExerciseDetailsEntity(
    dayLabel:
        'Day ${key.day.toString().padLeft(2, '0')} · ${workout.title}',
    position: index + 1,
    total: exercises.length,
    name: exercises[index].name,
    subtitle: _exerciseMuscles[index % _exerciseMuscles.length],
    sets: '3',
    reps: '8 – 10',
    rest: '90 sec',
    setRows: _exerciseSets,
  );
});

/// Summary shown after the user finishes a workout day.
final workoutCompletedProvider =
    FutureProvider.family<WorkoutCompletedEntity, int>((ref, day) async {
  await Future<void>.delayed(const Duration(milliseconds: 250));

  final workout = await ref.watch(workoutDetailsProvider(day).future);

  return WorkoutCompletedEntity(
    dayTag: 'Day ${day.toString().padLeft(2, '0')}',
    title: workout.title,
    focus: workout.focus,
    duration: '52 min',
    exercisesCompleted: '7 / 7',
    setsCompleted: '18 / 18',
    calories: '410 kcal',
    volume: '3,480 kg',
    volumeChange: '+8%',
    intensity: 'Moderate',
    intensityBars: 3,
    completion: '100%',
    exercisePreview: [
      for (final exercise in workout.exercises.take(3))
        CompletedExerciseEntity(
          name: exercise.name,
          detail: exercise.setsReps.replaceFirst(' x ', ' · '),
        ),
    ],
    totalExercises: workout.exercises.length,
  );
});
