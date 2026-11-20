/// Data returned by the `get_weekly_workout_status` RPC.
/// Pure business objects — no Flutter imports.
class WeeklyWorkoutStatusEntity {
  const WeeklyWorkoutStatusEntity({
    required this.selectedDate,
    required this.weekStart,
    required this.weekEnd,
    required this.timezone,
    required this.workspaceId,
    required this.plan,
    required this.weeklyStatus,
  });

  final String selectedDate;
  final String weekStart;
  final String weekEnd;
  final String timezone;
  final String workspaceId;
  final WeeklyWorkoutPlanEntity? plan;
  final List<WeeklyWorkoutDayEntity> weeklyStatus;
}

class WeeklyWorkoutPlanEntity {
  const WeeklyWorkoutPlanEntity({
    required this.assignmentId,
    required this.planId,
    required this.name,
    required this.startsOn,
    required this.endsOn,
  });

  final String assignmentId;
  final String planId;
  final String name;
  final String startsOn;
  final String? endsOn;

  bool get isNamed => name.isNotEmpty;
}

class WeeklyWorkoutDayEntity {
  const WeeklyWorkoutDayEntity({
    required this.date,
    required this.dayName,
    required this.isoWeekday,
    required this.workoutDayId,
    required this.workoutDayNumber,
    required this.workoutTitle,
    required this.exerciseCount,
    required this.status,
  });

  /// ISO date (`yyyy-MM-dd`) used as the RPC's `p_selected_date`.
  final String date;
  final String dayName;

  /// ISO weekday, Monday = 1 … Sunday = 7.
  final int isoWeekday;
  final String? workoutDayId;
  final int? workoutDayNumber;
  final String workoutTitle;
  final int exerciseCount;

  /// `pending`, `completed`, `rest` or `upcoming`.
  final String status;

  bool get isCompleted => status == 'completed';
  bool get isRest => status == 'rest';
}
