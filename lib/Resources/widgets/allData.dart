// import 'dart:developer';

import 'package:attendee_app/Resources/provider/resources_data.dart';
import 'package:flutter/material.dart';

import 'package:attendee_app/Resources/widgets/resource_card.dart';
import 'package:attendee_app/Resources/widgets/section_header.dart';
import 'package:provider/provider.dart';

class Alldata extends StatelessWidget {
  const Alldata({
    super.key,
    required this.data,
  });
  final dynamic data;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ResourcesData>(context);
    return ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
        itemCount: data["data"].length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              const SizedBox(height: 18),
              SectionHeader(
                  title: provider
                      .getCategoryLabel(data["data"][index]['category_code']),
                  count: 1),
              const SizedBox(height: 10),
              ResourceCard(
                icon: Icons.image_outlined,
                iconColor: const Color(0xFF9A58DC),
                title: data["data"][index]['title'],
                subtitle: data["data"][index]['description'] ?? '',
                type: data["data"][index]['file_type'] ?? 'Unknown',
                date: provider.formatDate(data["data"][index]['created_at']),
                size: provider.formatFileSize(data["data"][index]['file_size']),
                badgeText: data["data"][index]['badgeText'],
              ),
            ],
          );
        });
  }
}
