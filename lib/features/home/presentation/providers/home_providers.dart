import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitza_mobile_application/core/di/core_providers.dart';
import 'package:fitza_mobile_application/features/home/data/datasources/home_remote_data_source.dart';
import 'package:fitza_mobile_application/features/home/data/repositories/home_repository_impl.dart';
import 'package:fitza_mobile_application/features/home/domain/entities/home_dashboard_entity.dart';
import 'package:fitza_mobile_application/features/home/domain/usecases/get_home_dashboard_usecase.dart';

/// TODO: replace with the signed-in user's workspace once workspace
/// selection exists.
const String _defaultWorkspaceId = '91e38620-ae50-4abe-aa28-d5d1a09d814e';

final homeRemoteDataSourceProvider = Provider<HomeRemoteDataSource>(
  (ref) => HomeRemoteDataSource(ref.watch(supabaseClientProvider)),
);

final homeRepositoryProvider = Provider<HomeRepositoryImpl>(
  (ref) => HomeRepositoryImpl(ref.watch(homeRemoteDataSourceProvider)),
);

final getHomeDashboardUseCaseProvider = Provider<GetHomeDashboardUseCase>(
  (ref) => GetHomeDashboardUseCase(ref.watch(homeRepositoryProvider)),
);

final homeDashboardProvider = FutureProvider<HomeDashboardEntity>((ref) async {
  final result = await ref.watch(getHomeDashboardUseCaseProvider)(
    workspaceId: _defaultWorkspaceId,
  );

  return result.when(
    onSuccess: (dashboard) => dashboard,
    onFailure: (failure) => throw failure,
  );
});
