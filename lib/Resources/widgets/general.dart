import 'package:attendee_app/Resources/provider/resources_data.dart';
import 'package:attendee_app/Resources/widgets/resource_card.dart';
import 'package:attendee_app/Resources/widgets/section_header.dart';
import 'package:attendee_app/main.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class General extends StatelessWidget {
  General({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ResourcesData>(context);
    final filteredList = provider.searchedGeneralList;

    if (filteredList.isEmpty) {
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 18),

        // Header only once
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SectionHeader(
            title: provider.getCategoryLabel('general'),
            count: filteredList.length,
          ),
        ),

        const SizedBox(height: 10),

        // Cards list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              final item = filteredList[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: ResourceCard(
                  icon: Icons.image_outlined,
                  iconColor: const Color(0xFF9A58DC),
                  title: item['title'],
                  subtitle: item['description'],
                  type: item['file_type'] ?? 'Unknown',
                  date: provider.formatDate(item['created_at']),
                  size: provider.formatFileSize(item['file_size']),
                  file_url: item['file_url'],
                  showDownloadButton: item['is_download']?.toString() == '1',
                  badgeText: item['is_featured'] == 1 ? "FOR YOU" : null,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
