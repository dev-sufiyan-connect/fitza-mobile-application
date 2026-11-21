import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitza_mobile_application/core/di/core_providers.dart';
import 'package:fitza_mobile_application/core/utils/date_utils.dart';
import 'package:fitza_mobile_application/features/fitness/data/datasources/fitness_remote_data_source.dart';
import 'package:fitza_mobile_application/features/fitness/data/repositories/fitness_repository_impl.dart';
import 'package:fitza_mobile_application/features/fitness/domain/entities/exercise_workout_history_entity.dart';
import 'package:fitza_mobile_application/features/fitness/domain/entities/fitness_dashboard_entity.dart';
import 'package:fitza_mobile_application/features/fitness/domain/entities/fitness_entity.dart';
import 'package:fitza_mobile_application/features/fitness/domain/entities/mark_workout_exercise_complete_entity.dart';
import 'package:fitza_mobile_application/features/fitness/domain/entities/weekly_workout_entity.dart';
import 'package:fitza_mobile_application/features/fitness/domain/entities/workout_exercise_detail_entity.dart';
import 'package:fitza_mobile_application/features/fitness/domain/usecases/get_exercise_workout_history_usecase.dart';
import 'package:fitza_mobile_application/features/fitness/domain/usecases/get_fitness_dashboard_usecase.dart';
import 'package:fitza_mobile_application/features/fitness/domain/usecases/get_weekly_workout_status_usecase.dart';
import 'package:fitza_mobile_application/features/fitness/domain/usecases/get_workout_exercise_detail_usecase.dart';
import 'package:fitza_mobile_application/features/fitness/domain/usecases/mark_workout_exercise_complete_usecase.dart';

// ---------------------------------------------------------------------------
// DI composition
// ---------------------------------------------------------------------------

final fitnessRemoteDataSourceProvider = Provider<FitnessRemoteDataSource>(
  (ref) => FitnessRemoteDataSource(ref.watch(supabaseClientProvider)),
);

final fitnessRepositoryProvider = Provider<FitnessRepositoryImpl>(
  (ref) => FitnessRepositoryImpl(ref.watch(fitnessRemoteDataSourceProvider)),
);

final getFitnessDashboardUseCaseProvider =
    Provider<GetFitnessDashboardUseCase>(
  (ref) => GetFitnessDashboardUseCase(ref.watch(fitnessRepositoryProvider)),
);

final getWeeklyWorkoutStatusUseCaseProvider =
    Provider<GetWeeklyWorkoutStatusUseCase>(
  (ref) => GetWeeklyWorkoutStatusUseCase(ref.watch(fitnessRepositoryProvider)),
);

final getWorkoutExerciseDetailUseCaseProvider =
    Provider<GetWorkoutExerciseDetailUseCase>(
  (ref) => GetWorkoutExerciseDetailUseCase(ref.watch(fitnessRepositoryProvider)),
);

final getExerciseWorkoutHistoryUseCaseProvider =
    Provider<GetExerciseWorkoutHistoryUseCase>(
  (ref) => GetExerciseWorkoutHistoryUseCase(ref.watch(fitnessRepositoryProvider)),
);

final markWorkoutExerciseCompleteUseCaseProvider =
    Provider<MarkWorkoutExerciseCompleteUseCase>(
  (ref) => MarkWorkoutExerciseCompleteUseCase(
    ref.watch(fitnessRepositoryProvider),
  ),
);

// ---------------------------------------------------------------------------
// Selected date (drives the API call)
// ---------------------------------------------------------------------------

/// Currently selected calendar day. Tapping a "This Week" chip updates this,
/// which re-runs `get_fitness_dashboard` with the new `p_selected_date`.
class SelectedFitnessDate extends Notifier<DateTime> {
  @override
  DateTime build() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  void select(DateTime date) {
    state = DateTime(date.year, date.month, date.day);
  }
}

final selectedFitnessDateProvider =
    NotifierProvider<SelectedFitnessDate, DateTime>(SelectedFitnessDate.new);

/// Date captured when the fitness tab is first opened. The weekly RPC is a
/// one-time load for this week — it must not depend on the selected calendar
/// day, otherwise every chip tap triggers another `get_weekly_workout_status`.
final fitnessInitialDateProvider = Provider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});

