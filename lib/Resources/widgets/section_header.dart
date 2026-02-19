import 'package:attendee_app/main.dart';
import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({required this.title, required this.count});

  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColors.textPrimaryOf(context),
            fontSize: 28,
            fontWeight: FontWeight.w800,
            fontFamily: 'serif',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Divider(
            color: AppColors.borderOf(context),
            thickness: 1,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          '$count files',
          style: TextStyle(
            color: AppColors.textMutedOf(context),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
