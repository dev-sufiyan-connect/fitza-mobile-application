import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import 'package:fitza_mobile_application/core/error/failures.dart';
import 'package:fitza_mobile_application/core/router/route_names.dart';
import 'package:fitza_mobile_application/core/theme/app_colors.dart';
import 'package:fitza_mobile_application/core/utils/date_utils.dart';
import 'package:fitza_mobile_application/core/utils/youtube_utils.dart';
import 'package:fitza_mobile_application/core/widgets/asset_icon.dart';
import 'package:fitza_mobile_application/core/widgets/shimmer.dart';
import 'package:fitza_mobile_application/features/fitness/domain/entities/workout_exercise_detail_entity.dart';
import 'package:fitza_mobile_application/features/fitness/presentation/providers/fitness_providers.dart';
import 'package:fitza_mobile_application/features/fitness/presentation/widgets/fitness_assets.dart';
import 'package:fitza_mobile_application/features/home/presentation/widgets/home_assets.dart';

/// Full-screen details for a single exercise.
class ExerciseDetailsScreen extends ConsumerWidget {
  const ExerciseDetailsScreen({super.key, required this.planExerciseId});

  final String planExerciseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = toIsoDate(ref.watch(selectedFitnessDateProvider));
    final details = ref.watch(
      workoutExerciseDetailProvider((
        selectedDate: selectedDate,
        planExerciseId: planExerciseId,
      )),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: details.when(
          loading: () => const _ExerciseDetailsSkeleton(),
          error: (e, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                _failureMessage(e),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.mutedText,
                ),
              ),
            ),
          ),
          data: (data) => Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  children: [
                    _TopBar(details: data),
                    const SizedBox(height: 14),
                    _Segments(
                      filled: data.exercisePosition,
                      total: data.totalExercises,
                    ),
                    const SizedBox(height: 14),
                    _VideoPreview(exercise: data.exercise),
                    const SizedBox(height: 14),
                    _TitleBlock(exercise: data.exercise),
                    const SizedBox(height: 14),
                    _StatsRow(details: data),
                    if (data.exercise.description.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _AboutCard(exercise: data.exercise),
                    ],
                    if (data.exercise.instructions.isNotEmpty ||
                        data.exercise.planInstructions != null) ...[
                      const SizedBox(height: 14),
                      _InstructionsCard(exercise: data.exercise),
                    ],
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
                    _SetsTable(rows: data.sets),
                    if (_firstRestSeconds(data.sets) != null) ...[
                      const SizedBox(height: 14),
                      _RestTimeCard(seconds: _firstRestSeconds(data.sets)!),
                    ],
                    const SizedBox(height: 14),
                    const _NotesField(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: _BottomActions(day: data.workoutDayNumber),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _failureMessage(Object? error) =>
    error is Failure ? error.message : '$error';

String _dayLabel(WorkoutExerciseDetailEntity details) {
  final day = 'Day ${details.workoutDayNumber.toString().padLeft(2, '0')}';
  final title = details.workoutTitle.trim();
  if (title.isEmpty ||
      title.toLowerCase() == day.toLowerCase() ||
      title.toLowerCase() == 'day ${details.workoutDayNumber}') {
    return day;
  }
  return '$day · $title';
}

String _exerciseSubtitle(WorkoutExerciseInfoEntity exercise) {
  final difficulty = exercise.difficulty.trim();
  final formattedDifficulty = difficulty.isEmpty
      ? ''
      : '${difficulty[0].toUpperCase()}${difficulty.substring(1)}';

  return [
    if (exercise.categoryName.isNotEmpty) exercise.categoryName,
    if (formattedDifficulty.isNotEmpty) formattedDifficulty,
    if (exercise.isCompound) 'Compound',
    if (exercise.isUnilateral) 'Unilateral',
  ].join(' · ');
}

String _targetReps(WorkoutExerciseSetEntity set) {
  final min = set.targetRepsMin;
  final max = set.targetRepsMax;
  if (min != null && max != null) {
    return min == max ? '$min' : '$min – $max';
  }
  if (min != null) return '$min+';
  if (set.targetDurationSeconds != null) return '${set.targetDurationSeconds}s';
  return '—';
}

String _displayReps(WorkoutExerciseSetEntity set) {
  if (set.actualReps != null) return '${set.actualReps}';
  if (set.actualDurationSeconds != null) return '${set.actualDurationSeconds}s';
  return _targetReps(set);
}

String _repsSummary(List<WorkoutExerciseSetEntity> sets) {
  for (final set in sets) {
    final reps = _targetReps(set);
    if (reps != '—') return reps;
  }
  return '—';
}

String _weightLabel(WorkoutExerciseSetEntity set) {
  final weight = set.actualWeightKg ?? set.targetWeightKg;
  if (weight == null) return '—';
  return weight == weight.roundToDouble()
      ? '${weight.toInt()}'
      : weight.toStringAsFixed(1);
}

int? _firstRestSeconds(List<WorkoutExerciseSetEntity> sets) {
  for (final set in sets) {
    if (set.restSeconds != null) return set.restSeconds;
  }
  return null;
}

String _restLabel(int? seconds) {
  if (seconds == null) return '—';
  if (seconds < 60) return '$seconds sec';
  final minutes = seconds ~/ 60;
  final remainder = seconds % 60;
  if (remainder == 0) return '$minutes min';
  return '$minutes min $remainder sec';
}

String _clockLabel(int seconds) {
  final minutes = seconds ~/ 60;
  final remainder = seconds % 60;
  return '${minutes.toString().padLeft(2, '0')}:'
      '${remainder.toString().padLeft(2, '0')}';
}

class _ExerciseDetailsSkeleton extends StatelessWidget {
  const _ExerciseDetailsSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        Shimmer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ShimmerBox(width: 24, height: 24, shape: BoxShape.circle),
                  Spacer(),
                  ShimmerBox(width: 84, height: 24, radius: 12),
                ],
              ),
              SizedBox(height: 16),
              ShimmerBox(width: double.infinity, height: 6, radius: 3),
              SizedBox(height: 16),
              ShimmerBox(width: double.infinity, height: 200, radius: 18),
              SizedBox(height: 16),
              ShimmerBox(width: 220, height: 22),
              SizedBox(height: 8),
              ShimmerBox(width: 160, height: 13),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ShimmerBox(
                      width: double.infinity,
                      height: 64,
                      radius: 14,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: ShimmerBox(
                      width: double.infinity,
                      height: 64,
                      radius: 14,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: ShimmerBox(
                      width: double.infinity,
                      height: 64,
                      radius: 14,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 22),
              ShimmerBox(width: 140, height: 20),
              SizedBox(height: 12),
              ShimmerBox(width: double.infinity, height: 130, radius: 14),
            ],
          ),
        ),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.details});

  final WorkoutExerciseDetailEntity details;

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
              _dayLabel(details),
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
            '${details.exercisePosition} of ${details.totalExercises}',
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
    if (total <= 0) return const SizedBox.shrink();

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

