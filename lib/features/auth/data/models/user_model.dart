import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:fitza_mobile_application/features/auth/domain/entities/user_entity.dart';

/// Data-layer representation of a user. Knows how to (de)serialize.
///
/// Convention: `user_model.dart` mirrors the `profiles` table row plus
/// auth user fields. Keep `toJson`/`fromSupabaseUser` in sync with the DB.
class UserModel {
  const UserModel({
    required this.id,
    required this.email,
    this.fullName,
    this.avatarUrl,
  });

  final String id;
  final String email;
  final String? fullName;
  final String? avatarUrl;

  factory UserModel.fromSupabaseUser(User user) {
    return UserModel(
      id: user.id,
      email: user.email ?? '',
      fullName: user.userMetadata?['full_name'] as String?,
      avatarUrl: user.userMetadata?['avatar_url'] as String?,
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      email: map['email'] as String? ?? '',
      fullName: map['full_name'] as String?,
      avatarUrl: map['avatar_url'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'email': email,
        'full_name': fullName,
        'avatar_url': avatarUrl,
      };

  UserEntity toEntity() => UserEntity(
        id: id,
        email: email,
        fullName: fullName,
        avatarUrl: avatarUrl,
      );
}
