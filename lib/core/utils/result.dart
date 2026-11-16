import 'package:fitza_mobile_application/core/error/failures.dart';

/// A lightweight, dependency-free `Either`-style result type used by
/// use cases and repositories.
///
/// ```dart
/// Future<Result<UserEntity>> signIn(...) async {
///   try {
///     final user = await _dataSource.signIn(...);
///     return Success(user);
///   } catch (e) {
///     return FailureResult(e.toFailure());
///   }
/// }
/// ```
sealed class Result<S> {
  const Result();

  bool get isSuccess => this is Success<S>;
  bool get isFailure => this is FailureResult<S>;

  /// Returns the success value, or `null` if this is a failure.
  S? get dataOrNull => switch (this) {
        Success<S>(:final data) => data,
        FailureResult<S>() => null,
      };

  /// Pattern-match both branches:
  /// `result.when(onSuccess: (d) {...}, onFailure: (f) {...})`
  T when<T>({
    required T Function(S data) onSuccess,
    required T Function(Failure failure) onFailure,
  }) =>
      switch (this) {
        Success<S>(:final data) => onSuccess(data),
        FailureResult<S>(:final failure) => onFailure(failure),
      };
}

final class Success<S> extends Result<S> {
  const Success(this.data);

  final S data;
}

final class FailureResult<S> extends Result<S> {
  const FailureResult(this.failure);

  final Failure failure;
}
