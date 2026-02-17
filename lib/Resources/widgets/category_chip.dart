import 'package:attendee_app/Resources/Model/resource_category_datatype.dart';
import 'package:attendee_app/main.dart';
import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({required this.item});

  final ResourceCategory item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: item.isSelected ? AppColors.goldDim : AppColors.navyElevated,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: item.isSelected ? AppColors.gold : AppColors.navySurface,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            item.label,
            style: TextStyle(
              color: item.isSelected ? AppColors.gold : AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.navySurface,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '${item.count}',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
