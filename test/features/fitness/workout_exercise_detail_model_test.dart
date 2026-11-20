import 'package:flutter_test/flutter_test.dart';

import 'package:fitza_mobile_application/features/fitness/data/models/workout_exercise_detail_model.dart';

void main() {
  test('parses the exercise, instructions and prescribed sets', () {
    final entity = WorkoutExerciseDetailModel.fromMap({
      'selected_date': '2026-11-20',
      'workout_day_number': 1,
      'workout_title': 'Day 1',
      'exercise_position': 1,
      'total_exercises': 7,
      'exercise': {
        'plan_exercise_id': '8283e0a0-b910-44a2-9a45-91ac561d3c49',
        'exercise_id': '8f6f925b-e99a-488f-9aa1-a408b0577f1d',
        'name': 'Incline Dumbbell Bench Press',
        'description': 'Incline dumbbell press targeting the upper chest.',
        'instructions': [
          'Set bench to a low incline',
          'Start dumbbells above upper chest',
        ],
        'plan_instructions': null,
        'difficulty': 'intermediate',
        'is_compound': true,
        'is_unilateral': false,
        'category': {'id': 'category-id', 'name': 'Strength'},
        'thumbnail_path': null,
        'video_path': 'https://www.youtube.com/watch?v=DPXG3BJvl8A',
        'muscle_groups': <dynamic>[],
        'equipment': [
          {'id': 'equipment-id', 'name': 'Dumbbell'},
        ],
      },
      'sets': [
        {
          'set_number': 1,
          'target_reps_min': 8,
          'target_reps_max': 10,
          'target_weight_kg': null,
          'target_duration_seconds': null,
          'rest_seconds': null,
          'target_rpe': null,
          'actual_weight_kg': null,
          'actual_reps': null,
          'actual_duration_seconds': null,
          'actual_rpe': null,
          'is_completed': false,
        },
        {
          'set_number': 2,
          'target_reps_min': 8,
          'target_reps_max': 10,
          'target_weight_kg': 22.5,
          'target_duration_seconds': null,
          'rest_seconds': 90,
          'target_rpe': 8,
          'actual_weight_kg': 22.5,
          'actual_reps': 9,
          'actual_duration_seconds': null,
          'actual_rpe': 8,
          'is_completed': true,
        },
      ],
    }).toEntity();

    expect(entity.selectedDate, '2026-11-20');
    expect(entity.workoutDayNumber, 1);
    expect(entity.workoutTitle, 'Day 1');
    expect(entity.exercisePosition, 1);
    expect(entity.totalExercises, 7);
    expect(
      entity.exercise.planExerciseId,
      '8283e0a0-b910-44a2-9a45-91ac561d3c49',
    );
    expect(entity.exercise.name, 'Incline Dumbbell Bench Press');
    expect(entity.exercise.categoryName, 'Strength');
    expect(entity.exercise.difficulty, 'intermediate');
    expect(entity.exercise.isCompound, isTrue);
    expect(entity.exercise.isUnilateral, isFalse);
    expect(entity.exercise.instructions, hasLength(2));
    expect(entity.exercise.planInstructions, isNull);
    expect(entity.exercise.thumbnailPath, isEmpty);
    expect(entity.exercise.videoPath, contains('youtube.com'));
    expect(entity.exercise.equipment, ['Dumbbell']);
    expect(entity.sets, hasLength(2));
    expect(entity.sets.first.targetRepsMin, 8);
    expect(entity.sets.first.targetRepsMax, 10);
    expect(entity.sets.first.targetWeightKg, isNull);
    expect(entity.sets.first.isCompleted, isFalse);
    expect(entity.sets.last.targetWeightKg, 22.5);
    expect(entity.sets.last.actualReps, 9);
    expect(entity.sets.last.restSeconds, 90);
    expect(entity.sets.last.isCompleted, isTrue);
  });

  test('handles missing nested exercise and set data', () {
    final entity = WorkoutExerciseDetailModel.fromMap({
      'selected_date': '2026-11-20',
    }).toEntity();

    expect(entity.workoutDayNumber, 0);
    expect(entity.totalExercises, 0);
    expect(entity.exercise.name, isEmpty);
    expect(entity.exercise.instructions, isEmpty);
    expect(entity.sets, isEmpty);
  });
}
