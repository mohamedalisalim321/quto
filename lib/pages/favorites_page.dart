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

class _FavoritesPageState extends State<FavoritesPage>
    with TickerProviderStateMixin {
  final List<Quote> _favorites = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final data = await QuotesDatabase.getFavoriteQuotes();
      if (!mounted) return;

      setState(() {
        _favorites
          ..clear()
          ..addAll(data);
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  Future<void> _removeFromFavorites(int index) async {
    final quote = _favorites[index];

    HapticFeedback.lightImpact();

    // Optimistic removal
    setState(() => _favorites.removeAt(index));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
        ),
        content: const Text(
          'Removed from favorites',
          style: TextStyle(fontFamily: "Inter"),
        ),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () async {
            await QuotesDatabase.toggleFavorite(quote.id);
            _loadFavorites();
          },
        ),
      ),
    );

    try {
      await QuotesDatabase.toggleFavorite(quote.id);
    } catch (_) {
      _loadFavorites();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          _header(textTheme),
          Expanded(
            child: RefreshIndicator.adaptive(
              onRefresh: _loadFavorites,
              child: _buildBody(colors, textTheme),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(TextTheme textTheme) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Favorites',
            style: textTheme.headlineSmall?.copyWith(
              fontFamily: "Inter",
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          SizedBox(width: 8.w),
          if (!_isLoading)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                color: Colors.red.withOpacity(.1),
              ),
              child: Text(
                _favorites.length.toString(),
                style: const TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget _buildBody(ColorScheme colors, TextTheme textTheme) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    if (_hasError) {
      return _errorState(colors, textTheme);
    }

    if (_favorites.isEmpty) {
      return _emptyState(colors, textTheme);
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: _favorites.length,
      itemBuilder: (_, index) {
        final quote = _favorites[index];

        return AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: 1,
          child: MyFavoriteCard(
            quote: quote,
            onRemove: () => _removeFromFavorites(index),
          ),
        );
      },
    );
  }

  Widget _emptyState(ColorScheme colors, TextTheme textTheme) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border_rounded,
              size: 70.sp,
              color: colors.onSurface.withOpacity(.4),
            ),
            SizedBox(height: 20.h),
            Text(
              "No favorites yet ❤️",
              style: textTheme.titleMedium?.copyWith(
                fontFamily: "Inter",
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              "Start saving quotes you love.",
              style: textTheme.bodyMedium?.copyWith(
                fontFamily: "Inter",
                color: colors.onSurface.withOpacity(.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _errorState(ColorScheme colors, TextTheme textTheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64.sp, color: colors.error),
          SizedBox(height: 16.h),
          Text(
            "Failed to load favorites",
            style: textTheme.bodyLarge?.copyWith(
              fontFamily: "Inter",
              color: colors.error,
            ),
          ),
          SizedBox(height: 20.h),
          OutlinedButton.icon(
            onPressed: _loadFavorites,
            icon: const Icon(Icons.refresh),
            label: const Text(
              "Retry",
              style: TextStyle(fontFamily: "Inter"),
            ),
          ),
        ],
      ),
    );
  }
}
