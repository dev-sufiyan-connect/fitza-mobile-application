import 'package:flutter/material.dart';

import 'package:fitza_mobile_application/core/theme/app_colors.dart';
import 'package:fitza_mobile_application/core/widgets/asset_icon.dart';
import 'package:go_router/go_router.dart';

/// Asset paths for the bottom navigation icons.
/// Filled variants render on the active tab, outline on the rest.
abstract final class _NavIcons {
  static const String _base = 'assets/fitza_bottom_nav_svg_pack';
  static const String todayOutline = '$_base/today.svg';
  static const String todayFilled = '$_base/today-filled.svg';
  static const String fitnessOutline = '$_base/fitness.svg';
  static const String fitnessFilled = '$_base/fitness-filled.svg';
  static const String nutritionOutline = '$_base/nutrition.svg';
  static const String nutritionFilled = '$_base/nutrition-filled.svg';
  static const String progressOutline = '$_base/progress.svg';
  static const String progressFilled = '$_base/progress-filled.svg';
  static const String profileOutline = '$_base/profile.svg';
  static const String profileFilled = '$_base/profile-filled.svg';
}

/// Scaffold shell hosting the tab navigation shell and the Fitza bottom bar.
class FitzaShell extends StatelessWidget {
  const FitzaShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: AppColors.textDark.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: SafeArea(
          minimum: const EdgeInsets.only(top: 8, bottom: 4),
          child: Row(
            children: [
              for (final (i, item) in _items.indexed)
                Expanded(
                  child: _NavItem(
                    item: item,
                    selected: navigationShell.currentIndex == i,
                    onTap: () => navigationShell.goBranch(
                      i,
                      initialLocation: i == navigationShell.currentIndex,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  static const _items = [
    (
      label: 'Today',
      outline: _NavIcons.todayOutline,
      filled: _NavIcons.todayFilled,
    ),
    (
      label: 'Fitness',
      outline: _NavIcons.fitnessOutline,
      filled: _NavIcons.fitnessFilled,
    ),
    (
      label: 'Nutrition',
      outline: _NavIcons.nutritionOutline,
      filled: _NavIcons.nutritionFilled,
    ),
    (
      label: 'Progress',
      outline: _NavIcons.progressOutline,
      filled: _NavIcons.progressFilled,
    ),
    (
      label: 'Profile',
      outline: _NavIcons.profileOutline,
      filled: _NavIcons.profileFilled,
    ),
  ];
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final ({String label, String outline, String filled}) item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.mutedText;
    final icon = selected ? item.filled : item.outline;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 30,
            decoration: BoxDecoration(
              color: selected ? const Color(0xFFE7F3E4) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: AssetIcon(icon, size: 10, color: color),
          ),
          const SizedBox(height: 2),
          Text(
            item.label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
              color: color,
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
