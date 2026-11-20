import 'package:fitza_mobile_application/features/fitness/domain/entities/weekly_workout_entity.dart';

/// Parses the `get_weekly_workout_status` RPC payload.
class WeeklyWorkoutStatusModel {
  const WeeklyWorkoutStatusModel(this._json);

  final Map<String, dynamic> _json;

  factory WeeklyWorkoutStatusModel.fromMap(Map<String, dynamic> map) =>
      WeeklyWorkoutStatusModel(map);

  WeeklyWorkoutStatusEntity toEntity() {
    final plan = _map(_json['plan']);

    return WeeklyWorkoutStatusEntity(
      selectedDate: _string(_json['selected_date']),
      weekStart: _string(_json['week_start']),
      weekEnd: _string(_json['week_end']),
      timezone: _string(_json['timezone']),
      workspaceId: _string(_json['workspace_id']),
      plan: plan.isEmpty
          ? null
          : WeeklyWorkoutPlanEntity(
              assignmentId: _string(plan['assignment_id']),
              planId: _string(plan['plan_id']),
              name: _string(plan['name']),
              startsOn: _string(plan['starts_on']),
              endsOn: _stringOrNull(plan['ends_on']),
            ),
      weeklyStatus: [
        for (final raw in _list(_json['weekly_status'])) _day(_map(raw)),
      ],
    );
  }

  WeeklyWorkoutDayEntity _day(Map<String, dynamic> json) {
    return WeeklyWorkoutDayEntity(
      date: _string(json['date']),
      dayName: _string(json['day_name']),
      isoWeekday: _int(json['iso_weekday']),
      workoutDayId: _stringOrNull(json['workout_day_id']),
      workoutDayNumber: _intOrNull(json['workout_day_number']),
      workoutTitle: _string(json['workout_title']),
      exerciseCount: _int(json['exercise_count']),
      status: _string(json['status']).toLowerCase(),
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

  int _int(Object? value) {
    if (value is num) return value.toInt();
    return int.tryParse('$value') ?? 0;
  }

  int? _intOrNull(Object? value) {
    if (value is num) return value.toInt();
    return int.tryParse('$value');
  }
}
