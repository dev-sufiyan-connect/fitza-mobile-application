import 'package:fitza_mobile_application/core/utils/result.dart';
import 'package:fitza_mobile_application/features/fitness/domain/entities/workout_exercise_detail_entity.dart';
import 'package:fitza_mobile_application/features/fitness/domain/repositories/fitness_repository.dart';

/// Loads a single exercise's details and prescribed sets via the
/// `get_workout_exercise_detail` RPC.
class GetWorkoutExerciseDetailUseCase {
  const GetWorkoutExerciseDetailUseCase(this._repository);

  final FitnessRepository _repository;

  Future<Result<WorkoutExerciseDetailEntity>> call({
    required String selectedDate,
    required String planExerciseId,
  }) => _repository.getWorkoutExerciseDetail(
    selectedDate: selectedDate,
    planExerciseId: planExerciseId,
  );
}
