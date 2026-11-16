import 'exceptions.dart';

/// High-level, presentation-friendly errors.
///
/// The domain and presentation layers only ever see [Failure]s —
/// never raw [AppException]s or third-party types.
sealed class Failure {
  const Failure(this.message);

  final String message;

  @override
  String toString() => '$runtimeType($message)';
}

final class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Something went wrong. Please try again.']);
}

final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'You appear to be offline.']);
}

final class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed.']);
}

final class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Failed to load saved data.']);
}

final class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// Maps any thrown object into a [Failure], so repositories can stay
/// exception-free with a single `try { ... } catch (e) { return Left(...) }`.
extension FailureX on Object {
  Failure toFailure() {
    return switch (this) {
      final AppException e => switch (e) {
          ServerException() => ServerFailure(e.message),
          NetworkException() => NetworkFailure(e.message),
          AuthAppException() => AuthFailure(e.message),
          CacheException() => CacheFailure(e.message),
          ValidationException() => ValidationFailure(e.message),
        },
      _ => const ServerFailure(),
    };
  }
}
