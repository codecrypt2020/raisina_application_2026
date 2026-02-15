import 'package:attendee_app/SpeakingEngagement/Provider/speaking_engagement_data.dart';
import 'package:attendee_app/SpeakingEngagement/Screens/speaking_engagement.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SpeakingMain extends StatelessWidget {
  const SpeakingMain({super.key});

  @override
  Widget build(BuildContext context) {
    return SpeakingEngagement();
  }
}
