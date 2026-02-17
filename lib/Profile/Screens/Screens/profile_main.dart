import 'package:attendee_app/Profile/Screens/Screens/profile.dart';
import 'package:attendee_app/Profile/provider/profile_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileMain extends StatelessWidget {
  const ProfileMain({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Profile_data()),
      ],
      child: ProfileView(),
    );
  }
}
