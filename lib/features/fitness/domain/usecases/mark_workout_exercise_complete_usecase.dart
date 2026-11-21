import 'package:fitza_mobile_application/core/utils/result.dart';
import 'package:fitza_mobile_application/features/fitness/domain/entities/mark_workout_exercise_complete_entity.dart';
import 'package:fitza_mobile_application/features/fitness/domain/repositories/fitness_repository.dart';

/// Saves the logged sets for one exercise and marks it complete via the
/// `mark_workout_exercise_complete` RPC.
class MarkWorkoutExerciseCompleteUseCase {
  const MarkWorkoutExerciseCompleteUseCase(this._repository);

  final FitnessRepository _repository;

  Future<Result<MarkWorkoutExerciseCompleteEntity>> call({
    required String sessionId,
    required String planExerciseId,
    required List<WorkoutSetLogEntity> sets,
    String? exerciseNotes,
    String? sessionNote,
  }) => _repository.markWorkoutExerciseComplete(
    sessionId: sessionId,
    planExerciseId: planExerciseId,
    sets: sets,
    exerciseNotes: exerciseNotes,
    sessionNote: sessionNote,
  );
}
