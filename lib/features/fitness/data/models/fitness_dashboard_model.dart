import 'package:fitza_mobile_application/features/fitness/domain/entities/fitness_dashboard_entity.dart';

/// Parses the `get_fitness_dashboard` RPC payload.
///
/// Every lookup is defensive: `workout_day_number` and the nested workout
/// objects may be `null` (rest days), and optional fields come back as `null`.
class FitnessDashboardModel {
  const FitnessDashboardModel(this._json);

  final Map<String, dynamic> _json;

  factory FitnessDashboardModel.fromMap(Map<String, dynamic> map) =>
      FitnessDashboardModel(map);

  FitnessDashboardEntity toEntity() {
    final day = _map(_json['selected_day']);
    final exercises = _list(day['exercises']);

    return FitnessDashboardEntity(
      selectedDate: _string(_json['selected_date']),
      day: FitnessDayEntity(
        dayNumber: _intOrNull(day['workout_day_number']),
        title: _string(day['workout_title']),
        status: _status(day['status']),
        exerciseCount: day['exercise_count'] == null
            ? exercises.length
            : _int(day['exercise_count']),
        exercises: [
          for (final raw in exercises) _exercise(_map(raw)),
        ],
      ),
    );
  }

  FitnessExerciseEntity _exercise(Map<String, dynamic> json) {
    return FitnessExerciseEntity(
      planExerciseId: _string(json['plan_exercise_id']),
      exerciseId: _string(json['exercise_id']),
      name: _string(json['name']),
      description: _string(json['description']),
      instructions: _strings(json['instructions']),
      thumbnailPath: _string(json['thumbnail_path']),
      videoPath: _string(json['video_path']),
      sortOrder: _int(json['sort_order']),
      notes: _stringOrNull(json['notes']),
      sets: [
        for (final raw in _list(json['sets'])) _set(_map(raw)),
      ],
    );
  }

  FitnessExerciseSetEntity _set(Map<String, dynamic> json) {
    return FitnessExerciseSetEntity(
      setNumber: _intOrNull(json['set_number']),
      targetRepsMin: _intOrNull(json['target_reps_min']),
      targetRepsMax: _intOrNull(json['target_reps_max']),
      targetWeightKg: _doubleOrNull(json['target_weight_kg']),
      targetDurationSeconds: _intOrNull(json['target_duration_seconds']),
      restSeconds: _intOrNull(json['rest_seconds']),
      targetRpe: _doubleOrNull(json['target_rpe']),
      notes: _stringOrNull(json['notes']),
    );
  }

  Map<String, dynamic> _map(Object? value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return const {};
  }

  List<dynamic> _list(Object? value) => value is List ? value : const [];

  List<String> _strings(Object? value) {
    return [
      for (final item in _list(value))
        if (item != null)
          if (item is Map)
            _string(item['text'] ?? item['instruction'] ?? item['step'])
          else
            '$item',
    ];
  }

  String _status(Object? value) => _string(value).toLowerCase();

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

  double? _doubleOrNull(Object? value) {
    if (value is num) return value.toDouble();
    return double.tryParse('$value');
  }
}
