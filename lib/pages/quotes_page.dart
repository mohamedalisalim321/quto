import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../components/my_quote_card.dart';
import '../databases/quotes_database.dart';
import '../models/quote.dart';

class QuotesPage extends StatefulWidget {
  const QuotesPage({super.key});

  @override
  State<QuotesPage> createState() => _QuotesPageState();
}

class _QuotesPageState extends State<QuotesPage> with WidgetsBindingObserver {
  static const int _batchSize = 5;

  final PageController _pageController = PageController();

  final List<Quote> _quotes = [];
  bool _isLoading = true;
  bool _isFetchingMore = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadInitialQuotes();
  }

  /// ============================
  /// INITIAL LOAD
  /// ============================

  Future<void> _loadInitialQuotes() async {
    setState(() => _isLoading = true);

    final quotes = await QuotesDatabase.getRandomBatch(_batchSize);

    if (!mounted) return;

    setState(() {
      _quotes.addAll(quotes);
      _hasMore = quotes.isNotEmpty;
      _isLoading = false;
    });
  }

  /// ============================
  /// LOAD MORE (Infinite Scroll)
  /// ============================

  Future<void> _loadMoreQuotes() async {
    if (_isFetchingMore || !_hasMore) return;

    _isFetchingMore = true;

    final quotes = await QuotesDatabase.getRandomBatch(_batchSize);

    if (!mounted) return;

    setState(() {
      _quotes.addAll(quotes);
      _hasMore = quotes.isNotEmpty;
    });

    _isFetchingMore = false;
  }

  /// ============================
  /// PAGE CHANGE
  /// ============================

  Future<void> _onPageChanged(int index) async {
    if (index >= _quotes.length - 1) {
      _loadMoreQuotes();
    }
  }

  /// ============================
  /// FAVORITE
  /// ============================

  Future<void> _toggleFavorite(Quote quote) async {
    final original = quote.isFavorite;
    quote.isFavorite = !original;

    HapticFeedback.lightImpact();
    setState(() {});

    try {
      await QuotesDatabase.toggleFavorite(quote.id);
    } catch (_) {
      quote.isFavorite = original;
      if (mounted) setState(() {});
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pageController.dispose();
    super.dispose();
  }

  /// ============================
  /// UI
  /// ============================

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    }

    return SafeArea(
      child: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        itemCount: _quotes.length,
        onPageChanged: _onPageChanged,
        itemBuilder: (_, index) {
          final quote = _quotes[index];

          return MyQuoteCard(
            key: ValueKey(quote.id),
            quote: quote,
            onFavoriteToggle: () => _toggleFavorite(quote),
          );
        },
      ),
    );
  }
}
