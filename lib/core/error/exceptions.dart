/// Low-level exceptions thrown by data sources.
///
/// Data sources must never leak these to the domain layer — repositories
/// catch them and map them into [Failure] objects.
sealed class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

final class ServerException extends AppException {
  const ServerException([super.message = 'Server error occurred']);
}

final class NetworkException extends AppException {
  const NetworkException([super.message = 'No internet connection']);
}

final class AuthAppException extends AppException {
  const AuthAppException(super.message);
}

final class CacheException extends AppException {
  const CacheException([super.message = 'Local cache error']);
}

final class ValidationException extends AppException {
  const ValidationException(super.message);
}
