// import 'dart:developer';

import 'package:attendee_app/Resources/provider/resources_data.dart';
import 'package:attendee_app/main.dart';
import 'package:flutter/material.dart';

import 'package:attendee_app/Resources/widgets/resource_card.dart';
import 'package:attendee_app/Resources/widgets/section_header.dart';
import 'package:provider/provider.dart';

class Alldata extends StatelessWidget {
  const Alldata({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ResourcesData>(context);
    final groupedData = provider.groupedSearchedAllData;

    if (groupedData.isEmpty) {
      return LayoutBuilder(
        builder: (context, constraints) => ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: constraints.maxHeight,
              child: Center(
                child: Text(
                  'No resources found',
                  style: TextStyle(
                    color: AppColors.textSecondaryOf(context),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Step 2: Build UI
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
      children: groupedData.entries.map((entry) {
        final categoryCode = entry.key;
        final items = entry.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 18),

            // Section Header (ONLY ONCE)
            SectionHeader(
              title: provider.getCategoryLabel(categoryCode),
              count: items.length,
            ),

            const SizedBox(height: 10),

            // Cards under this category
            ...items.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: ResourceCard(
                  icon: Icons.image_outlined,
                  iconColor: const Color(0xFF9A58DC),
                  title: item['title'],
                  subtitle: item['description'] ?? "",
                  type: item['file_type'] ?? 'Unknown',
                  date: provider.formatDate(item['created_at']),
                  size: provider.formatFileSize(item['file_size']),
                  file_url: item['file_url'],
                  showDownloadButton:
                      provider.check_download([item["is_download"]]),
                  badgeText: item['is_featured'] == 1 ? "FOR YOU" : null,
                ),
              );
            }).toList(),
          ],
        );
      }).toList(),
    );
  }
}
