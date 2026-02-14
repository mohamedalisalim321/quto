import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      .replaceAll("“", "")
      .replaceAll("”", "");

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: colors.surface,
      elevation: 1,
      borderRadius: BorderRadius.circular(14.r),
      child: Padding(
        padding: EdgeInsets.all(16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _cleanQuote,
              style: TextStyle(
                fontFamily: "Play",
                fontSize: 15.sp,
                height: 1.5,
                color: colors.onSurface,
              ),
            ),
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
                          decoration: TextDecoration.underline,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[400],
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
                  icon: const Icon(
                    Icons.favorite,
                    color: Colors.redAccent,
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
