import 'package:attendee_app/main.dart';
import 'package:flutter/material.dart';

class FilterChipSpeakingEngagement extends StatelessWidget {
  const FilterChipSpeakingEngagement(
      {required this.label, this.selected = false});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? AppColors.goldDim : AppColors.surfaceSoftOf(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: selected ? AppColors.gold : AppColors.borderOf(context)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? AppColors.gold : AppColors.textSecondaryOf(context),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
