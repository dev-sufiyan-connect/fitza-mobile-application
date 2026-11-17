import 'package:flutter/material.dart';

import 'package:fitza_mobile_application/core/theme/app_colors.dart';
import 'package:fitza_mobile_application/core/widgets/asset_icon.dart';
import 'package:go_router/go_router.dart';

/// Asset paths for the bottom navigation icons (home screen pack).
abstract final class _NavIcons {
  static const String _base = 'assets/fitza_home_screen_assets';
  static const String home = '$_base/home.svg';
  static const String dumbbell = '$_base/dumbbell.svg';
  static const String meal = '$_base/meal.svg';
  static const String chartProgress = '$_base/chart-progress.svg';
  static const String user = '$_base/user.svg';
}

/// Scaffold shell hosting the tab navigation shell and the Fitza bottom bar.
class FitzaShell extends StatelessWidget {
  const FitzaShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
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
    (label: 'Today', icon: _NavIcons.home),
    (label: 'Fitness', icon: _NavIcons.dumbbell),
    (label: 'Nutrition', icon: _NavIcons.meal),
    (label: 'Progress', icon: _NavIcons.chartProgress),
    (label: 'Profile', icon: _NavIcons.user),
  ];
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final ({String label, String icon}) item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.mutedText;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 54,
            height: 32,
            decoration: BoxDecoration(
              color: selected ? const Color(0xFFE7F3E4) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: AssetIcon(item.icon, size: 22, color: color),
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
        ],
      ),
    );
  }
}
