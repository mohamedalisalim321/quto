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
  static const _animationDuration = Duration(milliseconds: 280);
  static const _exitConfirmationMessage = 'Press back again to exit';

  int _currentIndex = 0;
  bool _isExiting = false;

  //
  final List<Widget> _pages = const [
    QuotesPage(),
    FavoritesPage(),
    SearchPage(),
    SettingsPage(),
  ];

  void _onTabChanged(int index) {
    if (index == _currentIndex) return;

    HapticFeedback.lightImpact();

    setState(() {
      _currentIndex = index;
      _isExiting = false;
    });
  }

  Future<bool> _onWillPop() async {
    if (_currentIndex != 0) {
      _onTabChanged(0);
      return false;
    }

    if (_isExiting) {
      return true;
    } else {
      setState(() => _isExiting = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            _exitConfirmationMessage,
            style: TextStyle(
              fontFamily: "Inter",
            ),
          ),
          duration: Duration(seconds: 2),
        ),
      );

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => _isExiting = false);
        }
      });

      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          bottom: false,
          child: AnimatedSwitcher(
            duration: _animationDuration,
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.03, 0.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: IndexedStack(
              key: ValueKey<int>(_currentIndex),
              index: _currentIndex,
              children: _pages,
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
