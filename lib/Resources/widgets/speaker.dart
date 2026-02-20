import 'package:flutter/material.dart';
import 'package:attendee_app/Resources/widgets/resource_card.dart';
import 'package:attendee_app/Resources/widgets/section_header.dart';

class Speaker extends StatelessWidget {
  const Speaker({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
      children: const [
        SizedBox(height: 18),
        SectionHeader(title: 'speaker', count: 1),
        SizedBox(height: 10),
        ResourceCard(
          icon: Icons.image_outlined,
          iconColor: Color(0xFF9A58DC),
          title: 'Speaker resource 1',
          subtitle: 'Speaker resource 1',
          type: 'IMAGE',
          date: 'Feb 16, 2026',
          size: '497.3 KB',
          badgeText: 'FOR YOU',
        ),
        SizedBox(height: 18),
        SectionHeader(title: 'Session Materials', count: 1),
        SizedBox(height: 10),
        ResourceCard(
          icon: Icons.description_outlined,
          iconColor: Color(0xFFE35C5C),
          title: 'Session Material testing Doc',
          subtitle: 'Session Material testing Doc',
          type: 'PDF',
          date: 'Feb 16, 2026',
          size: '131.1 KB',
        ),
      ],
    );
  }
}
