import 'package:fitza_mobile_application/features/fitness/domain/entities/mark_workout_exercise_complete_entity.dart';

/// Parses the `mark_workout_exercise_complete` RPC payload.
///
/// Every field is read defensively so a partially populated response still
/// yields a usable result instead of failing the completion flow.
class MarkWorkoutExerciseCompleteModel {
  const MarkWorkoutExerciseCompleteModel(this._json);

  final Map<String, dynamic> _json;

  factory MarkWorkoutExerciseCompleteModel.fromMap(Map<String, dynamic> map) =>
      MarkWorkoutExerciseCompleteModel(map);

  MarkWorkoutExerciseCompleteEntity toEntity() {
    return MarkWorkoutExerciseCompleteEntity(
      success: _bool(_json['success']),
      sessionId: _string(_json['session_id']),
      sessionExerciseId: _string(_json['session_exercise_id']),
      planExerciseId: _string(_json['plan_exercise_id']),
      exerciseCompleted: _bool(_json['exercise_completed']),
      completedExercises: _int(_json['completed_exercises']),
      totalExercises: _int(_json['total_exercises']),
      sessionCompleted: _bool(_json['session_completed']),
      savedSets: _int(_json['saved_sets']),
      message: _string(_json['message']),
    );
  }

  String _string(Object? value) => value?.toString() ?? '';

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
}
