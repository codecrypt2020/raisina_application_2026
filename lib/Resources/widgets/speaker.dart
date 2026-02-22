import 'package:attendee_app/Resources/provider/resources_data.dart';
import 'package:flutter/material.dart';
import 'package:attendee_app/Resources/widgets/resource_card.dart';
import 'package:attendee_app/Resources/widgets/section_header.dart';
import 'package:provider/provider.dart';

class Speaker extends StatelessWidget {
  const Speaker({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ResourcesData>(context);
    final filteredList = provider.speakerList;
    return ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
        itemCount: filteredList.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              const SizedBox(height: 18),
              SectionHeader(
                  title: provider
                      .getCategoryLabel(filteredList[index]['category_code']),
                  count: filteredList.length),
              const SizedBox(height: 10),
              ResourceCard(
                icon: Icons.image_outlined,
                iconColor: const Color(0xFF9A58DC),
                title: filteredList[index]['title'],
                subtitle: filteredList[index]['description'] ?? '',
                type: filteredList[index]['file_type'] ?? 'Unknown',
                date: provider.formatDate(filteredList[index]['created_at']),
                size: provider.formatFileSize(filteredList[index]['file_size']),
                badgeText: filteredList[index]['badgeText'],
              ),
            ],
          );
        });
  }
}
