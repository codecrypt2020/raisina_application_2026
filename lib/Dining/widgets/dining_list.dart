import 'package:attendee_app/Dining/Provider/dining_data.dart';
import 'package:attendee_app/Dining/widgets/dining_card.dart';
import 'package:attendee_app/Dining/widgets/filter_chip_dining.dart';
import 'package:attendee_app/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dining_list extends StatelessWidget {
  const Dining_list({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<dining_data>(context, listen: true);
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: provider.dining_list.length + 3, // header + chips + spacing
      itemBuilder: (context, index) {
        if (index == 0) {
          return const Text(
            'Dining',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          );
        }

        if (index == 1) {
          return const Padding(
            padding: EdgeInsets.only(top: 12),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilterChip_dining(label: 'Day 1 · Feb 12', selected: true),
                FilterChip_dining(label: 'Day 2 · Feb 13'),
                FilterChip_dining(label: 'Day 3 · Feb 14'),
                FilterChip_dining(label: 'Day 4 · Feb 15'),
              ],
            ),
          );
        }

        if (index == 2) {
          return const SizedBox(height: 20);
        }

        final item = provider.dining_list[index - 3];

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: DiningCard(
            time: item.time,
            title: item.title,
            location: item.location,
            speaker: item.speaker,
            highlight: item.highlight,
            tag: item.tag,
            tagColor: item.tagColor,
            isLive: item.isLive,
            time_range: item.time_range,
          ),
        );
      },
    );

    // return ListView(
    //   padding: const EdgeInsets.all(20),
    //   children: const [
    //     Text(
    //       'Dining',
    //       style: TextStyle(
    //           fontSize: 22,
    //           fontWeight: FontWeight.w700,
    //           color: AppColors.textPrimary),
    //     ),
    //     SizedBox(height: 12),
    //     Wrap(
    //       spacing: 8,
    //       runSpacing: 8,
    //       children: [
    //         FilterChip_dining(label: 'Day 1 · Feb 12', selected: true),
    //         FilterChip_dining(label: 'Day 2 · Feb 13'),
    //         FilterChip_dining(label: 'Day 3 · Feb 14'),
    //         FilterChip_dining(label: 'Day 4 · Feb 15'),
    //       ],
    //     ),
    //     SizedBox(height: 20),
    //     DiningCard(
    //       time: '08:00 AM',
    //       title: 'Speaker breakfast: Strategic foresight',
    //       location: 'Grand Atrium',
    //       speaker: 'Invite only',
    //       highlight: true,
    //       tag: "You're Speaking",
    //       tagColor: AppColors.gold,
    //     ),
    //     SizedBox(height: 12),
    //     DiningCard(
    //       time: '10:30 AM',
    //       title: 'Panel: Global South & climate finance',
    //       location: 'Forum Studio 1',
    //       speaker: 'Session · 60 mins',
    //       tag: 'Session',
    //       tagColor: AppColors.teal,
    //       isLive: true,
    //     ),
    //     SizedBox(height: 12),
    //     DiningCard(
    //       time: '01:00 PM',
    //       title: 'Closed-door: Maritime security',
    //       location: 'Raisina Room 3',
    //       speaker: 'Limited seats',
    //       tag: 'Closed-door',
    //       tagColor: AppColors.goldLight,
    //     ),
    //     SizedBox(height: 12),
    //     DiningCard(
    //       time: '03:30 PM',
    //       title: 'Fireside chat: The future of alliances',
    //       location: 'Summit Theatre',
    //       speaker: 'Session · 40 mins',
    //       tag: 'Session',
    //       tagColor: AppColors.teal,
    //     ),
    //   ],
    // );
  }
}
