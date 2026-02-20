import 'package:attendee_app/Profile/provider/profile_data.dart';
import 'package:attendee_app/Profile/widgets/details_table.dart';
import 'package:attendee_app/Profile/widgets/digital_badge_screen.dart';
import 'package:attendee_app/Profile/widgets/info_card.dart';
import 'package:attendee_app/Profile/widgets/info_line.dart';
import 'package:attendee_app/Profile/widgets/profile_row.dart';
import 'package:attendee_app/Profile/widgets/session_tile.dart';
import 'package:attendee_app/Profile/widgets/stat_card.dart';
import 'package:attendee_app/Profile/widgets/tag_chip.dart';
import 'package:attendee_app/constants.dart';
import 'package:attendee_app/login_screen.dart';
import 'package:attendee_app/main.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class ProfileList extends StatelessWidget {
  const ProfileList({super.key});

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<ProfileData>(context, listen: true).data;
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
                    color: AppColors.textPrimaryOf(context),
                    fontWeight: FontWeight.w700),
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
                      color: AppColors.textPrimaryOf(context)),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: data['profile']['designation'] ?? " ",
                            style: TextStyle(
                              color: AppColors.textSecondaryOf(context),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: ' · ',
                            style: TextStyle(
                              color: AppColors.textSecondaryOf(context),
                            ),
                          ),
                          TextSpan(
                            text: data['profile']['organization'] ?? " ",
                            style: TextStyle(
                              color: AppColors.textSecondaryOf(context),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.surfaceOf(context),
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
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: StatCard(
                value: "${data['sessions']?.length ?? 0}",
                label: 'SPEAKING SESSIONS',
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: StatCard(
                value: '1',
                label: 'CONFERENCE DAYS',
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: StatCard(
                value:
                    (data['profile']['dining_invites']?.toString().isNotEmpty ==
                            true)
                        ? data['profile']['dining_invites'].toString()
                        : "0",
                label: 'DINING INVITES',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Provider.of<ProfileData>(context, listen: false)
        //     .buildProfileDetailsGrid(
        //   Provider.of<ProfileData>(context, listen: false).data,
        // ),
        // Widget buildProfileDetailsGrid(Map data) {

        LayoutBuilder(
          builder: (context, constraints) {
            final bool isWide = constraints.maxWidth > 860;
            final String email =
                "${data['profile']["primary_email"] ?? "not available"}";
            final String phone =
                "${data['profile']["primary_phone"] ?? "not available"}";
            final String organization =
                "${data['profile']["organization"] ?? "not available"}";
            final Widget leftColumn = Column(
              children: [
                InfoCard(
                  title: 'Biography',
                  child: Text(
                    '${data['profile']['bio'] ?? "No biography available."}',
                    style: TextStyle(
                        color: AppColors.textSecondaryOf(context), height: 1.4),
                  ),
                ),
                SizedBox(height: 12),
                InfoCard(
                  title: 'Speaking Sessions',
                  child: SessionTile(sessions: data['sessions'] ?? []),
                ),
                SizedBox(height: 12),
                InfoCard(
                  title: 'Areas of Expertise',
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      TagChip(
                          label: data['profile']['area_of_expertise'] ??
                              "Not specified"),
                    ],
                  ),
                ),
              ],
            );

            final Widget rightColumn = Column(
              children: [
                InfoCard(
                  title: 'Contact Information',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InfoLine(
                          icon: Icons.email_outlined, text: 'Email: $email'),
                      const SizedBox(height: 8),
                      InfoLine(
                          icon: Icons.call_outlined, text: 'Phone: $phone'),
                      const SizedBox(height: 8),
                      InfoLine(
                        icon: Icons.business_outlined,
                        text: 'Organization: $organization',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                InfoCard(
                  title: 'Conference Details',
                  child: DetailsTable(
                      status: data['profile']['status'] ?? "Not available",
                      dietaryPreference: data['profile']
                              ['dietary_requirements'] ??
                          "Not available"),
                ),
                const SizedBox(height: 12),
                InfoCard(
                  title: 'Social Connect',
                  child: Text(
                    (() {
                      final twitter = data['profile']['social']?['twitter'];
                      return (twitter == null ||
                              twitter.toString().trim().isEmpty)
                          ? "Not available"
                          : twitter;
                    })(),
                    style: TextStyle(
                      color: AppColors.textSecondaryOf(context),
                    ),
                  ),
                ),
              ],
            );

            if (isWide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 6, child: leftColumn),
                  const SizedBox(width: 12),
                  Expanded(flex: 4, child: rightColumn),
                ],
              );
            }

            return Column(
              children: [
                leftColumn,
                const SizedBox(height: 12),
                rightColumn,
              ],
            );
          },
        ),
        // }
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
                      content: Text(
                        'Are you sure you want to logout?',
                        style: TextStyle(
                            color: AppColors.textSecondaryOf(context)),
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
                          signUpUrl: Constants.registraionUrl,
                          forgetPasswordUrl: Constants.forgetPassUrl),
                    ),
                    (route) => false,
                  );
                }
              },
              child: Ink(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceOf(context),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.borderOf(context)),
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
                    Expanded(
                      child: Text(
                        "Logout",
                        style: TextStyle(
                          color: AppColors.textPrimaryOf(context),
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textMutedOf(context),
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
