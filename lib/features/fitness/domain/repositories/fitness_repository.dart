import 'package:fitza_mobile_application/core/utils/result.dart';
import 'package:fitza_mobile_application/features/fitness/domain/entities/exercise_workout_history_entity.dart';
import 'package:fitza_mobile_application/features/fitness/domain/entities/fitness_dashboard_entity.dart';
import 'package:fitza_mobile_application/features/fitness/domain/entities/weekly_workout_entity.dart';
import 'package:fitza_mobile_application/features/fitness/domain/entities/workout_exercise_detail_entity.dart';

/// Contract for the Fitness tab: selected day details and weekly status.
abstract interface class FitnessRepository {
  Future<Result<FitnessDashboardEntity>> getFitnessDashboard({
    required String selectedDate,
  });

  Future<Result<WeeklyWorkoutStatusEntity>> getWeeklyWorkoutStatus({
    required String selectedDate,
  });

  Future<Result<WorkoutExerciseDetailEntity>> getWorkoutExerciseDetail({
    required String selectedDate,
    required String planExerciseId,
  });

  Future<Result<ExerciseWorkoutHistoryEntity>> getExerciseWorkoutHistory({
    required String exerciseId,
    required int limit,
    required int offset,
  });
}
