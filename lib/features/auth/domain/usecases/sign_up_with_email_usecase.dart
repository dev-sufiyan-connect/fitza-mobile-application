import 'package:fitza_mobile_application/core/utils/result.dart';
import 'package:fitza_mobile_application/features/auth/domain/entities/user_entity.dart';
import 'package:fitza_mobile_application/features/auth/domain/repositories/auth_repository.dart';

/// Single-responsibility use case. UI/providers call use cases —
/// never repositories or data sources directly.
class SignUpWithEmailUseCase {
  const SignUpWithEmailUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<UserEntity>> call({
    required String email,
    required String password,
    String? fullName,
  }) {
    return _repository.signUpWithEmail(
      email: email,
      password: password,
      fullName: fullName,
    );
  }
}
