import 'package:fitza_mobile_application/features/home/domain/entities/home_dashboard_entity.dart';

/// Parses the `get_home_dashboard` RPC payload into a [HomeDashboardEntity].
///
/// The RPC returns nested maps that may be empty while other features are
/// still being built, so every lookup is defensive and falls back to a
/// neutral value instead of throwing.
class HomeDashboardModel {
  const HomeDashboardModel(this._json);

  final Map<String, dynamic> _json;

  factory HomeDashboardModel.fromMap(Map<String, dynamic> map) =>
      HomeDashboardModel(map);

  HomeDashboardEntity toEntity() {
    final meals = _map(_json['meals']);
    final water = _map(_json['water']);
    final tasks = _map(_json['tasks']);
    final workout = _map(_json['workout']);
    final bodyWeight = _map(_json['body_weight']);
    final sleep = _map(_json['sleep']);

    final mealsCompleted = _int(meals['completed']);
    final mealsTotal = _int(meals['total']);
    final calories = meals['calories_consumed_kcal'] == null
        ? null
        : _int(meals['calories_consumed_kcal']);
    final waterConsumed = _int(water['consumed_ml']);
    final waterTarget = _int(water['target_ml']);
    final tasksCompleted = _int(tasks['completed']);
    final tasksTotal = _int(tasks['total']);

    final workoutComplete = _bool(workout['completed']) ||
        _string(workout['status']).toLowerCase() == 'completed';
    final workoutTitle = _string(
      workout['title'] ?? workout['name'] ?? workout['plan_name'],
    );

    final weightKg = _double(
      bodyWeight['value_kg'] ??
          bodyWeight['current_kg'] ??
          bodyWeight['weight_kg'] ??
          bodyWeight['weight'],
    );
    final sleepDuration = _sleepDuration(sleep);

    final mealsComplete = mealsTotal > 0 && mealsCompleted >= mealsTotal;
    final waterComplete = waterTarget > 0 && waterConsumed >= waterTarget;
    final tasksComplete = tasksTotal > 0 && tasksCompleted >= tasksTotal;

    return HomeDashboardEntity(
      progressPercent: _int(_json['daily_progress_percent']).clamp(0, 100),
      checklist: [
        ChecklistItemEntity(
          label: 'Workout',
          value: workoutComplete ? '' : workoutTitle,
          isComplete: workoutComplete,
        ),
        ChecklistItemEntity(
          label: 'Meals',
          value: '$mealsCompleted / $mealsTotal',
          isComplete: mealsComplete,
        ),
        ChecklistItemEntity(
          label: 'Water',
          value: '${_liters(waterConsumed)} / ${_liters(waterTarget)} L',
          isComplete: waterComplete,
        ),
        ChecklistItemEntity(
          label: 'Tasks',
          value: '$tasksCompleted / $tasksTotal',
          isComplete: tasksComplete,
        ),
      ],
      stats: [
        StatChipEntity(
          title: weightKg == null ? '—' : '${weightKg.toStringAsFixed(1)} kg',
          subtitle: 'Weight',
          icon: 'scale',
        ),
        StatChipEntity(
          title: sleepDuration ?? '—',
          subtitle: 'Sleep',
          icon: 'moon',
        ),
        StatChipEntity(
          title: calories == null ? '—' : '${_thousands(calories)} kcal',
          subtitle: 'Calories',
          icon: 'flame',
        ),
      ],
      plan: [
        PlanItemEntity(
          title: 'Workout',
          subtitle: workoutTitle.isNotEmpty
              ? workoutTitle
              : workoutComplete
                  ? 'Completed for today'
                  : 'No workout scheduled',
          icon: 'dumbbell',
          badge: null,
          isCompleted: workoutComplete,
        ),
        PlanItemEntity(
          title: 'Meals',
          subtitle: calories == null
              ? '$mealsTotal meals'
              : '$mealsTotal meals · ${_thousands(calories)} kcal',
          icon: 'apple',
          badge: '$mealsCompleted / $mealsTotal',
          isCompleted: mealsComplete,
        ),
        PlanItemEntity(
          title: 'Daily Tasks',
          subtitle: '$tasksCompleted of $tasksTotal completed',
          icon: 'check-square',
          badge: '$tasksCompleted / $tasksTotal',
          isCompleted: tasksComplete,
        ),
      ],
    );
  }

  Map<String, dynamic> _map(Object? value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return const {};
  }

  int _int(Object? value) {
    if (value is num) return value.toInt();
    return int.tryParse('$value') ?? 0;
  }

  double? _double(Object? value) {
    if (value is num) return value.toDouble();
    return double.tryParse('$value');
  }

  bool _bool(Object? value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    return false;
  }

  String _string(Object? value) => value?.toString() ?? '';

  String _liters(int milliliters) {
    final liters = milliliters / 1000;
    return liters == liters.roundToDouble()
        ? liters.toInt().toString()
        : liters.toStringAsFixed(1);
  }

  String _thousands(int value) {
    final digits = value.abs().toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
      buffer.write(digits[i]);
    }
    return value < 0 ? '-$buffer' : buffer.toString();
  }

  String? _sleepDuration(Map<String, dynamic> sleep) {
    final minutes = sleep['duration_minutes'] ??
        sleep['total_minutes'] ??
        sleep['minutes'];
    if (minutes != null) {
      final total = _int(minutes);
      if (total <= 0) return null;
      return '${total ~/ 60}h ${total % 60}m';
    }

    final hours = _double(sleep['hours'] ?? sleep['duration_hours']);
    if (hours == null || hours <= 0) return null;
    final total = (hours * 60).round();
    return '${total ~/ 60}h ${total % 60}m';
  }
}
