import 'package:fitza_mobile_application/core/utils/result.dart';
import 'package:fitza_mobile_application/features/fitness/domain/entities/fitness_dashboard_entity.dart';
import 'package:fitza_mobile_application/features/fitness/domain/repositories/fitness_repository.dart';

/// Loads the weekly plan and selected day's exercises via the
/// `get_fitness_dashboard` RPC.
class GetFitnessDashboardUseCase {
  const GetFitnessDashboardUseCase(this._repository);

  final FitnessRepository _repository;

  Future<Result<FitnessDashboardEntity>> call({required String selectedDate}) =>
      _repository.getFitnessDashboard(selectedDate: selectedDate);
}
