import 'package:fitza_mobile_application/core/utils/result.dart';
import 'package:fitza_mobile_application/features/home/domain/entities/home_dashboard_entity.dart';

/// Contract for the dashboard data shown on the Today tab.
abstract interface class HomeRepository {
  Future<Result<HomeDashboardEntity>> getHomeDashboard({
    required String workspaceId,
  });
}
