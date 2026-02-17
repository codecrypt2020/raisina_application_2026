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
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 28,
            fontWeight: FontWeight.w800,
            fontFamily: 'serif',
          ),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Divider(
            color: AppColors.navySurface,
            thickness: 1,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          '$count files',
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
