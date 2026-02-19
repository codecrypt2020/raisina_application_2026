import 'package:attendee_app/Resources/Model/resource_category_datatype.dart';
import 'package:attendee_app/Resources/widgets/category_chip.dart';
import 'package:attendee_app/Resources/widgets/resource_card.dart';
import 'package:attendee_app/Resources/widgets/section_header.dart';
import 'package:attendee_app/main.dart';
import 'package:flutter/material.dart';

class Resources_view extends StatelessWidget {
  const Resources_view({
    super.key,
    required this.categories,
  });

  final List<ResourceCategory> categories;

  @override
  Widget build(BuildContext context) {
    final bool isDark = AppColors.isDark(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? const [
                  Color(0xFF0C1220),
                  Color(0xFF10192B),
                ]
              : const [
                  Color(0xFFF8FAFD),
                  Color(0xFFF2F6FC),
                ],
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
        children: [
          Container(
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.elevatedOf(context),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.borderOf(context)),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search resources...',
                hintStyle: TextStyle(color: AppColors.textMutedOf(context)),
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColors.textMutedOf(context),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories
                  .map((item) => Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: CategoryChip(item: item),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 18),
          const SectionHeader(title: 'Speaker Kit', count: 1),
          const SizedBox(height: 10),
          const ResourceCard(
            icon: Icons.image_outlined,
            iconColor: Color(0xFF9A58DC),
            title: 'Speaker resource 1',
            subtitle: 'Speaker resource 1',
            type: 'IMAGE',
            date: 'Feb 16, 2026',
            size: '497.3 KB',
            badgeText: 'FOR YOU',
          ),
          const SizedBox(height: 18),
          const SectionHeader(title: 'Session Materials', count: 1),
          const SizedBox(height: 10),
          const ResourceCard(
            icon: Icons.description_outlined,
            iconColor: Color(0xFFE35C5C),
            title: 'Session Material testing Doc',
            subtitle: 'Session Material testing Doc',
            type: 'PDF',
            date: 'Feb 16, 2026',
            size: '131.1 KB',
          ),
        ],
      ),
    );
  }
}
