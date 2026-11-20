import 'package:flutter_test/flutter_test.dart';

import 'package:fitza_mobile_application/features/fitness/data/models/fitness_dashboard_model.dart';

void main() {
  test('parses the selected day', () {
    final entity = FitnessDashboardModel.fromMap({
      'selected_date': '2026-11-18',
      'selected_day': {
        'workout_day_number': 1,
        'workout_title': 'Day 1',
        'status': 'pending',
        'exercise_count': 7,
        'exercises': <dynamic>[],
      },
    }).toEntity();

    expect(entity.selectedDate, '2026-11-18');
    expect(entity.day.dayNumber, 1);
    expect(entity.day.title, 'Day 1');
    expect(entity.day.status, 'pending');
    expect(entity.day.exerciseCount, 7);
    expect(entity.day.exercises, isEmpty);
  });

  test('parses a rest day with null day number', () {
    final entity = FitnessDashboardModel.fromMap({
      'selected_date': '2026-11-20',
      'selected_day': {
        'workout_day_number': null,
        'workout_title': 'Rest',
        'status': 'rest',
        'exercise_count': 0,
        'exercises': <dynamic>[],
      },
      'weekly_status': <dynamic>[],
    }).toEntity();

    expect(entity.day.dayNumber, isNull);
    expect(entity.day.isRest, isTrue);
    expect(entity.day.exerciseCount, 0);
  });

  test('parses exercises and their sets', () {
    final entity = FitnessDashboardModel.fromMap({
      'selected_date': '2026-11-20',
      'selected_day': {
        'workout_day_number': 1,
        'workout_title': 'Day 1',
        'status': 'pending',
        'exercise_count': 1,
        'exercises': [
          {
            'plan_exercise_id': 'plan-uuid',
            'exercise_id': 'exercise-uuid',
            'name': 'Incline DB Bench Press',
            'description': 'Upper chest focus',
            'instructions': ['Set the bench to 30°', 'Press up'],
            'thumbnail_path': 'image-path',
            'video_path': 'video-url',
            'sort_order': 1,
            'notes': null,
            'sets': [
              {
                'set_number': 1,
                'target_reps_min': 10,
                'target_reps_max': 12,
                'target_weight_kg': 20,
                'target_duration_seconds': null,
                'rest_seconds': 60,
                'target_rpe': 8,
                'notes': null,
              },
            ],
          },
        ],
      },
      'weekly_status': <dynamic>[],
    }).toEntity();

    final exercise = entity.day.exercises.single;
    expect(exercise.name, 'Incline DB Bench Press');
    expect(exercise.instructions, hasLength(2));
    expect(exercise.sets, hasLength(1));
    expect(exercise.sets.single.targetRepsMin, 10);
    expect(exercise.sets.single.targetRepsMax, 12);
    expect(exercise.sets.single.restSeconds, 60);
  });
}
