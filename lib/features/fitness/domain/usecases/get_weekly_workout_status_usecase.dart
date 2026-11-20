import 'package:fitza_mobile_application/core/utils/result.dart';
import 'package:fitza_mobile_application/features/fitness/domain/entities/weekly_workout_entity.dart';
import 'package:fitza_mobile_application/features/fitness/domain/repositories/fitness_repository.dart';

/// Loads the weekly calendar, plan info and per-day statuses via the
/// `get_weekly_workout_status` RPC.
class GetWeeklyWorkoutStatusUseCase {
  const GetWeeklyWorkoutStatusUseCase(this._repository);

  final FitnessRepository _repository;

  Future<Result<WeeklyWorkoutStatusEntity>> call({
    required String selectedDate,
  }) =>
      _repository.getWeeklyWorkoutStatus(selectedDate: selectedDate);
}
