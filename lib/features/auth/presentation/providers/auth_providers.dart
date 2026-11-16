import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitza_mobile_application/core/di/core_providers.dart';
import 'package:fitza_mobile_application/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:fitza_mobile_application/features/auth/data/models/user_model.dart';
import 'package:fitza_mobile_application/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:fitza_mobile_application/features/auth/domain/entities/user_entity.dart';
import 'package:fitza_mobile_application/features/auth/domain/usecases/sign_in_with_email_usecase.dart';
import 'package:fitza_mobile_application/features/auth/domain/usecases/sign_out_usecase.dart';

// ---------------------------------------------------------------------------
// DI composition
// ---------------------------------------------------------------------------

final authRepositoryProvider = Provider<AuthRepositoryImpl>((ref) {
  return AuthRepositoryImpl(
    AuthRemoteDataSource(ref.watch(supabaseClientProvider)),
  );
});

final signInWithEmailUseCaseProvider = Provider<SignInWithEmailUseCase>((ref) {
  return SignInWithEmailUseCase(ref.watch(authRepositoryProvider));
});

final signOutUseCaseProvider = Provider<SignOutUseCase>((ref) {
  return SignOutUseCase(ref.watch(authRepositoryProvider));
});

// ---------------------------------------------------------------------------
// Session state — drives the router redirect
// ---------------------------------------------------------------------------

/// Emits the signed-in user (or null) whenever the Supabase session changes.
/// This is the single source of truth for "is the user logged in".
final authStateProvider = StreamProvider<UserEntity?>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return client.auth.onAuthStateChange.map((event) {
    final user = event.session?.user;
    return user == null ? null : UserModel.fromSupabaseUser(user).toEntity();
  });
});

// ---------------------------------------------------------------------------
// Controller — drives form actions (sign in / sign out)
// ---------------------------------------------------------------------------

/// Mutable UI state for auth actions.
/// `build()` seeds the state from the current session.
class AuthController extends AsyncNotifier<UserEntity?> {
  @override
  Future<UserEntity?> build() async {
    final result = await ref.watch(authRepositoryProvider).getCurrentUser();
    return result.dataOrNull;
  }

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    final result = await ref
        .read(signInWithEmailUseCaseProvider)
        .call(email: email, password: password);
    return result.when(
      onSuccess: (user) {
        state = AsyncData(user);
        return true;
      },
      onFailure: (failure) {
        state = AsyncError(failure, StackTrace.current);
        return false;
      },
    );
  }

  Future<void> signOut() async {
    await ref.read(signOutUseCaseProvider).call();
    state = const AsyncData(null);
  }
}

final authControllerProvider =
    AsyncNotifierProvider<AuthController, UserEntity?>(AuthController.new);
