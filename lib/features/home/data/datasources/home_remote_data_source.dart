import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:fitza_mobile_application/core/error/exceptions.dart';
import 'package:fitza_mobile_application/features/home/data/models/home_dashboard_model.dart';

/// Calls the `get_home_dashboard` RPC. Throws [AppException]s only.
class HomeRemoteDataSource {
  HomeRemoteDataSource(this._client);

  final SupabaseClient _client;

  Future<HomeDashboardModel> getHomeDashboard({
    required String workspaceId,
  }) async {
    try {
      final response = await _client.rpc(
        'get_home_dashboard',
        params: {'p_workspace_id': workspaceId},
      );

      return switch (response) {
        final Map<String, dynamic> value => HomeDashboardModel.fromMap(value),
        final Map value => HomeDashboardModel.fromMap(
            Map<String, dynamic>.from(value),
          ),
        _ => throw const ServerException('Unexpected dashboard response.'),
      };
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    }
  }
}
