import 'package:attendee_app/SpeakingEngagement/Provider/speaking_engagement_data.dart';
import 'package:attendee_app/SpeakingEngagement/Widgets/filter_chip_speaking_engagement.dart';
import 'package:attendee_app/SpeakingEngagement/Widgets/speaking_engagement_card.dart';
import 'package:attendee_app/SpeakingEngagement/widgets/session_count.dart';
import 'package:attendee_app/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SpeakingEngagementList extends StatelessWidget {
  const SpeakingEngagementList({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SpeakingEngagementData>(context, listen: true);
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: provider.sessions_list.length + 2, // header + spacing
      itemBuilder: (context, index) {
        // Header
        if (index == 0) {
          return const Text(
            'Speaking Engagement',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          );
        }

        // Space after header
        // if (index == 1) {
        //   return const SizedBox(height: 20);
        // }

        //count banner to be added
        if (index == 1) {
          return SpeakingSessionsBanner(
            sessions: provider.session_count,
            days: provider.sessions_days, // to be changed by the backend team.
          );
        }

        final item = provider.sessions_list[index - 2];

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: SpeakingEngagementCard(
            date: item.date,
            title: item.title,
            location: item.location,
            speaker: item.speaker,
            time: item.time,
            tag: item.tag,
            tagColor: item.tagColor,
            highlight: item.highlight,
            isLive: item.isLive,
          ),
        );
      },
    );

    // ListView(
    //   padding: const EdgeInsets.all(20),
    //   children: const [
    //     Text(
    //       'Speaking Engagement',
    //       style: TextStyle(
    //           fontSize: 22,
    //           fontWeight: FontWeight.w700,
    //           color: AppColors.textPrimary),
    //     ),
    //     // SizedBox(height: 12),
    //     // Wrap(
    //     //   spacing: 8,
    //     //   runSpacing: 8,
    //     //   children: [
    //     //     FilterChipSpeakingEngagement(
    //     //         label: 'Day 1 · Feb 12', selected: true),
    //     //     FilterChipSpeakingEngagement(label: 'Day 2 · Feb 13'),
    //     //     FilterChipSpeakingEngagement(label: 'Day 3 · Feb 14'),
    //     //     FilterChipSpeakingEngagement(label: 'Day 4 · Feb 15'),
    //     //   ],
    //     // ),
    //     SizedBox(height: 20),
    //     SpeakingEngagementCard(
    //       time: '08:00 AM',
    //       title: 'Speaker breakfast: Strategic foresight',
    //       location: 'Grand Atrium',
    //       speaker: 'Invite only',
    //       highlight: true,
    //       tag: "You're Speaking",
    //       tagColor: AppColors.gold,
    //     ),
    //     SizedBox(height: 12),
    //     SpeakingEngagementCard(
    //       time: '10:30 AM',
    //       title: 'Panel: Global South & climate finance',
    //       location: 'Forum Studio 1',
    //       speaker: 'Session · 60 mins',
    //       tag: 'Session',
    //       tagColor: AppColors.teal,
    //       isLive: true,
    //     ),
    //     SizedBox(height: 12),
    //     SpeakingEngagementCard(
    //       time: '01:00 PM',
    //       title: 'Closed-door: Maritime security',
    //       location: 'Raisina Room 3',
    //       speaker: 'Limited seats',
    //       tag: 'Closed-door',
    //       tagColor: AppColors.goldLight,
    //     ),
    //     SizedBox(height: 12),
    //     SpeakingEngagementCard(
    //       time: '03:30 PM',
    //       title: 'Fireside chat: The future of alliances',
    //       location: 'Summit Theatre',
    //       speaker: 'Session · 40 mins',
    //       tag: 'Session',
    //       tagColor: AppColors.teal,
    //     ),
    //   ],
    // );
    ;
  }
}
