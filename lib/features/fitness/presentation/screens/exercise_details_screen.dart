import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:fitza_mobile_application/core/router/route_names.dart';
import 'package:fitza_mobile_application/core/theme/app_colors.dart';
import 'package:fitza_mobile_application/core/widgets/asset_icon.dart';
import 'package:fitza_mobile_application/features/fitness/domain/entities/fitness_entity.dart';
import 'package:fitza_mobile_application/features/fitness/presentation/providers/fitness_providers.dart';
import 'package:fitza_mobile_application/features/fitness/presentation/widgets/fitness_assets.dart';
import 'package:fitza_mobile_application/features/home/presentation/widgets/home_assets.dart';

/// Full-screen details for a single exercise.
class ExerciseDetailsScreen extends ConsumerWidget {
  const ExerciseDetailsScreen({
    super.key,
    required this.day,
    required this.exerciseIndex,
  });

  final int day;
  final int exerciseIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final details = ref.watch(
      exerciseDetailsProvider((day: day, index: exerciseIndex)),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: details.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (e, _) => Center(child: Text('$e')),
          data: (data) => Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  children: [
                    _TopBar(details: data),
                    const SizedBox(height: 14),
                    _Segments(
                      filled: data.position,
                      total: data.total,
                    ),
                    const SizedBox(height: 14),
                    const _VideoPreview(),
                    const SizedBox(height: 14),
                    _TitleBlock(details: data),
                    const SizedBox(height: 14),
                    _StatsRow(details: data),
                    const SizedBox(height: 22),
                    const Text(
                      'Track Your Sets',
                      style: TextStyle(
                        fontSize: 18.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _SetsTable(rows: data.setRows),
                    const SizedBox(height: 14),
                    const _RestTimeCard(),
                    const SizedBox(height: 14),
                    const _NotesField(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: _BottomActions(day: day),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.details});

  final ExerciseDetailsEntity details;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () => context.pop(),
          borderRadius: BorderRadius.circular(20),
          child: const Padding(
            padding: EdgeInsets.all(4),
            child: Icon(
              Icons.arrow_back_rounded,
              size: 24,
              color: AppColors.textDark,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Center(
            child: Text(
              details.dayLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: AppColors.mutedText,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFE5F4DC),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            '${details.position} of ${details.total}',
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
              color: AppColors.secondary,
            ),
          ),
        ),
      ],
    );
  }
}

class _Segments extends StatelessWidget {
  const _Segments({required this.filled, required this.total});

