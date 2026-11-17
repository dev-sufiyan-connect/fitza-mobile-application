import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitza_mobile_application/core/theme/app_colors.dart';
import 'package:fitza_mobile_application/core/theme/app_theme.dart';
import 'package:fitza_mobile_application/core/widgets/asset_icon.dart';
import 'package:fitza_mobile_application/features/auth/presentation/providers/auth_providers.dart';
import 'package:fitza_mobile_application/features/auth/presentation/widgets/auth_hills_decoration.dart';
import 'package:fitza_mobile_application/features/home/presentation/providers/home_providers.dart';
import 'package:fitza_mobile_application/features/home/presentation/widgets/home_assets.dart';
import 'package:fitza_mobile_application/features/home/presentation/widgets/home_widgets.dart';

/// "Today" tab — the main dashboard.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  String _todayLabel() {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final now = DateTime.now();
    return '${days[now.weekday - 1]}, ${now.day} ${months[now.month - 1]}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(homeDashboardProvider);
    final user = ref.watch(authStateProvider).value;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Soft sage hills behind the header
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 190,
            child: AuthHillsDecoration(),
          ),
          SafeArea(
            child: dashboard.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
              error: (e, _) => Center(child: Text('$e')),
              data: (data) => ListView(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.lg),
                children: [
                  _Header(avatarPath: HomeAsset.avatar),
                  const SizedBox(height: AppSpacing.lg),
                  _Greeting(
                    greeting: _greeting(),
                    name: user?.fullName ?? 'there',
                    dateLabel: _todayLabel(),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  DashboardProgressCard(dashboard: data),
                  const SizedBox(height: AppSpacing.md),
                  StatChipRow(stats: data.stats),
                  const SizedBox(height: AppSpacing.xl),
                  _SectionHeader(),
                  const SizedBox(height: AppSpacing.md),
                  for (final item in data.plan) ...[
                    PlanCard(item: item),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  const _StartWorkoutButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.avatarPath});

  final String avatarPath;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const AssetIcon(HomeAsset.leafMark, size: 34),
        const SizedBox(width: AppSpacing.sm),
        Text(
          'fitza',
          style: context.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
        const Spacer(),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const AssetIcon(
                HomeAsset.bell,
                size: 20,
                color: AppColors.textDark,
              ),
            ),
            // Notification dot hugging the button's top-right corner
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                width: 11,
                height: 11,
                decoration: BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: AppSpacing.md),
        CircleAvatar(
          radius: 21,
          backgroundImage: AssetImage(avatarPath),
        ),
      ],
    );
  }
}

class _Greeting extends StatelessWidget {
  const _Greeting({
    required this.greeting,
    required this.name,
    required this.dateLabel,
  });

  final String greeting;
  final String name;
  final String dateLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$greeting 👋',
                style: context.textTheme.titleMedium
                    ?.copyWith(color: AppColors.mutedText),
              ),
              const SizedBox(height: 2),
              Text(
                name,
                style: context.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                "Let's stay consistent and make progress today!",
                style: context.textTheme.bodyMedium
                    ?.copyWith(color: AppColors.mutedText, height: 1.35),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AssetIcon(HomeAsset.calendar,
                  size: 16, color: AppColors.secondary),
              const SizedBox(width: AppSpacing.xs),
              Text(
                dateLabel,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Today's Plan",
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            padding:
                const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          ),
          child: const Text(
            'View All  →',
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: AppColors.secondary,
            ),
          ),
        ),
      ],
    );
  }
}

class _StartWorkoutButton extends StatelessWidget {
  const _StartWorkoutButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: FilledButton.icon(
        onPressed: () {},
        style: FilledButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        ),
        icon: const Icon(Icons.play_circle_fill, size: 26),
        label: const Text(
          "Start Today's Workout  →",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.onPrimary,
          ),
        ),
      ),
    );
  }
}
