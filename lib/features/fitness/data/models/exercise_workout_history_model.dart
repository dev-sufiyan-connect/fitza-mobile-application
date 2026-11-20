import 'package:fitza_mobile_application/features/fitness/domain/entities/exercise_workout_history_entity.dart';

/// Parses the `get_exercise_workout_history` RPC payload.
///
/// Every field is treated as optional so a partially populated session still
/// renders instead of failing the whole history section.
class ExerciseWorkoutHistoryModel {
  const ExerciseWorkoutHistoryModel(this._json);

  final Map<String, dynamic> _json;

  factory ExerciseWorkoutHistoryModel.fromMap(Map<String, dynamic> map) =>
      ExerciseWorkoutHistoryModel(map);

  ExerciseWorkoutHistoryEntity toEntity() {
    final pagination = _map(_json['pagination']);

    return ExerciseWorkoutHistoryEntity(
      exerciseId: _string(_json['exercise_id']),
      exerciseName: _string(_json['exercise_name']),
      workspaceId: _string(_json['workspace_id']),
      timezone: _string(_json['timezone']),
      pagination: ExerciseWorkoutHistoryPaginationEntity(
        limit: _int(pagination['limit']),
        offset: _int(pagination['offset']),
        returned: _int(pagination['returned']),
        total: _int(pagination['total']),
        hasMore: _bool(pagination['has_more']),
      ),
      history: [
        for (final raw in _list(_json['history'])) _session(_map(raw)),
      ],
    );
  }

  ExerciseWorkoutHistorySessionEntity _session(Map<String, dynamic> json) {
    return ExerciseWorkoutHistorySessionEntity(
      sessionId: _string(json['session_id']),
      date: _string(json['date']),
      startedAt: _dateTimeOrNull(json['started_at']),
      endedAt: _dateTimeOrNull(json['ended_at']),
      workoutTitle: _string(json['workout_title']),
      status: _string(json['status']),
      completedSets: _int(json['completed_sets']),
      totalVolumeKg: _double(json['total_volume_kg']),
      maxWeightKg: _doubleOrNull(json['max_weight_kg']),
      maxReps: _intOrNull(json['max_reps']),
      sets: [for (final raw in _list(json['sets'])) _set(_map(raw))],
    );
  }

  ExerciseWorkoutHistorySetEntity _set(Map<String, dynamic> json) {
    return ExerciseWorkoutHistorySetEntity(
      setId: _string(json['set_id']),
      setNumber: _intOrNull(json['set_number']),
      weightKg: _doubleOrNull(json['weight_kg']),
      reps: _intOrNull(json['reps']),
      durationSeconds: _intOrNull(json['duration_seconds']),
      restSeconds: _intOrNull(json['rest_seconds']),
      rpe: _doubleOrNull(json['rpe']),
      isCompleted: _bool(json['is_completed']),
      completedAt: _dateTimeOrNull(json['completed_at']),
      notes: _stringOrNull(json['notes']),
    );
  }

  Map<String, dynamic> _map(Object? value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return const {};
  }

  List<dynamic> _list(Object? value) => value is List ? value : const [];

  String _string(Object? value) => value?.toString() ?? '';

  String? _stringOrNull(Object? value) {
    final text = value?.toString();
    return text == null || text.isEmpty ? null : text;
  }

  bool _bool(Object? value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) return value.toLowerCase() == 'true';
    return false;
  }

  int _int(Object? value) {
    if (value is num) return value.toInt();
    return int.tryParse('$value') ?? 0;
  }

  int? _intOrNull(Object? value) {
    if (value is num) return value.toInt();
    return int.tryParse('$value');
  }

  double _double(Object? value) {
    if (value is num) return value.toDouble();
    return double.tryParse('$value') ?? 0;
  }

  double? _doubleOrNull(Object? value) {
    if (value is num) return value.toDouble();
    return double.tryParse('$value');
  }

  DateTime? _dateTimeOrNull(Object? value) {
    if (value is DateTime) return value;
    final text = value?.toString();
    return text == null ? null : DateTime.tryParse(text);
  }
}
