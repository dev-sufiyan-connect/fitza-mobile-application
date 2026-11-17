/// Dashboard data shown on the Today tab.
/// Pure business objects — no Flutter imports.
class HomeDashboardEntity {
  const HomeDashboardEntity({
    required this.progressPercent,
    required this.checklist,
    required this.stats,
    required this.plan,
  });

  final int progressPercent;
  final List<ChecklistItemEntity> checklist;
  final List<StatChipEntity> stats;
  final List<PlanItemEntity> plan;
}

class ChecklistItemEntity {
  const ChecklistItemEntity({
    required this.label,
    required this.value,
    required this.isComplete,
  });

  final String label;
  final String value;
  final bool isComplete;
}

class StatChipEntity {
  const StatChipEntity({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final String icon; // asset path
}

class PlanItemEntity {
  const PlanItemEntity({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.badge,
    required this.isCompleted,
  });

  final String title;
  final String subtitle;
  final String icon; // asset path
  final String? badge; // e.g. "2 / 4" — null renders a plain check circle
  final bool isCompleted;
}
