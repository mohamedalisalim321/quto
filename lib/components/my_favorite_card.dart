import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../models/quote.dart';
import '../pages/author_page.dart';

class MyFavoriteCard extends StatelessWidget {
  final Quote quote;
  final VoidCallback onRemove;

  const MyFavoriteCard({
    super.key,
    required this.quote,
    required this.onRemove,
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
              maxLines: _cleanQuote.length > 200 ? 4 : 6,
              style: textTheme.bodyMedium?.copyWith(
                fontFamily: "Play",
                fontSize: 15.sp,
                height: 1.5,
                fontWeight: FontWeight.normal,
                color: colors.onSurface,
              ),
            ),
            //  Text(
            //      _cleanQuote,
            //      style: TextStyle(
            //        fontFamily: "Play",
            //         fontSize: 15.sp,
            //         height: 1.5,
            //         color: colors.onSurface,
            //  ),
            //     ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: Text(
                    "- ${quote.author}",
                    textAlign: TextAlign.left,
                    textDirection: TextDirection.ltr,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AuthorPage(authorName: quote.author),
                      ),
                    );
                  },
                ),
                IconButton(
                  onPressed: onRemove,
                  icon: Icon(
                    Icons.favorite,
                    color: quote.isFavorite
                        ? Colors.redAccent
                        : colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