class _VideoPreview extends StatefulWidget {
  const _VideoPreview({required this.exercise});

  final WorkoutExerciseInfoEntity exercise;

  @override
  State<_VideoPreview> createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<_VideoPreview> {
  static const _playerParams = YoutubePlayerParams(
    showControls: true,
    showFullscreenButton: true,
    playsInline: true,
    strictRelatedVideos: true,
    // YouTube now requires a valid embed origin/referer. Without this,
    // Android WebView shows "This video is unavailable" (error 152/153).
    origin: 'https://www.youtube-nocookie.com',
  );

  YoutubePlayerController? _controller;
  late final String? _videoId = parseYoutubeVideoId(widget.exercise.videoPath);

  void _playVideo() {
    final videoId = _videoId;
    if (videoId == null) return;

    // Do not pass the video id as the controller key: ids containing "-"
    // produce an invalid JavaScript identifier in youtube_player_iframe 5.x
    // (e.g. `Youtube0nrW-q7-WRQ.postMessage(...)`), so player events never
    // reach Dart. Load the video explicitly instead.
    final controller = YoutubePlayerController(params: _playerParams)
      ..loadVideoById(videoId: videoId);

    setState(() => _controller = controller);
  }

  Future<void> _openInYouTube() async {
    final videoId = _videoId;
    if (videoId == null) return;

    final uri = Uri.parse('https://www.youtube.com/watch?v=$videoId');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  void dispose() {
    _controller?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (controller != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: YoutubeValueBuilder(
          controller: controller,
          builder: (context, value) {
            if (value.hasError) {
              return _VideoUnavailable(onOpenInYouTube: _openInYouTube);
            }

            return YoutubePlayer(
              controller: controller,
              aspectRatio: 16 / 9,
            );
          },
        ),
      );
    }

    final exercise = widget.exercise;
    final thumbnail = exercise.thumbnailPath;
    final fallback = Image.asset(FitnessAsset.hero, fit: BoxFit.cover);
    final canPlay = _videoId != null;

    return GestureDetector(
      onTap: canPlay ? _playVideo : null,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: SizedBox(
          height: 200,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (thumbnail.startsWith('http'))
                Image.network(
                  thumbnail,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => fallback,
                )
              else
                fallback,
              if (canPlay) ...[
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
            ],
          ),
        ),
      ),
    );
  }
}

