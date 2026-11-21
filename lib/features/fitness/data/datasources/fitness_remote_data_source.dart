import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:fitza_mobile_application/core/error/exceptions.dart';
import 'package:fitza_mobile_application/features/fitness/data/models/exercise_workout_history_model.dart';
import 'package:fitza_mobile_application/features/fitness/data/models/fitness_dashboard_model.dart';
import 'package:fitza_mobile_application/features/fitness/data/models/mark_workout_exercise_complete_model.dart';
import 'package:fitza_mobile_application/features/fitness/data/models/weekly_workout_model.dart';
import 'package:fitza_mobile_application/features/fitness/data/models/workout_exercise_detail_model.dart';
import 'package:fitza_mobile_application/features/fitness/domain/entities/mark_workout_exercise_complete_entity.dart';

/// Calls the fitness RPCs. Throws [AppException]s only.
class FitnessRemoteDataSource {
  FitnessRemoteDataSource(this._client);

  final SupabaseClient _client;

  Future<FitnessDashboardModel> getFitnessDashboard({
    required String selectedDate,
  }) async {
    try {
      final response = await _client.rpc(
        'get_fitness_dashboard',
        params: {'p_selected_date': selectedDate},
      );

      return switch (response) {
        final Map<String, dynamic> value => FitnessDashboardModel.fromMap(
          value,
        ),
        final Map value => FitnessDashboardModel.fromMap(
          Map<String, dynamic>.from(value),
        ),
        _ => throw const ServerException(
          'Unexpected fitness dashboard response.',
        ),
      };
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    }
  }

  Future<WeeklyWorkoutStatusModel> getWeeklyWorkoutStatus({
    required String selectedDate,
  }) async {
    try {
      final response = await _client.rpc(
        'get_weekly_workout_status',
        params: {'p_selected_date': selectedDate},
      );

      return switch (response) {
        final Map<String, dynamic> value => WeeklyWorkoutStatusModel.fromMap(
          value,
        ),
        final Map value => WeeklyWorkoutStatusModel.fromMap(
          Map<String, dynamic>.from(value),
        ),
        _ => throw const ServerException('Unexpected weekly workout response.'),
      };
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    }
  }

  Future<WorkoutExerciseDetailModel> getWorkoutExerciseDetail({
    required String selectedDate,
    required String planExerciseId,
  }) async {
    try {
      final response = await _client.rpc(
        'get_workout_exercise_detail',
        params: {
          'p_selected_date': selectedDate,
          'p_plan_exercise_id': planExerciseId,
        },
      );

      return switch (response) {
        final Map<String, dynamic> value => WorkoutExerciseDetailModel.fromMap(
          value,
        ),
        final Map value => WorkoutExerciseDetailModel.fromMap(
          Map<String, dynamic>.from(value),
        ),
        _ => throw const ServerException(
          'Unexpected workout exercise detail response.',
        ),
      };
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    }
  }

  Future<MarkWorkoutExerciseCompleteModel> markWorkoutExerciseComplete({
    required String sessionId,
    required String planExerciseId,
    required List<WorkoutSetLogEntity> sets,
    String? exerciseNotes,
    String? sessionNote,
  }) async {
    try {
      final response = await _client.rpc(
        'mark_workout_exercise_complete',
        params: {
          'p_session_id': sessionId,
          'p_plan_exercise_id': planExerciseId,
          'p_exercise_notes': exerciseNotes,
          'p_session_note': sessionNote,
          'p_sets': [
            for (final set in sets)
              {
                'set_number': set.setNumber,
                'actual_weight_kg': set.actualWeightKg,
                'actual_reps': set.actualReps,
                'is_completed': set.isCompleted,
                'notes': set.notes,
              },
          ],
        },
      );

      return switch (response) {
        final Map<String, dynamic> value =>
          MarkWorkoutExerciseCompleteModel.fromMap(value),
        final Map value => MarkWorkoutExerciseCompleteModel.fromMap(
          Map<String, dynamic>.from(value),
        ),
        _ => throw const ServerException(
          'Unexpected workout exercise completion response.',
        ),
      };
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    }
  }

  Future<ExerciseWorkoutHistoryModel> getExerciseWorkoutHistory({
    required String exerciseId,
    required int limit,
    required int offset,
  }) async {
    try {
      final response = await _client.rpc(
        'get_exercise_workout_history',
        params: {
          'p_exercise_id': exerciseId,
          'p_limit': limit,
          'p_offset': offset,
        },
      );

      return switch (response) {
        final Map<String, dynamic> value =>
          ExerciseWorkoutHistoryModel.fromMap(value),
        final Map value => ExerciseWorkoutHistoryModel.fromMap(
          Map<String, dynamic>.from(value),
        ),
        _ => throw const ServerException(
          'Unexpected exercise workout history response.',
        ),
      };
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    }
  }
}
