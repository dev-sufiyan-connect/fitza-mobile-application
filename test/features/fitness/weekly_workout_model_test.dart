import 'package:flutter_test/flutter_test.dart';

import 'package:fitza_mobile_application/features/fitness/data/models/weekly_workout_model.dart';

void main() {
  test('parses plan info and weekly status', () {
    final entity = WeeklyWorkoutStatusModel.fromMap({
      'selected_date': '2026-11-20',
      'week_start': '2026-11-16',
      'week_end': '2026-11-22',
      'timezone': 'Asia/Kolkata',
      'workspace_id': '91e38620-ae50-4abe-aa28-d5d1a09d814e',
      'plan': {
        'assignment_id': 'c1bbf17d-da9b-4d47-a163-6277a5e7f428',
        'plan_id': 'fe488e0c-57b7-49c9-a40e-62d152de9850',
        'name': '[DEMO] Trainer PDF - 5 Day Workout Plan',
        'starts_on': '2026-11-20',
        'ends_on': null,
      },
      'weekly_status': [
        {
          'date': '2026-11-16',
          'day_name': 'Monday',
          'iso_weekday': 1,
          'workout_day_id': '8dd4f4a0-384c-49b4-9487-8ba99f938482',
          'workout_day_number': 1,
          'workout_title': 'Day 1',
          'exercise_count': 7,
          'status': 'pending',
        },
        {
          'date': '2026-11-17',
          'day_name': 'Tuesday',
          'iso_weekday': 2,
          'workout_day_id': '8dd4f4a0-384c-49b4-9487-8ba99f938482',
          'workout_day_number': 2,
          'workout_title': 'Day 2',
          'exercise_count': 6,
          'status': 'completed',
        },
        {
          'date': '2026-11-20',
          'day_name': 'Friday',
          'iso_weekday': 5,
          'workout_day_id': null,
          'workout_day_number': null,
          'workout_title': 'Rest',
          'exercise_count': 0,
          'status': 'rest',
        },
        {
          'date': '2026-11-21',
          'day_name': 'Saturday',
          'iso_weekday': 6,
          'workout_day_id': '8dd4f4a0-384c-49b4-9487-8ba99f938482',
          'workout_day_number': 4,
          'workout_title': 'Day 4',
          'exercise_count': 8,
          'status': 'upcoming',
        },
      ],
    }).toEntity();

    expect(entity.selectedDate, '2026-11-20');
    expect(entity.weekStart, '2026-11-16');
    expect(entity.weekEnd, '2026-11-22');
    expect(entity.plan, isNotNull);
    expect(entity.plan!.name, '[DEMO] Trainer PDF - 5 Day Workout Plan');
    expect(entity.plan!.isNamed, isTrue);

    expect(entity.weeklyStatus, hasLength(4));
    expect(entity.weeklyStatus.first.dayName, 'Monday');
    expect(entity.weeklyStatus.first.isoWeekday, 1);
    expect(entity.weeklyStatus[1].isCompleted, isTrue);
    expect(entity.weeklyStatus[2].isRest, isTrue);
    expect(entity.weeklyStatus[2].workoutDayNumber, isNull);
    expect(entity.weeklyStatus.last.workoutTitle, 'Day 4');
  });

  test('handles a missing plan and empty weekly status', () {
    final entity = WeeklyWorkoutStatusModel.fromMap({
      'selected_date': '2026-11-20',
      'plan': <String, dynamic>{},
      'weekly_status': <dynamic>[],
    }).toEntity();

    expect(entity.plan, isNull);
    expect(entity.weeklyStatus, isEmpty);
    expect(entity.workspaceId, '');
  });
}
