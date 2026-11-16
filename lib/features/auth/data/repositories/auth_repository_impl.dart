import 'package:fitza_mobile_application/core/error/failures.dart';
import 'package:fitza_mobile_application/core/utils/result.dart';
import 'package:fitza_mobile_application/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:fitza_mobile_application/features/auth/domain/entities/user_entity.dart';
import 'package:fitza_mobile_application/features/auth/domain/repositories/auth_repository.dart';

/// Production implementation of [AuthRepository].
///
/// Responsibility: translate data-source exceptions into [Result]s.
/// No UI logic, no Supabase types past this boundary.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<Result<UserEntity>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final model = await _remoteDataSource.signInWithEmail(
        email: email,
        password: password,
      );
      return Success(model.toEntity());
    } catch (e) {
      return FailureResult(e.toFailure());
    }
  }

  @override
  Future<Result<UserEntity>> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final model = await _remoteDataSource.signUpWithEmail(
        email: email,
        password: password,
      );
      return Success(model.toEntity());
    } catch (e) {
      return FailureResult(e.toFailure());
    }
  }

  @override
  Future<Result<UserEntity>> getCurrentUser() async {
    try {
      final model = await _remoteDataSource.getCurrentUser();
      return Success(model.toEntity());
    } catch (e) {
      return FailureResult(e.toFailure());
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      return const Success(null);
    } catch (e) {
      return FailureResult(e.toFailure());
    }
  }
}
