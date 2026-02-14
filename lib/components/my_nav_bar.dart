import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MyNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabChange;

  const MyNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabChange,
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
    final brightness = theme.brightness;
    final isDark = brightness == Brightness.dark;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colorScheme.surface.withOpacity(isDark ? 0.55 : 0.65),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: Colors.white.withOpacity(isDark ? 0.08 : 0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 30,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: _buildGNav(colorScheme, isDark),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGNav(ColorScheme colorScheme, bool isDark) {
    return GNav(
      selectedIndex: currentIndex,
      onTabChange: onTabChange,
      gap: 10,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      iconSize: 22,
      color: colorScheme.onSurface.withOpacity(0.7),
      activeColor: colorScheme.primary,
      tabBackgroundColor: colorScheme.primary.withOpacity(isDark ? 0.22 : 0.15),
      tabBorderRadius: 28,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      textStyle: const TextStyle(fontFamily: "Inter"),
      tabs: _tabs.map((tab) {
        return GButton(
          icon: tab.icon,
          text: tab.label,
          onPressed: () {
            final index = _tabs.indexOf(tab);
            if (index != currentIndex) {
              onTabChange(index);
            }
          },
        );
      }).toList(growable: false),
    );
  }
}

class _TabData {
  final IconData icon;
  final String label;

  const _TabData({required this.icon, required this.label});

  @override
  bool operator ==(Object other) =>
      other is _TabData && icon == other.icon && label == other.label;

  @override
  int get hashCode => Object.hash(icon, label);
}
