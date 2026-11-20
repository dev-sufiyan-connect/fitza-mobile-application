import 'package:fitza_mobile_application/core/utils/result.dart';
import 'package:fitza_mobile_application/features/home/domain/entities/home_dashboard_entity.dart';
import 'package:fitza_mobile_application/features/home/domain/repositories/home_repository.dart';

/// Loads the dashboard for a workspace via the `get_home_dashboard` RPC.
class GetHomeDashboardUseCase {
  const GetHomeDashboardUseCase(this._repository);

  final HomeRepository _repository;

  Future<Result<HomeDashboardEntity>> call({required String workspaceId}) =>
      _repository.getHomeDashboard(workspaceId: workspaceId);
}
