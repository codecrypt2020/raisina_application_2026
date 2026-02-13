import 'package:attendee_app/SpeakingEngagement/widgets/filter_chip_speaking_engagement.dart';
import 'package:attendee_app/SpeakingEngagement/widgets/speaking_engagement_card.dart';
import 'package:attendee_app/main.dart';
import 'package:flutter/material.dart';

class SpeakingEngagement extends StatelessWidget {
  const SpeakingEngagement({super.key});
 
  @override
  Widget build(BuildContext context) {
      return ListView(
      padding: const EdgeInsets.all(20),
      children: const [
        Text(
          'Speaking Engagement',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        ),
        SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilterChipSpeakingEngagement(label: 'Day 1 · Feb 12', selected: true),
            FilterChipSpeakingEngagement(label: 'Day 2 · Feb 13'),
            FilterChipSpeakingEngagement(label: 'Day 3 · Feb 14'),
            FilterChipSpeakingEngagement(label: 'Day 4 · Feb 15'),
          ],
        ),
        SizedBox(height: 20),
        SpeakingEngagementCard(
          time: '08:00 AM',
          title: 'Speaker breakfast: Strategic foresight',
          location: 'Grand Atrium',
          speaker: 'Invite only',
          highlight: true,
          tag: "You're Speaking",
          tagColor: AppColors.gold,
        ),
        SizedBox(height: 12),
        SpeakingEngagementCard(
          time: '10:30 AM',
          title: 'Panel: Global South & climate finance',
          location: 'Forum Studio 1',
          speaker: 'Session · 60 mins',
          tag: 'Session',
          tagColor: AppColors.teal,
          isLive: true,
        ),
        SizedBox(height: 12),
        SpeakingEngagementCard(
          time: '01:00 PM',
          title: 'Closed-door: Maritime security',
          location: 'Raisina Room 3',
          speaker: 'Limited seats',
          tag: 'Closed-door',
          tagColor: AppColors.goldLight,
        ),
        SizedBox(height: 12),
        SpeakingEngagementCard(
          time: '03:30 PM',
          title: 'Fireside chat: The future of alliances',
          location: 'Summit Theatre',
          speaker: 'Session · 40 mins',
          tag: 'Session',
          tagColor: AppColors.teal,
        ),
      ],
    );
  }
}