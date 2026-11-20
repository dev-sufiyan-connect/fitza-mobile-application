import 'package:fitza_mobile_application/core/error/failures.dart';
import 'package:fitza_mobile_application/core/utils/result.dart';
import 'package:fitza_mobile_application/features/home/data/datasources/home_remote_data_source.dart';
import 'package:fitza_mobile_application/features/home/domain/entities/home_dashboard_entity.dart';
import 'package:fitza_mobile_application/features/home/domain/repositories/home_repository.dart';

/// Production implementation of [HomeRepository].
///
/// Translates data-source exceptions into [Result]s.
class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl(this._remoteDataSource);

  final HomeRemoteDataSource _remoteDataSource;

  @override
  Future<Result<HomeDashboardEntity>> getHomeDashboard({
    required String workspaceId,
  }) async {
    try {
      final model = await _remoteDataSource.getHomeDashboard(
        workspaceId: workspaceId,
      );
      return Success(model.toEntity());
    } catch (e) {
      return FailureResult(e.toFailure());
    }
  }
}
