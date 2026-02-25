// import 'package:attendee_app/Profile/Screens/Screens/profile.dart';
import 'package:attendee_app/Profile/widgets/profile_list.dart';
// import 'package:attendee_app/Profile/widgets/profile_row.dart';
// import 'package:attendee_app/Profile/widgets/digital_badge_screen.dart';
import 'package:attendee_app/Profile/provider/profile_data.dart';
// import 'package:attendee_app/constants.dart';
// import 'package:attendee_app/login_screen.dart';
// import 'package:attendee_app/main.dart';
import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Provider.of<ProfileData>(context, listen: false).fetchUserProfile();
    // });
  }

  @override
  Widget build(BuildContext context) {
    final fetch_data =
        Provider.of<ProfileData>(context, listen: false).fetchUserProfile();
    return FutureBuilder(
      //putting the materail call in the api for first time loading

      future: fetch_data,
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
          return ProfileList();
        }
      },
    );
  }
}
