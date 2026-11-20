import 'package:fitza_mobile_application/core/error/failures.dart';
import 'package:fitza_mobile_application/core/utils/result.dart';
import 'package:fitza_mobile_application/features/fitness/data/datasources/fitness_remote_data_source.dart';
import 'package:fitza_mobile_application/features/fitness/domain/entities/exercise_workout_history_entity.dart';
import 'package:fitza_mobile_application/features/fitness/domain/entities/fitness_dashboard_entity.dart';
import 'package:fitza_mobile_application/features/fitness/domain/entities/weekly_workout_entity.dart';
import 'package:fitza_mobile_application/features/fitness/domain/entities/workout_exercise_detail_entity.dart';
import 'package:fitza_mobile_application/features/fitness/domain/repositories/fitness_repository.dart';

/// Production implementation of [FitnessRepository].
///
/// Translates data-source exceptions into [Result]s.
class FitnessRepositoryImpl implements FitnessRepository {
  FitnessRepositoryImpl(this._remoteDataSource);

  final FitnessRemoteDataSource _remoteDataSource;

  @override
  Future<Result<FitnessDashboardEntity>> getFitnessDashboard({
    required String selectedDate,
  }) async {
    try {
      final model = await _remoteDataSource.getFitnessDashboard(
        selectedDate: selectedDate,
      );
      return Success(model.toEntity());
    } catch (e) {
      return FailureResult(e.toFailure());
    }
  }

  @override
  Future<Result<WeeklyWorkoutStatusEntity>> getWeeklyWorkoutStatus({
    required String selectedDate,
  }) async {
    try {
      final model = await _remoteDataSource.getWeeklyWorkoutStatus(
        selectedDate: selectedDate,
      );
      return Success(model.toEntity());
    } catch (e) {
      return FailureResult(e.toFailure());
    }
  }

  @override
  Future<Result<WorkoutExerciseDetailEntity>> getWorkoutExerciseDetail({
    required String selectedDate,
    required String planExerciseId,
  }) async {
    try {
      final model = await _remoteDataSource.getWorkoutExerciseDetail(
        selectedDate: selectedDate,
        planExerciseId: planExerciseId,
      );
      return Success(model.toEntity());
    } catch (e) {
      return FailureResult(e.toFailure());
    }
  }

  @override
  Future<Result<ExerciseWorkoutHistoryEntity>> getExerciseWorkoutHistory({
    required String exerciseId,
    required int limit,
    required int offset,
  }) async {
    try {
      final model = await _remoteDataSource.getExerciseWorkoutHistory(
        exerciseId: exerciseId,
        limit: limit,
        offset: offset,
      );
      return Success(model.toEntity());
    } catch (e) {
      return FailureResult(e.toFailure());
    }
  }
}
