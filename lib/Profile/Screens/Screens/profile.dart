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
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () async {
                final bool? shouldLogout = await showDialog<bool>(
                  context: context,
                  builder: (dialogContext) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: const Text('Logout'),
                      content: const Text(
                        'Are you sure you want to logout?',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext, false),
                          child: const Text('No'),
                        ),
                        FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.red,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(dialogContext, true),
                          child: const Text('Yes'),
                        ),
                      ],
                    );
                  },
                );

                if (shouldLogout == true) {
                  //deleting the locally stored token
                  Hive.box("LoginDetails").clear();
                  Navigator.pushAndRemoveUntil(
                    //pushAndRemoveUntil is used to clear the entire navigation stack so the user cannot return to previous screens after logging out.
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(
                          signUpUrl: Constants.registraionUrl),
                    ),
                    (route) => false,
                  );
                }
              },
              child: Ink(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.navyMid,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.navySurface),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.goldDim,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.logout_rounded,
                        color: AppColors.gold,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        "Logout",
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textMuted,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
