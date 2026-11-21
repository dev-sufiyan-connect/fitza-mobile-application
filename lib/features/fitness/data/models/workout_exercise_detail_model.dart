import 'package:fitza_mobile_application/features/fitness/domain/entities/workout_exercise_detail_entity.dart';

/// Parses the `get_workout_exercise_detail` RPC payload.
///
/// Nested objects and numeric fields are treated as optional so a partially
/// populated exercise still renders instead of failing the whole screen.
class WorkoutExerciseDetailModel {
  const WorkoutExerciseDetailModel(this._json);

  final Map<String, dynamic> _json;

  factory WorkoutExerciseDetailModel.fromMap(Map<String, dynamic> map) =>
      WorkoutExerciseDetailModel(map);

  WorkoutExerciseDetailEntity toEntity() {
    final exercise = _map(_json['exercise']);
    final category = _map(exercise['category']);
    final session = _map(_json['session']);

    return WorkoutExerciseDetailEntity(
      sessionId: _sessionId(session),
      selectedDate: _string(_json['selected_date']),
      workoutDayNumber: _int(_json['workout_day_number']),
      workoutTitle: _string(_json['workout_title']),
      exercisePosition: _int(_json['exercise_position']),
      totalExercises: _int(_json['total_exercises']),
      exercise: WorkoutExerciseInfoEntity(
        planExerciseId: _string(exercise['plan_exercise_id']),
        exerciseId: _string(exercise['exercise_id']),
        name: _string(exercise['name']),
        description: _string(exercise['description']),
        instructions: _strings(exercise['instructions']),
        planInstructions: _stringOrNull(exercise['plan_instructions']),
        difficulty: _string(exercise['difficulty']),
        isCompound: _bool(exercise['is_compound']),
        isUnilateral: _bool(exercise['is_unilateral']),
        categoryName: _string(category['name']),
        thumbnailPath: _string(exercise['thumbnail_path']),
        videoPath: _string(exercise['video_path']),
        muscleGroups: _names(exercise['muscle_groups']),
        equipment: _names(exercise['equipment']),
      ),
      sets: [for (final raw in _list(_json['sets'])) _set(_map(raw))],
    );
  }

  WorkoutExerciseSetEntity _set(Map<String, dynamic> json) {
    return WorkoutExerciseSetEntity(
      setNumber: _intOrNull(json['set_number']),
      targetRepsMin: _intOrNull(json['target_reps_min']),
      targetRepsMax: _intOrNull(json['target_reps_max']),
      targetWeightKg: _doubleOrNull(json['target_weight_kg']),
      targetDurationSeconds: _intOrNull(json['target_duration_seconds']),
      restSeconds: _intOrNull(json['rest_seconds']),
      targetRpe: _doubleOrNull(json['target_rpe']),
      actualWeightKg: _doubleOrNull(json['actual_weight_kg']),
      actualReps: _intOrNull(json['actual_reps']),
      actualDurationSeconds: _intOrNull(json['actual_duration_seconds']),
      actualRpe: _doubleOrNull(json['actual_rpe']),
      isCompleted: _bool(json['is_completed']),
    );
  }

  /// Accepts every shape the RPC may use for the active session id.
  String _sessionId(Map<String, dynamic> session) {
    for (final candidate in [
      _json['session_id'],
      _json['active_session_id'],
      session['session_id'],
      session['id'],
    ]) {
      final value = _string(candidate);
      if (value.isNotEmpty) return value;
    }
    return '';
  }

  Map<String, dynamic> _map(Object? value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return const {};
  }

  List<dynamic> _list(Object? value) => value is List ? value : const [];

  List<String> _strings(Object? value) {
    return [
      for (final item in _list(value))
        if (item != null)
          if (item is Map)
            _string(item['text'] ?? item['instruction'] ?? item['step'])
          else
            '$item',
    ];
  }

  List<String> _names(Object? value) {
    final names = <String>[];
    for (final item in _list(value)) {
      if (item is Map) {
        final name = _string(item['name']);
        if (name.isNotEmpty) names.add(name);
      } else if (item != null) {
        names.add('$item');
      }
    }
    return names;
  }

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

  double? _doubleOrNull(Object? value) {
    if (value is num) return value.toDouble();
    return double.tryParse('$value');
  }
}
