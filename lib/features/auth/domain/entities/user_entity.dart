/// Pure business object. No JSON, no Supabase types, no Flutter imports.
class UserEntity {
  const UserEntity({
    required this.id,
    required this.email,
    this.fullName,
    this.avatarUrl,
  });

  final String id;
  final String email;
  final String? fullName;
  final String? avatarUrl;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is UserEntity && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
