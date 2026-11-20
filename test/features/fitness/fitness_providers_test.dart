import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show SupabaseClient;

import 'package:fitza_mobile_application/features/fitness/data/datasources/fitness_remote_data_source.dart';
import 'package:fitza_mobile_application/features/fitness/data/models/fitness_dashboard_model.dart';
import 'package:fitza_mobile_application/features/fitness/data/models/weekly_workout_model.dart';
import 'package:fitza_mobile_application/features/fitness/presentation/providers/fitness_providers.dart';

class _FakeFitnessRemoteDataSource extends FitnessRemoteDataSource {
  _FakeFitnessRemoteDataSource()
      : super(SupabaseClient('https://example.supabase.co', 'test-key'));

  int dashboardCalls = 0;
  int weeklyCalls = 0;

  @override
  Future<FitnessDashboardModel> getFitnessDashboard({
    required String selectedDate,
  }) async {
    dashboardCalls++;
    return FitnessDashboardModel.fromMap({
      'selected_date': selectedDate,
      'selected_day': {
        'workout_day_number': 1,
        'workout_title': 'Day 1',
        'status': 'pending',
        'exercise_count': 7,
        'exercises': <dynamic>[],
      },
    });
  }

  @override
  Future<WeeklyWorkoutStatusModel> getWeeklyWorkoutStatus({
    required String selectedDate,
  }) async {
    weeklyCalls++;
    return WeeklyWorkoutStatusModel.fromMap({
      'selected_date': selectedDate,
      'week_start': '2026-11-16',
      'week_end': '2026-11-22',
      'plan': <String, dynamic>{},
      'weekly_status': [
        {
          'date': '2026-11-18',
          'day_name': 'Wednesday',
          'iso_weekday': 3,
          'workout_day_number': 1,
          'workout_title': 'Day 1',
          'exercise_count': 7,
          'status': 'pending',
        },
      ],
    });
  }
}

void main() {
  test('weekly status loads once and never refetches on date selection',
      () async {
    final fake = _FakeFitnessRemoteDataSource();
    final container = ProviderContainer(
      overrides: [
        fitnessRemoteDataSourceProvider.overrideWithValue(fake),
      ],
    );
    addTearDown(container.dispose);

    await container.read(weeklyWorkoutStatusProvider.future);
    await container.read(fitnessDashboardProvider.future);
    expect(fake.weeklyCalls, 1);
    expect(fake.dashboardCalls, 1);

    container
        .read(selectedFitnessDateProvider.notifier)
        .select(DateTime(2026, 11, 18));
    await container.read(fitnessDashboardProvider.future);

    expect(fake.dashboardCalls, 2);
    expect(fake.weeklyCalls, 1);
  });
}