class _VideoUnavailable extends StatelessWidget {
  const _VideoUnavailable({required this.onOpenInYouTube});

  final VoidCallback onOpenInYouTube;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      color: const Color(0xFF15171A),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.play_disabled_rounded,
            size: 30,
            color: Colors.white70,
          ),
          const SizedBox(height: 10),
          const Text(
            'This video cannot be played in the app.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onOpenInYouTube,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white54),
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 8,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            icon: const Icon(Icons.open_in_new_rounded, size: 15),
            label: const Text(
              'Watch on YouTube',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TitleBlock extends StatelessWidget {
  const _TitleBlock({required this.exercise});

  final WorkoutExerciseInfoEntity exercise;

  @override
  Widget build(BuildContext context) {
    final subtitle = _exerciseSubtitle(exercise);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                exercise.name,
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
        if (subtitle.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: AppColors.mutedText,
            ),
          ),
        ],
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.details});

  final WorkoutExerciseDetailEntity details;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.layers_rounded,
            label: 'Sets',
            value: '${details.sets.length}',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatCard(
            icon: Icons.sync_rounded,
            label: 'Reps',
            value: _repsSummary(details.sets),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatAssetCard(
            icon: HomeAsset.dumbbell,
            label: 'Rest',
            value: _restLabel(_firstRestSeconds(details.sets)),
          ),
        ),
      ],
    );
  }
}

class _AboutCard extends StatelessWidget {
  const _AboutCard({required this.exercise});

  final WorkoutExerciseInfoEntity exercise;

  @override
  Widget build(BuildContext context) {
    final tags = [...exercise.muscleGroups, ...exercise.equipment];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEFF1EC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About this exercise',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            exercise.description,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: AppColors.mutedText,
              height: 1.45,
            ),
          ),
          if (tags.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final tag in tags)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F5F2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _InstructionsCard extends StatelessWidget {
  const _InstructionsCard({required this.exercise});

  final WorkoutExerciseInfoEntity exercise;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEFF1EC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'How to perform',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          for (final (i, step) in exercise.instructions.indexed) ...[
            const SizedBox(height: 9),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE5F4DC),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${i + 1}',
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    step,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textDark,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ],
          if (exercise.planInstructions != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF8E8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                exercise.planInstructions!,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.secondary,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ],
      ),
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

  final List<WorkoutExerciseSetEntity> rows;

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFEFF1EC)),
        ),
        child: const Text(
          'No sets prescribed for this exercise.',
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
            color: AppColors.mutedText,
          ),
        ),
      );
    }

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
                SizedBox(width: 44, child: Text('Set', style: _headerStyle)),
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
                        '${row.setNumber ?? i + 1}',
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
                    child: _WeightStepper(weight: _weightLabel(row)),
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
                        _displayReps(row),
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
  const _RestTimeCard({required this.seconds});

  final int seconds;

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
                  value: 1,
                  strokeWidth: 4,
                  backgroundColor: Colors.white.withValues(alpha: 0.18),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFFA9DC7E),
                  ),
                ),
                Center(
                  child: Text(
                    _clockLabel(seconds),
                    style: const TextStyle(
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
                  'Between sets',
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
