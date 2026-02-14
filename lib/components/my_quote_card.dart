import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/quote.dart';
import '../pages/author_page.dart';

class MyQuoteCard extends StatelessWidget {
  final Quote quote;
  final VoidCallback onFavoriteToggle;

  const MyQuoteCard({
    super.key,
    required this.quote,
    required this.onFavoriteToggle,
  });

  String get _cleanQuote => quote.quote
      .replaceAll("â€™", "'")
      .replaceAll("“", "")
      .replaceAll("”", "");

  void _onAuthorTap(BuildContext context) {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AuthorPage(authorName: quote.author),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            _cleanQuote,
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr,
            overflow: TextOverflow.visible,
            maxLines: null,
            style: textTheme.titleLarge?.copyWith(
              fontFamily: "Play",
              height: 1.5,
              fontWeight: FontWeight.normal,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 16.h),
          TextButton(
            onPressed: () => _onAuthorTap(context),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              alignment: Alignment.centerLeft,
            ),
            child: Text(
              "- ${quote.author}",
              textAlign: TextAlign.left,
              textDirection: TextDirection.ltr,
              style: textTheme.bodyMedium?.copyWith(
                decoration: TextDecoration.underline,
                fontFamily: "Inter",
                fontWeight: FontWeight.w600,
                color: Colors.grey[400],
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: _cleanQuote));
                },
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, anim) =>
                      ScaleTransition(scale: anim, child: child),
                  child: Icon(
                    Icons.copy_rounded,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                splashRadius: 24,
              ),
              IconButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  onFavoriteToggle();
                },
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, anim) =>
                      ScaleTransition(scale: anim, child: child),
                  child: Icon(
                    quote.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border_rounded,
                    key: ValueKey(quote.isFavorite),
                    color: quote.isFavorite
                        ? colorScheme.error
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
                splashRadius: 24,
              ),
            ],
          )
        ],
      ),
    );
  }
}
