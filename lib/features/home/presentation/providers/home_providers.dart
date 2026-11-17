import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitza_mobile_application/features/home/domain/entities/home_dashboard_entity.dart';

/// TODO: replace with use case + repository once the workout/nutrition
/// features have real data layers. Kept as a provider so the UI contract
/// (`AsyncValue` of `HomeDashboardEntity`) stays stable.
final homeDashboardProvider = FutureProvider<HomeDashboardEntity>((ref) async {
  await Future<void>.delayed(const Duration(milliseconds: 400));

  return const HomeDashboardEntity(
    progressPercent: 72,
    checklist: [
      ChecklistItemEntity(label: 'Workout', value: '', isComplete: true),
      ChecklistItemEntity(label: 'Meals', value: '2 / 4', isComplete: false),
      ChecklistItemEntity(label: 'Water', value: '1.5 / 3 L', isComplete: false),
      ChecklistItemEntity(label: 'Tasks', value: '3 / 5', isComplete: false),
    ],
    stats: [
      StatChipEntity(
          title: '90.0 kg', subtitle: 'Current Weight', icon: 'scale'),
      StatChipEntity(
          title: '7h 20m', subtitle: "Last Night's Sleep", icon: 'moon'),
      StatChipEntity(
          title: '1,350 kcal', subtitle: 'Calories Consumed', icon: 'flame'),
    ],
    plan: [
      PlanItemEntity(
        title: 'Workout',
        subtitle: 'Day 1 – Chest, Shoulders & Triceps',
        icon: 'dumbbell',
        badge: null,
        isCompleted: false,
      ),
      PlanItemEntity(
        title: 'Meals',
        subtitle: '4 meals · 1,974 kcal',
        icon: 'apple',
        badge: '2 / 4',
        isCompleted: false,
      ),
      PlanItemEntity(
        title: 'Daily Tasks',
        subtitle: '3 of 5 completed',
        icon: 'check-square',
        badge: '3 / 5',
        isCompleted: false,
      ),
    ],
  );
});
