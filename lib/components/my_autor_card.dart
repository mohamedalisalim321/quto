import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/quote.dart';

class MyAutorCard extends StatelessWidget {
  final Quote quote;
  final VoidCallback onFavoriteToggle;

  const MyAutorCard({
    super.key,
    required this.quote,
    required this.onFavoriteToggle,
  });

  String get _cleanQuote => quote.quote.replaceAll("â€™", "'");

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(14.r),
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(14.r),
        onLongPress: onFavoriteToggle,
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
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: onFavoriteToggle,
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Icon(
                      quote.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border_rounded,
                      key: ValueKey(quote.isFavorite),
                      color: quote.isFavorite
                          ? Colors.redAccent
                          : colors.onSurface.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
