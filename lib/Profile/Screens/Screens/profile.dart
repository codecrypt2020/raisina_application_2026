import 'package:attendee_app/Profile/Screens/widgets/profile_row.dart';
import 'package:attendee_app/Profile/Screens/Screens/digital_badge_screen.dart';
import 'package:attendee_app/constants.dart';
import 'package:attendee_app/login_screen.dart';
import 'package:attendee_app/main.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.gold,
              child: Text(
                "${Hive.box('LoginDetails').get("Profile_details")["name"]?.substring(0, 2).toUpperCase() ?? "USER"}",
                style: TextStyle(
                    color: AppColors.textPrimary, fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${Hive.box('LoginDetails').get("Profile_details")["name"] ?? ""}",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary),
                ),
                SizedBox(height: 4),
                Text('Speaker · Strategic Track',
                    style: TextStyle(color: AppColors.textSecondary)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.navyMid,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DigitalBadgeScreen(),
                    ),
                  );
                },
                child: const ProfileRow(
                  title: 'Digital badge',
                  subtitle: 'Speaker pass · updated 5 mins ago',
                  icon: Icons.badge_outlined,
                  color: AppColors.gold,
                ),
              ),
              // Divider(color: AppColors.navySurface),
              // ProfileRow(
              //   title: 'Travel & logistics',
              //   subtitle: 'Hotel car confirmed at 7:30 AM',
              //   icon: Icons.flight_takeoff_outlined,
              //   color: AppColors.teal,
              // ),
              // Divider(color: AppColors.navySurface),
              // ProfileRow(
              //   title: 'Speaker kit',
              //   subtitle: 'Slides due in 2 days',
              //   icon: Icons.shield_outlined,
              //   color: AppColors.goldLight,
              // ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        // Container(
        //   padding: const EdgeInsets.all(18),
        //   decoration: BoxDecoration(
        //     color: AppColors.navySurface,
        //     borderRadius: BorderRadius.circular(20),
        //   ),
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       const Text(
        //         'Preparation checklist',
        //         style: TextStyle(
        //             fontSize: 16,
        //             fontWeight: FontWeight.w700,
        //             color: AppColors.textPrimary),
        //       ),
        //       const SizedBox(height: 8),
        //       const Text(
        //         'Upload slides · Confirm co-speakers · Rehearsal notes.',
        //         style: TextStyle(color: AppColors.textSecondary),
        //       ),
        //       const SizedBox(height: 12),
        //       FilledButton(
        //         onPressed: () {},
        //         style: FilledButton.styleFrom(
        //           backgroundColor: AppColors.gold,
        //           foregroundColor: Colors.white,
        //         ),
        //         child: const Text('Review checklist'),
        //       ),
        //     ],
        //   ),
        // ),
        const SizedBox(height: 30),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.red),
              foregroundColor: AppColors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () {
              //deleting the locally stored token
              Hive.box("LoginDetails").clear();
              Navigator.pushAndRemoveUntil(
                //pushAndRemoveUntil is used to clear the entire navigation stack so the user cannot return to previous screens after logging out.
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const LoginScreen(signUpUrl: Constants.registraionUrlDev),
                ),
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
            label: const Text(
              "Logout",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}