/// Selected day's workout (hero card + exercise list).
final fitnessDashboardProvider =
    FutureProvider<FitnessDashboardEntity>((ref) async {
  final selectedDate = ref.watch(selectedFitnessDateProvider);
  final result = await ref.watch(getFitnessDashboardUseCaseProvider)(
    selectedDate: toIsoDate(selectedDate),
  );

  return result.when(
    onSuccess: (dashboard) => dashboard,
    onFailure: (failure) => throw failure,
  );
});

/// Week calendar, plan info and per-day statuses.
///
/// Loaded once with the date the tab was opened on; selecting other calendar
/// days never re-runs `get_weekly_workout_status`.
final weeklyWorkoutStatusProvider =
    FutureProvider<WeeklyWorkoutStatusEntity>((ref) async {
  final initialDate = ref.watch(fitnessInitialDateProvider);
  final result = await ref.watch(getWeeklyWorkoutStatusUseCaseProvider)(
    selectedDate: toIsoDate(initialDate),
  );

  return result.when(
    onSuccess: (weekly) => weekly,
    onFailure: (failure) => throw failure,
  );
});

/// Single exercise details, including the prescribed sets for the selected
/// workout date.
final workoutExerciseDetailProvider = FutureProvider.family<
    WorkoutExerciseDetailEntity,
    ({String selectedDate, String planExerciseId})>((ref, key) async {
  final result = await ref.watch(getWorkoutExerciseDetailUseCaseProvider)(
    selectedDate: key.selectedDate,
    planExerciseId: key.planExerciseId,
  );

  return result.when(
    onSuccess: (details) => details,
    onFailure: (failure) => throw failure,
  );
});

/// Lazily loaded history for a single exercise.
///
/// Starts idle (`data == null`); [load] performs the
/// `get_exercise_workout_history` RPC when the user asks for it.
class ExerciseWorkoutHistoryController
    extends AsyncNotifier<ExerciseWorkoutHistoryEntity?> {
  ExerciseWorkoutHistoryController(this.exerciseId);

  final String exerciseId;

  @override
  Future<ExerciseWorkoutHistoryEntity?> build() async => null;

  Future<void> load({int limit = 20, int offset = 0}) async {
    state = const AsyncLoading();

    final result = await ref.read(getExerciseWorkoutHistoryUseCaseProvider)(
      exerciseId: exerciseId,
      limit: limit,
      offset: offset,
    );

    if (!ref.mounted) return;

    state = result.when(
      onSuccess: AsyncData.new,
      onFailure: (failure) => AsyncError(failure, StackTrace.current),
    );
  }
}

final exerciseWorkoutHistoryProvider = AsyncNotifierProvider.family<
    ExerciseWorkoutHistoryController,
    ExerciseWorkoutHistoryEntity?,
    String>(ExerciseWorkoutHistoryController.new);

/// Saves one exercise of the active session. Idle until [submit] is called.
class MarkWorkoutExerciseCompleteController
    extends AsyncNotifier<MarkWorkoutExerciseCompleteEntity?> {
  MarkWorkoutExerciseCompleteController(this.planExerciseId);

  final String planExerciseId;

  @override
  Future<MarkWorkoutExerciseCompleteEntity?> build() async => null;

  /// Returns the saved result, or `null` when the call failed — the error is
  /// exposed through this provider's [AsyncValue].
  Future<MarkWorkoutExerciseCompleteEntity?> submit({
    required String sessionId,
    required List<WorkoutSetLogEntity> sets,
    String? exerciseNotes,
    String? sessionNote,
  }) async {
    if (state.isLoading) return null;

    state = const AsyncLoading();

    final result = await ref.read(markWorkoutExerciseCompleteUseCaseProvider)(
      sessionId: sessionId,
      planExerciseId: planExerciseId,
      sets: sets,
      exerciseNotes: exerciseNotes,
      sessionNote: sessionNote,
    );

    if (!ref.mounted) return null;

    return result.when(
      onSuccess: (value) {
        state = AsyncData(value);
        return value;
      },
      onFailure: (failure) {
        state = AsyncError(failure, StackTrace.current);
        return null;
      },
    );
  }
}

final markWorkoutExerciseCompleteProvider = AsyncNotifierProvider.family<
    MarkWorkoutExerciseCompleteController,
    MarkWorkoutExerciseCompleteEntity?,
    String>(MarkWorkoutExerciseCompleteController.new);

// ---------------------------------------------------------------------------
// Workout completion (still mock data)
// TODO: replace with completion/session RPCs once those endpoints exist.
// ---------------------------------------------------------------------------

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
