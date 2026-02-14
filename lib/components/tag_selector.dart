import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class TagSelector extends StatelessWidget {
  final List<String> tags;
  final List<String> selectedTags;
  final ValueChanged<String> onTagTap;

  const TagSelector({
    super.key,
    required this.tags,
    required this.selectedTags,
    required this.onTagTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        scrollDirection: Axis.horizontal,
        itemCount: tags.length,
        separatorBuilder: (_, __) => SizedBox(width: 6.w),
        itemBuilder: (context, index) {
          final tag = tags[index];
          final isSelected = selectedTags.contains(tag);

          return ChoiceChip(
            label: Text(tag, style: const TextStyle(fontFamily: "Inter")),
            selected: isSelected,
            onSelected: (_) => onTagTap(tag),
          );
        },
      ),
    );
  }
}
