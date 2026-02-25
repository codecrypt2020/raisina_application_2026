import 'package:attendee_app/Resources/Model/resource_category_datatype.dart';
import 'package:attendee_app/Resources/provider/resources_data.dart';
import 'package:attendee_app/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({required this.item, required this.index, this.onTap});
  final int index;
  final ResourceCategory item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ResourcesData>(context, listen: true);
    final Color surfaceColor = AppColors.surfaceSoftOf(context);
    final Color borderColor = AppColors.elevatedOf(context);
    final Color textColor = AppColors.textSecondaryOf(context);
    final Color counterBgColor = AppColors.elevatedOf(context);
    return GestureDetector(
      onTap: onTap ??
          () {
            provider.setSelectedCategoryIndex(index);
            print("Selected category index: $index");
          },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: index == provider.selectedCategoryIndex
              ? AppColors.goldDim
              : surfaceColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: index == provider.selectedCategoryIndex
                ? AppColors.gold
                : borderColor,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              item.label,
              style: TextStyle(
                color: index == provider.selectedCategoryIndex
                    ? AppColors.gold
                    : textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: counterBgColor,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '${provider.getCountByIndex(item.index)}',
                style: TextStyle(
                  color: textColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
