import 'package:attendee_app/SpeakingEngagement/Provider/speaking_engagement_data.dart';
import 'package:attendee_app/SpeakingEngagement/Widgets/speaking_engagement_list.dart';
import 'package:attendee_app/SpeakingEngagement/widgets/filter_chip_speaking_engagement.dart';
import 'package:attendee_app/SpeakingEngagement/widgets/speaking_engagement_card.dart';
import 'package:attendee_app/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SpeakingEngagement extends StatefulWidget {
  const SpeakingEngagement({super.key});

  @override
  State<SpeakingEngagement> createState() => _SpeakingEngagementState();
}

class _SpeakingEngagementState extends State<SpeakingEngagement> {
  late Future _speakingFuture;

  @override
  void initState() {
    super.initState();
    final provider =
        Provider.of<SpeakingEngagementData>(context, listen: false);
    _speakingFuture = provider.SpeakingDetails();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      //putting the materail call in the api for first time loading

      future: _speakingFuture,
      builder: (ctx, dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (dataSnapshot.error != null) {
          {
            //do error handling
            return Center(
              child: SingleChildScrollView(child: Text("An error occured")),
            );
          }
        } else {
          return SpeakingEngagementList();
        }
      },
    );
  }
}
