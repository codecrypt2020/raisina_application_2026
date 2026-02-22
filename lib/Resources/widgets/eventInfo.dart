import 'package:attendee_app/Resources/provider/resources_data.dart';
import 'package:flutter/material.dart';
import 'package:attendee_app/Resources/widgets/resource_card.dart';
import 'package:attendee_app/Resources/widgets/section_header.dart';
import 'package:provider/provider.dart';

class Eventinfo extends StatelessWidget {
  const Eventinfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ResourcesData>(context);
    final filteredData = provider.eventInfoList;
    return ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
        itemCount: filteredData.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              const SizedBox(height: 18),
              SectionHeader(
                  title: provider
                      .getCategoryLabel(filteredData[index]['category_code']),
                  count: 1),
              const SizedBox(height: 10),
              ResourceCard(
                icon: Icons.image_outlined,
                iconColor: const Color(0xFF9A58DC),
                title: filteredData[index]['title'],
                subtitle: filteredData[index]['description'] ?? '',
                type: filteredData[index]['file_type'] ?? 'Unknown',
                date: provider.formatDate(filteredData[index]['created_at']),
                size: provider.formatFileSize(filteredData[index]['file_size']),
                badgeText: filteredData[index]['badgeText'],
              ),
            ],
          );
        });
  }
}
