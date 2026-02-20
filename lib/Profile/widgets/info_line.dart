import 'package:attendee_app/main.dart';
import 'package:flutter/material.dart';

class InfoLine extends StatelessWidget {
  const InfoLine({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.textMutedOf(context)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
                color: AppColors.textSecondaryOf(context), height: 1.3),
          ),
        ),
      ],
    );
  }
}
