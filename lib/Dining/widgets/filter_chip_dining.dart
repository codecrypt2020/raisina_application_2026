import 'package:attendee_app/main.dart';
import 'package:flutter/material.dart';

class FilterChip_dining extends StatelessWidget {
  const FilterChip_dining({required this.label, this.selected = false});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final Color surfaceColor = AppColors.surfaceSoftOf(context);
    final Color borderColor = AppColors.elevatedOf(context);
    final Color textColor = AppColors.textSecondaryOf(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? AppColors.goldDim : surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: selected ? AppColors.gold : borderColor),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? AppColors.gold : textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
