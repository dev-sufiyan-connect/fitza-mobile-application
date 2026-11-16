import 'package:fitza_mobile_application/core/utils/result.dart';
import 'package:fitza_mobile_application/features/auth/domain/entities/user_entity.dart';

/// Contract owned by the domain layer, implemented in the data layer.
abstract interface class AuthRepository {
  Future<Result<UserEntity>> signInWithEmail({
    required String email,
    required String password,
  });

  Future<Result<UserEntity>> signUpWithEmail({
    required String email,
    required String password,
  });

  Future<Result<UserEntity>> getCurrentUser();

  Future<Result<void>> signOut();
}
