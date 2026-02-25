import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../components/my_nav_bar.dart';
import 'favorites_page.dart';
import 'quotes_page.dart';
import 'search_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  static const _animationDuration = Duration(milliseconds: 320);

  static const _exitConfirmationMessage = 'Press back again to exit';

  int _currentIndex = 0;
  bool _isExiting = false;

  /// Lazy page cache (better performance)
  final Map<int, Widget> _pageCache = {};

  Widget _getPage(int index) {
    if (_pageCache.containsKey(index)) {
      return _pageCache[index]!;
    }

    late Widget page;

    switch (index) {
      case 0:
        page = const QuotesPage();
        break;
      case 1:
        page = const FavoritesPage();
        break;
      case 2:
        page = const SearchPage();
        break;
      default:
        page = const SettingsPage();
    }

    _pageCache[index] = page;
    return page;
  }

  // ================= TAB CHANGE =================

  void _onTabChanged(int index) {
    if (index == _currentIndex) {
      // Scroll-to-top / refresh hook
      HapticFeedback.selectionClick();
      return;
    }

    HapticFeedback.mediumImpact();

    setState(() {
      _currentIndex = index;
      _isExiting = false;
    });
  }

  // ================= BACK HANDLING =================

  Future<bool> _onWillPop() async {
    if (_currentIndex != 0) {
      _onTabChanged(0);
      return false;
    }

    if (_isExiting) return true;

    setState(() => _isExiting = true);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
        content: Text(
          _exitConfirmationMessage,
          style: TextStyle(fontFamily: "Inter"),
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isExiting = false);
    });

    return false;
  }

  // ================= PAGE TRANSITION =================

  Widget _buildTransition(Widget child) {
    return AnimatedSwitcher(
      duration: _animationDuration,
      switchInCurve: Curves.easeOutQuart,
      switchOutCurve: Curves.easeInQuart,
      transitionBuilder: (child, animation) {
        final slide = Tween<Offset>(
          begin: const Offset(0.08, 0),
          end: Offset.zero,
        ).animate(animation);

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: slide,
            child: child,
          ),
        );
      },
      child: KeyedSubtree(
        key: ValueKey(_currentIndex),
        child: child,
      ),
    );
  }

  // ================= BUILD =================

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: colors.surface,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          bottom: false,
          child: _buildTransition(
            IndexedStack(
              index: _currentIndex,
              children: List.generate(
                4,
                (i) => _getPage(i),
              ),
            ),
          ),
        ),
        bottomNavigationBar: MyNavBar(
          currentIndex: _currentIndex,
          onTabChange: _onTabChanged,
        ),
      ),
    );
  }
}
