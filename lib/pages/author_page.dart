import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../components/my_author_card.dart';
import '../databases/quotes_database.dart';
import '../models/quote.dart';

class AuthorPage extends StatefulWidget {
  final String authorName;

  const AuthorPage({
    super.key,
    required this.authorName,
  });

  @override
  State<AuthorPage> createState() => _AuthorPageState();
}

class _AuthorPageState extends State<AuthorPage> {
  late final Future<List<Quote>> _quotesFuture;

  @override
  void initState() {
    super.initState();
    _quotesFuture = QuotesDatabase.getAuthorQuotes(widget.authorName);
  }

  Future<void> _toggleFavorite(Quote quote) async {
    await QuotesDatabase.toggleFavorite(quote.id);

    if (!mounted) return;

    setState(() => quote.isFavorite = !quote.isFavorite);

    HapticFeedback.lightImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
        ),
        duration: const Duration(seconds: 1),
        content: Text(
          quote.isFavorite ? 'Added to favorites ❤️' : 'Removed from favorites',
          style: const TextStyle(fontFamily: "Inter"),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colors.surface,
        foregroundColor: colors.onSurface,
        surfaceTintColor: Colors.transparent,
        title: Text(
          widget.authorName,
          style: TextStyle(
            fontFamily: "Play",
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: FutureBuilder<List<Quote>>(
        future: _quotesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: colors.primary,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'No quotes from this author yet',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontFamily: "Inter"),
              ),
            );
          }

          final quotes = snapshot.data ?? [];

          if (quotes.isEmpty) {
            return Center(
              child: Text(
                'No quotes from this author yet',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontFamily: "Inter"),
              ),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.fromLTRB(
              16.w,
              12.h,
              16.w,
              24.h,
            ),
            itemCount: quotes.length,
            separatorBuilder: (_, __) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              return MyAuthorCard(
                quote: quotes[index],
                onFavoriteToggle: () => _toggleFavorite(quotes[index]),
              );
            },
          );
        },
      ),
    );
  }
}
