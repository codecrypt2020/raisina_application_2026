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
    final Map profileData =
        (Hive.box('LoginDetails').get("Profile_details") ?? {}) as Map;

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
                Text('Speaker · Strategic Track',
                    style:
                        TextStyle(color: AppColors.textSecondaryOf(context))),
              ],
            ),
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
        _buildStatsRow(),
        const SizedBox(height: 16),
        _buildProfileDetailsGrid(profileData),
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

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            value: '1',
            label: 'SPEAKING SESSIONS',
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            value: '1',
            label: 'CONFERENCE DAYS',
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            value: '1',
            label: 'DINING INVITES',
          ),
        ),
      ],
    );
  }

  Widget _buildProfileDetailsGrid(Map profileData) {
    final String email = "${profileData["email"] ?? "not available"}";
    final String phone =
        "${profileData["phone"] ?? profileData["mobile"] ?? "not available"}";
    final String organization =
        "${profileData["organization"] ?? profileData["org_name"] ?? "not available"}";

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWide = constraints.maxWidth > 860;

        final Widget leftColumn = Column(
          children: [
            _InfoCard(
              title: 'Biography',
              child: Text(
                'Short professional bio will appear here. You can replace this with API-driven profile summary.',
                style: TextStyle(
                    color: AppColors.textSecondaryOf(context), height: 1.4),
              ),
            ),
            SizedBox(height: 12),
            _InfoCard(
              title: 'Speaking Sessions',
              child: _SessionTile(),
            ),
            SizedBox(height: 12),
            _InfoCard(
              title: 'Areas of Expertise',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _TagChip(label: 'FLUTTER'),
                  _TagChip(label: 'PUBLIC POLICY'),
                ],
              ),
            ),
          ],
        );

        final Widget rightColumn = Column(
          children: [
            _InfoCard(
              title: 'Contact Information',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoLine(icon: Icons.email_outlined, text: 'Email: $email'),
                  const SizedBox(height: 8),
                  _InfoLine(icon: Icons.call_outlined, text: 'Phone: $phone'),
                  const SizedBox(height: 8),
                  _InfoLine(
                    icon: Icons.business_outlined,
                    text: 'Organization: $organization',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _InfoCard(
              title: 'Conference Details',
              child: const _DetailsTable(),
            ),
            const SizedBox(height: 12),
            _InfoCard(
              title: 'Social Connect',
              child: Text(
                'No social links added.',
                style: TextStyle(color: AppColors.textSecondaryOf(context)),
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
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.label,
  });

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderOf(context)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: AppColors.gold,
              fontWeight: FontWeight.w700,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: AppColors.textMutedOf(context),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderOf(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.gold,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _SessionTile extends StatelessWidget {
  const _SessionTile();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.elevatedOf(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderOf(context)),
      ),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Session title placeholder',
                  style: TextStyle(
                    color: AppColors.textPrimaryOf(context),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Feb 18, 2026 13:00 · Ajmeri Gate',
                  style: TextStyle(
                    color: AppColors.textSecondaryOf(context),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.goldDim,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Day 1',
              style: TextStyle(
                color: AppColors.gold,
                fontWeight: FontWeight.w700,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.textMutedOf(context)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
                color: AppColors.textSecondaryOf(context), height: 1.3),
          ),
        ),
      ],
    );
  }
}

class _DetailsTable extends StatelessWidget {
  const _DetailsTable();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _KeyValueRow(label: 'Badge ID', value: 'REF-38'),
        SizedBox(height: 10),
        _KeyValueRow(label: 'Registration', value: 'Confirmed'),
        SizedBox(height: 10),
        _KeyValueRow(label: 'Dietary Preference', value: 'Vegetarian'),
      ],
    );
  }
}

class _KeyValueRow extends StatelessWidget {
  const _KeyValueRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(color: AppColors.textMutedOf(context)),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: AppColors.textPrimaryOf(context),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.goldDim,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.goldLight.withOpacity(0.4)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.gold,
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
      ),
    );
  }
}
