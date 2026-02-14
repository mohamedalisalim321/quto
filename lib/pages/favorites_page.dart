import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../components/my_favorite_card.dart';
import '../databases/quotes_database.dart';
import '../models/quote.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late Future<List<Quote>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() {
    setState(() {
      _favoritesFuture = QuotesDatabase.getFavoriteQuotes();
    });
  }

  Future<void> _removeFromFavorites(Quote quote) async {
    if (!mounted) return;
    HapticFeedback.lightImpact();

    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.r),
      ),
      content: const Text(
        'Removed from favorites',
        style: TextStyle(
          fontFamily: "Inter",
        ),
      ),
      action: SnackBarAction(
        label: 'UNDO',
        onPressed: () async {
          await QuotesDatabase.toggleFavorite(quote.id);
          if (mounted) _loadFavorites();
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    try {
      await QuotesDatabase.toggleFavorite(quote.id);
      _loadFavorites();
    } catch (e) {
      debugPrint('❌ Failed to remove favorite: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update. Please try again.')),
        );
        _loadFavorites();
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          _pageTitle(textTheme),
          Expanded(
            child: RefreshIndicator.adaptive(
              onRefresh: () async => _loadFavorites(),
              child: FutureBuilder<List<Quote>>(
                future: _favoritesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(colorScheme.primary),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return _errorState(context, colorScheme, textTheme);
                  }

                  final quotes = snapshot.data ?? [];

                  if (quotes.isEmpty) {
                    return _emptyState(context, colorScheme, textTheme);
                  }

                  return ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(16.w),
                    itemCount: quotes.length,
                    itemBuilder: (_, index) {
                      final quote = quotes[index];
                      return MyFavoriteCard(
                        key: ValueKey(quote.id),
                        quote: quote,
                        onRemove: () => _removeFromFavorites(quote),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pageTitle(TextTheme textTheme) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Text(
        'Favorites',
        textAlign: TextAlign.center,
        style: textTheme.headlineSmall?.copyWith(
          fontFamily: "Inter",
          fontWeight: FontWeight.bold,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[400]
              : Colors.grey[600],
        ),
      ),
    );
  }

  Widget _emptyState(
      BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border_rounded,
              size: 64,
              color: colorScheme.onSurface.withOpacity(0.5),
            ),
            SizedBox(height: 16.h),
            Text(
              'No favorite quotes yet ❤️\nStart saving the ones you love!',
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge?.copyWith(
                fontFamily: "Inter",
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _errorState(
      BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: colorScheme.error,
            ),
            SizedBox(height: 16.h),
            Text(
              'Failed to load favorites 😕',
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge?.copyWith(
                fontFamily: "Inter",
                color: colorScheme.error,
              ),
            ),
            SizedBox(height: 24.h),
            OutlinedButton.icon(
              onPressed: _loadFavorites,
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
}
