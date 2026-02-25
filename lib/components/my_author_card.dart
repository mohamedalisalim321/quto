import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../models/quote.dart';

class MyAuthorCard extends StatelessWidget {
  final Quote quote;
  final VoidCallback onFavoriteToggle;

  const MyAuthorCard({
    super.key,
    required this.quote,
    required this.onFavoriteToggle,
  });

  String get _cleanQuote => quote.quote
      .replaceAll("â€™", "'")
      .replaceAll("â€¦", "")
      .replaceAll("“", "")
      .replaceAll("”", "");

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoSizeText(
              _cleanQuote,
              textAlign: TextAlign.left,
              textDirection: TextDirection.ltr,
              overflow: TextOverflow.visible,
              softWrap: true,
              maxLines: _cleanQuote.length > 200 ? 10 : 6,
              style: textTheme.bodyMedium?.copyWith(
                fontFamily: "Play",
                height: 1.5,
                fontWeight: FontWeight.normal,
                color: colors.onSurface,
              ),
            ),
            SizedBox(height: 12.h),
            IconButton(
              onPressed: onFavoriteToggle,
              icon: Icon(
                Icons.favorite,
                color: quote.isFavorite
                    ? Colors.redAccent
                    : colors.onSurfaceVariant,
              ),
            )
          ],
        ),
      ),
    );
  }
}
