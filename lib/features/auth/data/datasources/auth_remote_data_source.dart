import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:fitza_mobile_application/core/error/exceptions.dart';
import 'package:fitza_mobile_application/features/auth/data/models/user_model.dart';

/// Talks to Supabase Auth. Throws [AppException]s only — no [Failure]s,
/// no [Result]s (those belong to the repository).
class AuthRemoteDataSource {
  AuthRemoteDataSource(this._client);

  final SupabaseClient _client;

  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth
          .signInWithPassword(email: email, password: password);
      final user = response.user;
      if (user == null) {
        throw const AuthAppException('No user returned after sign in.');
      }
      return UserModel.fromSupabaseUser(user);
    } on AuthApiException catch (e) {
      throw AuthAppException(e.message);
    }
  }

  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
    String? fullName,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: fullName == null ? null : {'full_name': fullName},
      );
      final user = response.user;
      if (user == null) {
        throw const AuthAppException('No user returned after sign up.');
      }
      return UserModel.fromSupabaseUser(user);
    } on AuthApiException catch (e) {
      throw AuthAppException(e.message);
    }
  }

  Future<UserModel> getCurrentUser() async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw const AuthAppException('No active session.');
    }
    return UserModel.fromSupabaseUser(user);
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}
