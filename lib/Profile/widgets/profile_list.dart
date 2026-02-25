import 'package:attendee_app/Profile/provider/profile_data.dart';
import 'package:attendee_app/Profile/widgets/details_table.dart';
import 'package:attendee_app/Profile/widgets/digital_badge_screen.dart';
import 'package:attendee_app/Profile/widgets/info_card.dart';
import 'package:attendee_app/Profile/widgets/info_line.dart';
import 'package:attendee_app/Profile/widgets/profile_row.dart';
import 'package:attendee_app/Profile/Screens/change_password_screen.dart';
import 'package:attendee_app/Profile/Screens/edit_profile_screen.dart';
import 'package:attendee_app/Profile/widgets/session_tile.dart';
import 'package:attendee_app/Profile/widgets/stat_card.dart';
import 'package:attendee_app/Profile/widgets/tag_chip.dart';
import 'package:attendee_app/constants.dart';
import 'package:attendee_app/login_screen.dart';
import 'package:attendee_app/main.dart';
import 'package:attendee_app/network_request.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class ProfileList extends StatelessWidget {
  const ProfileList({super.key});

  List<String> _parseExpertise(dynamic rawValue) {
    final String rawText = (rawValue ?? '').toString().trim();
    if (rawText.isEmpty || rawText.toLowerCase() == 'null') {
      return const [];
    }

    return rawText
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .map((item) => item.toUpperCase())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileData>(context, listen: true);
    final List<String> expertiseItems =
        _parseExpertise(provider.data['profile']['area_of_expertise']);
    const roleChipColor = Color(0xFF0C72A3);
    final Color secondaryTextColor = AppColors.textSecondaryOf(context);
    final Color deleteSurfaceColor = AppColors.surfaceOf(context);
    final Color deleteBorderColor = AppColors.borderOf(context);
    final Color deleteTitleColor = AppColors.textPrimaryOf(context);
    final Color deleteMutedColor = AppColors.textMutedOf(context);
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.gold,
              child: Text(
                "${provider.logo_short_name}",
                style: TextStyle(
                    color: AppColors.textPrimaryOf(context),
                    fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // "${Hive.box('LoginDetails').get("Profile_details")["name"] ?? ""}",
                  // "${Hive.box('LoginDetails').get("Profile_details")["name"] ?? ""}",
                  "${provider.data["profile"]["name"]}",
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimaryOf(context)),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: provider.data['profile']['designation'] ?? " ",
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
                        text: provider.data['profile']['organization'] ?? " ",
                        style: TextStyle(
                          color: AppColors.textSecondaryOf(context),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  softWrap: true,
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: roleChipColor, width: 1.4),
                  ),
                  child: Text(
                    (provider.userRole_name?.toString().trim().isNotEmpty ==
                                true
                            ? provider.userRole_name.toString()
                            : 'Speaker')
                        .toUpperCase(),
                    style: const TextStyle(
                      color: roleChipColor,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2.0,
                      fontSize: 10,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: roleChipColor, width: 1.4),
                  ),
                  child: Text(
                    "RD-${(provider.rd_number.toString()).toUpperCase()}",
                    style: const TextStyle(
                      color: roleChipColor,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2.0,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ))
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
                child: ProfileRow(
                  title: 'Digital badge',
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
                value: "${provider.data['sessions']?.length ?? 0}",
                label: 'SPEAKING SESSION',
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: StatCard(
                value: "${provider.totalUniqueDays}",
                label: 'CONFERENCE DAYS',
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: StatCard(
                value: (provider.data['profile']['dining_invites']
                            ?.toString()
                            .isNotEmpty ==
                        true)
                    ? provider.data['profile']['dining_invites'].toString()
                    : "0",
                label: 'DINING INVITES',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Provider.of<ProfileData>(context, listen: false)
        //     .buildProfileDetailsGrid(
        //   Provider.of<ProfileData>(context, listen: false).provider.data,
        // ),
        // Widget buildProfileDetailsGrid(Map provider.data) {

        LayoutBuilder(
          builder: (context, constraints) {
            final bool isWide = constraints.maxWidth > 860;
            final String email =
                "${provider.data['profile']["primary_email"] ?? "not available"}";
            final String phone =
                "${provider.data['profile']["country_code"] ?? ""} ${provider.data['profile']["primary_phone"] ?? "not available"}";
            //     "${provider.data['profile']["primary_phone"] ?? "not available"}";
            final String organization =
                "${provider.data['profile']["organization"] ?? "not available"}";
            final Widget leftColumn = Column(
              children: [
                InfoCard(
                  title: 'Biography',
                  child: Text(
                    '${provider.data['profile']['bio'] != "" ? provider.data['profile']['bio'] : "No biography provided."}',
                    style: TextStyle(
                        color: AppColors.textSecondaryOf(context), height: 1.4),
                  ),
                ),
                SizedBox(height: 12),
                InfoCard(
                  title: 'Speaking Sessions',
                  child: SessionTile(sessions: provider.data['sessions'] ?? []),
                ),
                SizedBox(height: 12),
                InfoCard(
                  title: 'Areas of Expertise',
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: expertiseItems.isEmpty
                        ? const [
                            TagChip(label: 'NOT SPECIFIED'),
                          ]
                        : expertiseItems
                            .map((item) => TagChip(label: item))
                            .toList(),
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
                      rdNumber:
                          "RD-${(provider.rd_number.toString()).toUpperCase()}",
                      status:
                          provider.data['profile']['status'] ?? "Not available",
                      dietaryPreference: provider.data['profile']
                              ['dietary_requirements'] ??
                          "Not available"),
                  //RD-qr_internal_id
                ),
                const SizedBox(height: 12),
                InfoCard(
                  title: 'Social Connect',
                  child: Text(
                    (() {
                      final twitter =
                          provider.data['profile']['social']?['twitter'];
                      return (twitter == null ||
                              twitter.toString().trim().isEmpty)
                          ? "No social links added."
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditProfileScreen(
                      profile: provider.data['profile'] ?? {},
                    ),
                  ),
                ).then((value) {
                  provider.fetchUserProfile(); //after profile edit call api
                });
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
                        Icons.edit_outlined,
                        color: AppColors.gold,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Edit Profile",
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
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChangePasswordScreen(
                      profile: provider.data['profile'] ?? {},
                    ),
                  ),
                );
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
                        Icons.lock_outline_rounded,
                        color: AppColors.gold,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Change Password",
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
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () async {
                final Map profileDetails =
                    Hive.box("LoginDetails").get("Profile_details");
                final String registeredEmail =
                    profileDetails["email"].toString().trim();
                String emailError = "";
                String enteredEmail = "";

                final bool? shouldDelete = await showDialog<bool>(
                  context: context,
                  builder: (dialogContext) {
                    return StatefulBuilder(
                      builder: (context, setDialogState) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          title: const Text('Delete Account'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Are you sure you want to delete account?',
                                style: TextStyle(
                                  color: secondaryTextColor,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'To confirm, please enter your Email ID: $registeredEmail',
                                style: TextStyle(
                                  color: secondaryTextColor,
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                keyboardType: TextInputType.emailAddress,
                                onChanged: (value) {
                                  enteredEmail = value.trim();
                                  if (emailError.isNotEmpty) {
                                    setDialogState(() {
                                      emailError = "";
                                    });
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: 'Enter Email ID',
                                  errorText:
                                      emailError.isEmpty ? null : emailError,
                                  border: const OutlineInputBorder(),
                                  isDense: true,
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(dialogContext, false),
                              child: const Text('Cancel'),
                            ),
                            FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.red,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                if (enteredEmail.trim() == "") {
                                  setDialogState(() {
                                    emailError = "Please enter Email ID";
                                  });
                                  return;
                                }
                                if (enteredEmail.toLowerCase() !=
                                    registeredEmail.toLowerCase()) {
                                  setDialogState(() {
                                    emailError =
                                        "Email ID entered doesn't match.";
                                  });
                                  return;
                                }
                                Navigator.pop(dialogContext, true);
                              },
                              child: const Text('Delete'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );

                if (shouldDelete == true) {
                  final deleteResponse = await Network_request.deleteAccount(
                    profileDetails["userId"],
                    registeredEmail,
                  );
                  if (!context.mounted) return;

                  if (deleteResponse["success"] == true) {
                    Hive.box("LoginDetails").clear();
                    Hive.box(AttendeeApp.settingsBoxName)
                        .put(AttendeeApp.themeModeKey, 'light');
                    AttendeeApp.setThemeMode(context, ThemeMode.light);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(
                          signUpUrl: Constants.registraionUrl,
                          forgetPasswordUrl: '',
                        ),
                      ),
                      (route) => false,
                    );
                  } else {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          deleteResponse["message"] ??
                              "Failed to delete account",
                        ),
                      ),
                    );
                  }
                }
              },
              child: Ink(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: deleteSurfaceColor,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: deleteBorderColor),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.red.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.delete_forever_rounded,
                        color: AppColors.red,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Delete Account",
                        style: TextStyle(
                          color: deleteTitleColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: deleteMutedColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
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
                        style: TextStyle(color: secondaryTextColor),
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
                  Hive.box(AttendeeApp.settingsBoxName)
                      .put(AttendeeApp.themeModeKey, 'light');
                  AttendeeApp.setThemeMode(context, ThemeMode.light);
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
