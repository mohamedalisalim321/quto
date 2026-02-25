import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MyNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabChange;
  final Map<int, int>? badges;

  const MyNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabChange,
    this.badges,
  });

  static const List<_TabData> _tabs = [
    _TabData(icon: Icons.format_quote_rounded, label: 'Quotes'),
    _TabData(icon: Icons.favorite_rounded, label: 'Favorites'),
    _TabData(icon: Icons.search_rounded, label: 'Search'),
    _TabData(icon: Icons.settings_rounded, label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 0.h, 16.w, 20.h),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28.r),
            color: colorScheme.surface.withOpacity(isDark ? 0.9 : 0.95),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28.r),
            child: _buildNav(context),
          ),
        ),
      ),
    );
  }

  Widget _buildNav(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GNav(
      selectedIndex: currentIndex,
      gap: 8.w,
      iconSize: 22.w,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
      color: colorScheme.onSurface.withOpacity(0.6),
      activeColor: colorScheme.primary,
      tabBackgroundColor: colorScheme.primary.withOpacity(0.12),
      tabBorderRadius: 20.r,
      rippleColor: Colors.transparent,
      hoverColor: Colors.transparent,
      textStyle: TextStyle(
        fontFamily: "Inter",
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
        color: colorScheme.primary,
      ),
      tabs: List.generate(_tabs.length, (index) {
        final tab = _tabs[index];

        return GButton(
          icon: tab.icon,
          text: tab.label,
          onPressed: () {
            if (index == currentIndex) {
              HapticFeedback.selectionClick();
            } else {
              HapticFeedback.lightImpact();
              onTabChange(index);
            }
          },
        );
      }),
    );
  }
}

class _TabData {
  final IconData icon;
  final String label;

  const _TabData({
    required this.icon,
    required this.label,
  });
}
