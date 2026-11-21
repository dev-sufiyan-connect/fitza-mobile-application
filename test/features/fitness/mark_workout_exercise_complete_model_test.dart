import 'package:flutter_test/flutter_test.dart';

import 'package:fitza_mobile_application/features/fitness/data/models/mark_workout_exercise_complete_model.dart';
import 'package:fitza_mobile_application/features/fitness/data/models/workout_exercise_detail_model.dart';

void main() {
  test('parses the mark_workout_exercise_complete response', () {
    final result = MarkWorkoutExerciseCompleteModel.fromMap({
      'success': true,
      'session_id': '25b7e1a9-596c-4a70-8555-7548d0d38011',
      'session_exercise_id': '52f7cbab-9411-4e3c-810c-325a38f64407',
      'plan_exercise_id': '8283e0a0-b910-44a2-9a45-91ac561d3c49',
      'exercise_completed': true,
      'completed_exercises': 1,
      'total_exercises': 7,
      'session_completed': false,
      'saved_sets': 3,
      'message': 'Exercise saved successfully',
    }).toEntity();

    expect(result.success, isTrue);
    expect(result.sessionId, '25b7e1a9-596c-4a70-8555-7548d0d38011');
    expect(result.sessionExerciseId, '52f7cbab-9411-4e3c-810c-325a38f64407');
    expect(result.exerciseCompleted, isTrue);
    expect(result.completedExercises, 1);
    expect(result.totalExercises, 7);
    expect(result.isWorkoutFinished, isFalse);
    expect(result.savedSets, 3);
  });

  test('tolerates a missing payload', () {
    final result = MarkWorkoutExerciseCompleteModel.fromMap(
      const {},
    ).toEntity();

    expect(result.success, isFalse);
    expect(result.sessionId, isEmpty);
    expect(result.savedSets, 0);
  });

  test('reads the session id from the exercise detail payload', () {
    final detail = WorkoutExerciseDetailModel.fromMap({
      'session_id': '25b7e1a9-596c-4a70-8555-7548d0d38011',
      'exercise': {'plan_exercise_id': 'abc', 'name': 'Bench'},
    }).toEntity();

    expect(detail.sessionId, '25b7e1a9-596c-4a70-8555-7548d0d38011');
  });

  test('falls back to a nested session object for the session id', () {
    final detail = WorkoutExerciseDetailModel.fromMap({
      'session': {'id': 'nested-session'},
      'exercise': {'plan_exercise_id': 'abc', 'name': 'Bench'},
    }).toEntity();

    expect(detail.sessionId, 'nested-session');
  });
}
