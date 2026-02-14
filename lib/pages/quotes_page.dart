import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../components/my_quote_card.dart';
import '../databases/quotes_database.dart';
import '../models/quote.dart';

class QuotesPage extends StatefulWidget {
  const QuotesPage({super.key});

  @override
  State<QuotesPage> createState() => _QuotesPageState();
}

class _QuotesPageState extends State<QuotesPage> {
  static const int _maxQuotes = 20;
  static const Duration _autoScrollDuration = Duration(seconds: 25);
  static const Duration _pageAnimDuration = Duration(milliseconds: 600);

  final PageController _pageController = PageController();

  List<Quote> _quotes = [];
  bool _isLoading = true;
  bool _isRefreshing = false;
  bool _hasError = false;

  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    _loadQuotes();
  }

  Future<void> _loadQuotes({bool isRefresh = false}) async {
    if (isRefresh) {
      setState(() => _isRefreshing = true);
    } else {
      setState(() => _isLoading = true);
    }

    try {
      final quotes = await QuotesDatabase.getAllQuotes(limit: _maxQuotes);

      if (!mounted) return;

      if (quotes.isEmpty && !isRefresh) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
        return;
      }

      setState(() {
        _quotes = quotes;
        _hasError = false;
        _isLoading = false;
        _isRefreshing = false;
      });

      if (!isRefresh) {
        _startAutoScroll();
      }
    } catch (e) {
      debugPrint('❌ Failed to load quotes: $e');
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Failed to load quotes. Please try again.',
            style: TextStyle(
              fontFamily: "Inter",
            ),
          ),
          action: SnackBarAction(
            label: 'Retry',
            onPressed: _loadQuotes,
          ),
        ),
      );

      setState(() {
        _isLoading = false;
        _isRefreshing = false;
        _hasError = true;
      });
    }
  }

  void _startAutoScroll() {
    _stopAutoScroll();

    _autoScrollTimer = Timer.periodic(_autoScrollDuration, (_) {
      if (!_pageController.hasClients ||
          _quotes.isEmpty ||
          _isRefreshing ||
          _hasError) {
        return;
      }

      final currentPage = (_pageController.page ?? 0).round();
      final nextPage = currentPage + 1;

      if (nextPage >= _quotes.length) {
        _refreshQuotes();
      } else {
        _pageController.animateToPage(
          nextPage,
          duration: _pageAnimDuration,
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _stopAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = null;
  }

  Future<void> _refreshQuotes() async {
    if (_isRefreshing || _isLoading) return;

    await _loadQuotes(isRefresh: true);
    _pageController.jumpToPage(0);
    _startAutoScroll();
  }

  Future<void> _toggleFavorite(Quote quote) async {
    final originalState = quote.isFavorite;
    quote.isFavorite = !originalState;

    if (mounted) {
      HapticFeedback.lightImpact();
      setState(() {});
    }

    try {
      await QuotesDatabase.toggleFavorite(quote.id);
    } catch (e) {
      debugPrint('❌ Failed to toggle favorite: $e');
      quote.isFavorite = originalState;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Failed to update favorite.',
              style: TextStyle(
                fontFamily: "Inter",
              ),
            ),
          ),
        );
        setState(() {});
      }
    }

    if (mounted && quote.isFavorite == !originalState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
          content: Text(
            quote.isFavorite ? 'Added to favorites' : 'Removed from favorites',
            style: const TextStyle(fontFamily: "Inter"),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _stopAutoScroll();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    if (_hasError && _quotes.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64),
              const SizedBox(height: 16),
              Text(
                'Unable to load quotes',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontFamily: "Inter"),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _loadQuotes,
                icon: const Icon(Icons.refresh),
                label: const Text(
                  'Retry',
                  style: TextStyle(
                    fontFamily: "Inter",
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SafeArea(
      child: RefreshIndicator.adaptive(
        onRefresh: _refreshQuotes,
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is UserScrollNotification) {
              if (notification.direction == ScrollDirection.idle) {
                _startAutoScroll();
              } else {
                _stopAutoScroll();
              }
            }
            return false;
          },
          child: PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            itemCount: _quotes.length,
            onPageChanged: (index) {
              if (index == _quotes.length - 1) {
                _refreshQuotes();
              }
            },
            itemBuilder: (_, index) {
              final quote = _quotes[index];
              return MyQuoteCard(
                key: ValueKey(quote.id),
                quote: quote,
                onFavoriteToggle: () => _toggleFavorite(quote),
              );
            },
          ),
        ),
      ),
    );
  }
}
