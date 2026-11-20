import 'package:flutter_test/flutter_test.dart';

import 'package:fitza_mobile_application/features/fitness/data/models/exercise_workout_history_model.dart';

void main() {
  test('parses the get_exercise_workout_history response', () {
    final history = ExerciseWorkoutHistoryModel.fromMap({
      'workspace_id': '91e38620-ae50-4abe-aa28-d5d1a09d814e',
      'timezone': 'Asia/Kolkata',
      'exercise_id': '8f6f925b-e99a-488f-9aa1-a408b0577f1d',
      'exercise_name': 'Incline Dumbbell Bench Press',
      'pagination': {
        'limit': 20,
        'offset': 0,
        'returned': 1,
        'total': 1,
        'has_more': false,
      },
      'history': [
        {
          'session_id': '4dbfd406-5074-4ab2-adf3-603e0024cda1',
          'date': '2026-11-16',
          'started_at': '2026-11-16T01:30:00+00:00',
          'ended_at': '2026-11-16T02:15:00+00:00',
          'workout_title': '[DEMO] Day 1',
          'status': 'completed',
          'completed_sets': 3,
          'total_volume_kg': 300,
          'max_weight_kg': 12.5,
          'max_reps': 8,
          'sets': [
            {
              'set_id': '6a1f6f0e-2f4a-4f45-9d43-6f0e5a1c3b11',
              'set_number': 1,
              'weight_kg': 12.5,
              'reps': 8,
              'duration_seconds': null,
              'rest_seconds': null,
              'rpe': null,
              'is_completed': true,
              'completed_at': '2026-11-16T01:40:00+00:00',
              'notes': null,
            },
          ],
        },
      ],
    }).toEntity();

    expect(history.exerciseName, 'Incline Dumbbell Bench Press');
    expect(history.timezone, 'Asia/Kolkata');
    expect(history.pagination.total, 1);
    expect(history.pagination.hasMore, isFalse);
    expect(history.isEmpty, isFalse);

    final session = history.latest!;
    expect(session.workoutTitle, '[DEMO] Day 1');
    expect(session.isCompleted, isTrue);
    expect(session.completedSets, 3);
    expect(session.totalVolumeKg, 300);
    expect(session.maxWeightKg, 12.5);
    expect(session.maxReps, 8);
    expect(session.startedAt, DateTime.utc(2026, 11, 16, 1, 30));

    final set = session.sets.single;
    expect(set.setNumber, 1);
    expect(set.weightKg, 12.5);
    expect(set.reps, 8);
    expect(set.isCompleted, isTrue);
    expect(set.completedAt, DateTime.utc(2026, 11, 16, 1, 40));
  });

  test('tolerates missing or null fields', () {
    final history = ExerciseWorkoutHistoryModel.fromMap({
      'history': [
        {
          'session_id': 'abc',
          'sets': [
            {'set_id': 'def', 'is_completed': false},
          ],
        },
      ],
    }).toEntity();

    expect(history.pagination.total, 0);
    expect(history.pagination.hasMore, isFalse);
    expect(history.history.single.sets.single.weightKg, isNull);
  });
}
