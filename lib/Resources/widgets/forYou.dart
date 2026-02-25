import 'package:attendee_app/Resources/provider/resources_data.dart';
import 'package:attendee_app/main.dart';
import 'package:flutter/material.dart';
import 'package:attendee_app/Resources/widgets/resource_card.dart';
import 'package:attendee_app/Resources/widgets/section_header.dart';
import 'package:provider/provider.dart';

class ForYou extends StatelessWidget {
  const ForYou({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ResourcesData>(context);
    // final filteredData = provider.featuredList;
    final groupedData = provider.groupedFeaturedData;

    if (groupedData.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 120),
          Center(
            child: Text(
              'No resources found',
              style: TextStyle(color: AppColors.textSecondaryOf(context)),
            ),
          ),
        ],
      );
    }
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
      children: groupedData.entries.map((entry) {
        final categoryCode = entry.key;
        final items = entry.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 18),
            SectionHeader(
              title: provider.getCategoryLabel(categoryCode),
              count: items.length,
            ),
            const SizedBox(height: 10),
            ...items.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: ResourceCard(
                  icon: Icons.image_outlined,
                  iconColor: const Color(0xFF9A58DC),
                  title: item['title'],
                  subtitle: item['description'],
                  type: item['file_type'],
                  date: provider.formatDate(item['created_at']),
                  size: provider.formatFileSize(item['file_size']),
                  file_url: item['file_url'],
                  badgeText: item['is_featured'] == 1 ? "FOR YOU" : null,
                ),
              );
            }).toList(),
          ],
        );
      }).toList(),
    );
    //   return Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       const SizedBox(height: 18),

    //       // Header only once
    //       Padding(
    //         padding: const EdgeInsets.symmetric(horizontal: 16),
    //         child: SectionHeader(
    //           title: 'For You',
    //           count: filteredData.length,
    //         ),
    //       ),

    //       const SizedBox(height: 10),

    //       // Cards
    //       Expanded(
    //         child: ListView.builder(
    //           padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
    //           itemCount: filteredData.length,
    //           itemBuilder: (context, index) {
    //             final item = filteredData[index];

    //             return Padding(
    //               padding: const EdgeInsets.only(bottom: 18),
    //               child: ResourceCard(
    //                 icon: Icons.image_outlined,
    //                 iconColor: const Color(0xFF9A58DC),
    //                 title: item['title'],
    //                 subtitle: item['description'],
    //                 type: item['file_type'] ?? 'Unknown',
    //                 date: provider.formatDate(item['created_at']),
    //                 size: provider.formatFileSize(item['file_size']),
    //                 badgeText: item['badgeText'],
    //               ),
    //             );
    //           },
    //         ),
    //       ),
    //     ],
    //   );
  }
}
