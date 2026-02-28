import 'package:attendee_app/main.dart';
import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    required this.count,
    this.titleFontSize = 18,
    this.titleFontWeight = FontWeight.w700,
    this.titleFontFamily,
  });

  final String title;
  final int count;
  final double titleFontSize;
  final FontWeight titleFontWeight;
  final String? titleFontFamily;

  @override
  Widget build(BuildContext context) {
    final Color titleColor = AppColors.textPrimaryOf(context);
    final Color dividerColor = AppColors.borderOf(context);
    final Color mutedColor = AppColors.textMutedOf(context);
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: titleColor,
            fontSize: titleFontSize,
            fontWeight: titleFontWeight,
            fontFamily: titleFontFamily,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Divider(
            color: dividerColor,
            thickness: 1,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          '$count files',
          style: TextStyle(
            color: mutedColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
