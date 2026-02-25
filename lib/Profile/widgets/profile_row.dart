import 'package:attendee_app/main.dart';
import 'package:flutter/material.dart';

class ProfileRow extends StatelessWidget {
  const ProfileRow({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final Color titleColor = AppColors.textPrimaryOf(context);
    final Color subtitleColor = AppColors.textSecondaryOf(context);
    final Color trailingColor = AppColors.textMutedOf(context);

    return Row(
      children: [
        CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
          child: Icon(icon, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                    TextStyle(fontWeight: FontWeight.w700, color: titleColor),
              ),
              const SizedBox(height: 4),
              Text(subtitle, style: TextStyle(color: subtitleColor)),
            ],
          ),
        ),
        Icon(Icons.chevron_right, color: trailingColor),
      ],
    );
  }
}