  final int filled;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < total; i++) ...[
          if (i > 0) const SizedBox(width: 6),
          Expanded(
            child: Container(
              height: 6,
              decoration: BoxDecoration(
                color: i < filled
                    ? AppColors.secondary
                    : const Color(0xFF3E4A40),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _VideoPreview extends StatelessWidget {
  const _VideoPreview();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: SizedBox(
        height: 200,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(FitnessAsset.hero, fit: BoxFit.cover),
            Center(
              child: Container(
                width: 54,
                height: 54,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.92),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  size: 32,
                  color: AppColors.textDark,
                ),
              ),
            ),
            Positioned(
              right: 10,
              bottom: 10,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.play_circle_outline_rounded,
                      size: 13,
                      color: Colors.white,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Video Demo',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TitleBlock extends StatelessWidget {
  const _TitleBlock({required this.details});

  final ExerciseDetailsEntity details;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                details.name,
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                  height: 1.15,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFE5F4DC),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 13,
                    color: AppColors.secondary,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Exercise Info',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          details.subtitle,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
            color: AppColors.mutedText,
          ),
        ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.details});

  final ExerciseDetailsEntity details;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.layers_rounded,
            label: 'Sets',
            value: details.sets,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatCard(
            icon: Icons.sync_rounded,
            label: 'Reps',
            value: details.reps,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatAssetCard(
            icon: HomeAsset.dumbbell,
            label: 'Rest',
            value: details.rest,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEFF1EC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 15, color: AppColors.primary),
              const SizedBox(width: 5),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.mutedText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatAssetCard extends StatelessWidget {
  const _StatAssetCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final String icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEFF1EC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AssetIcon(icon, size: 15, color: AppColors.primary),
              const SizedBox(width: 5),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.mutedText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _SetsTable extends StatelessWidget {
  const _SetsTable({required this.rows});

  final List<ExerciseSetEntity> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEFF1EC)),
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            child: Row(
              children: [
                SizedBox(
                  width: 44,
                  child: Text(
                    'Set',
                    style: _headerStyle,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Center(
                    child: Text('Weight (kg)', style: _headerStyle),
                  ),
                ),
                SizedBox(
                  width: 64,
                  child: Center(child: Text('Reps', style: _headerStyle)),
                ),
                SizedBox(
                  width: 60,
                  child: Center(child: Text('Status', style: _headerStyle)),
                ),
              ],
            ),
          ),
          for (final (i, row) in rows.indexed) ...[
            Container(height: 1, color: const Color(0xFFF1F3EF)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 44,
                    child: Container(
                      width: 26,
                      height: 26,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE5F4DC),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${i + 1}',
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: _WeightStepper(weight: row.weightText),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 54,
                    child: Container(
                      height: 34,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE4E9E2)),
                      ),
                      child: Text(
                        '${row.reps}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 60,
                    child: Center(
                      child: row.isCompleted
                          ? Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: const Icon(
                                Icons.check,
                                size: 16,
                                color: Colors.white,
                              ),
                            )
                          : Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(7),
                                border: Border.all(
                                  color: const Color(0xFFC9D2CA),
                                  width: 1.5,
                                ),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

const _headerStyle = TextStyle(
  fontSize: 11.5,
  fontWeight: FontWeight.w600,
  color: AppColors.mutedText,
);

class _WeightStepper extends StatelessWidget {
  const _WeightStepper({required this.weight});

  final String weight;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F5F2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Icon(
              Icons.remove_rounded,
              size: 16,
              color: AppColors.textDark.withValues(alpha: 0.7),
            ),
          ),
          Expanded(
            child: Container(
              height: 26,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE9EDE7)),
              ),
              child: Text(
                weight,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 28,
            child: Icon(
              Icons.add_rounded,
              size: 16,
              color: AppColors.textDark.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class _RestTimeCard extends StatelessWidget {
  const _RestTimeCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF1E4F27), Color(0xFF12331B)],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 58,
            height: 58,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: 0.82,
                  strokeWidth: 4,
                  backgroundColor: Colors.white.withValues(alpha: 0.18),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFFA9DC7E),
                  ),
                ),
                const Center(
                  child: Text(
                    '01:25',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rest time',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Next set: Set 3',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: Color(0xCCFFFFFF),
                  ),
                ),
              ],
            ),
          ),
          _CircleAction(icon: Icons.pause_rounded),
          const SizedBox(width: 8),
          _CircleAction(icon: Icons.refresh_rounded),
        ],
      ),
    );
  }
}

class _CircleAction extends StatelessWidget {
  const _CircleAction({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 20, color: Colors.white),
    );
  }
}

class _NotesField extends StatelessWidget {
  const _NotesField();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8ECE6)),
      ),
      child: const Row(
        children: [
          Icon(Icons.edit_outlined, size: 16, color: AppColors.mutedText),
          SizedBox(width: 8),
          Text(
            'Add notes (optional)',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: AppColors.mutedText,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomActions extends StatelessWidget {
  const _BottomActions({required this.day});

  final int day;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: SizedBox(
            height: 48,
            child: Material(
              color: const Color(0xFFE5F4DC),
              borderRadius: BorderRadius.circular(24),
              child: InkWell(
                onTap: () => context.pop(),
                borderRadius: BorderRadius.circular(24),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chevron_left_rounded,
                      size: 20,
                      color: AppColors.secondary,
                    ),
                    SizedBox(width: 2),
                    Text(
                      'Previous',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 3,
          child: SizedBox(
            height: 48,
            child: Material(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(24),
              child: InkWell(
                onTap: () => context.pushNamed(
                  RouteNames.workoutCompleted,
                  pathParameters: {'day': '$day'},
                ),
                borderRadius: BorderRadius.circular(24),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check, size: 18, color: Colors.white),
                    SizedBox(width: 6),
                    Text(
                      'Mark as Complete',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
