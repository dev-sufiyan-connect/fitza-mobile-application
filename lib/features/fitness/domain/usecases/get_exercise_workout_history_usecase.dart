import 'package:fitza_mobile_application/core/utils/result.dart';
import 'package:fitza_mobile_application/features/fitness/domain/entities/exercise_workout_history_entity.dart';
import 'package:fitza_mobile_application/features/fitness/domain/repositories/fitness_repository.dart';

/// Loads the logged session history for a single exercise via the
/// `get_exercise_workout_history` RPC.
class GetExerciseWorkoutHistoryUseCase {
  const GetExerciseWorkoutHistoryUseCase(this._repository);

  final FitnessRepository _repository;

  Future<Result<ExerciseWorkoutHistoryEntity>> call({
    required String exerciseId,
    int limit = 20,
    int offset = 0,
  }) => _repository.getExerciseWorkoutHistory(
    exerciseId: exerciseId,
    limit: limit,
    offset: offset,
  );
}
