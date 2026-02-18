import 'package:attendee_app/Agenda/Provider/agenda_data.dart';
import 'dart:io';
import 'package:attendee_app/Agenda/Screens/agendaMain.dart';
import 'package:attendee_app/Dining/Screens/dining.dart';
import 'package:attendee_app/Profile/Screens/Screens/profile.dart';
import 'package:attendee_app/Resources/Screens/resourcesMain.dart';
import 'package:attendee_app/SpeakingEngagement/Provider/speaking_engagement_data.dart';
import 'package:attendee_app/SpeakingEngagement/Screens/speaking_engagement_main.dart';
import 'package:attendee_app/Maps/Screens/mapMain.dart';
import 'package:attendee_app/constants.dart';
import 'package:attendee_app/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'Dining/Provider/dining_data.dart';
import 'Dining/Screens/dining_main.dart';

class AppColors {
  static const navy = Color(0xFFFFFFFF);
  static const navyMid = Color(0xFFF6F8FC);
  static const navySurface = Color(0xFFEEF2F8);
  static const navyElevated = Color(0xFFFFFFFF);
  static const gold = Color(0xFF0C72A3);
  static const goldLight = Color(0xFF4CA0C7);
  static const goldDim = Color(0x1A0C72A3);
  static const teal = Color(0xFF0C72A3);
  static const textPrimary = Color(0xFF0A0E1A);
  static const textSecondary = Color(0xFF4E5873);
  static const textMuted = Color(0xFF7A85A0);
  static const red = Color(0xFFE05555);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(directory.path);
  await Hive.openBox('LoginDetails');
  runApp(const AttendeeApp());
}

class AttendeeApp extends StatelessWidget {
  const AttendeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    var token = Hive.box('LoginDetails').get("token");
    print('this is the token${token}');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Summit Attendee',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.gold,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: AppColors.navy,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.navyMid,
          foregroundColor: AppColors.textPrimary,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
        navigationBarTheme: const NavigationBarThemeData(
          backgroundColor: AppColors.navyMid,
          indicatorColor: AppColors.goldDim,
          labelTextStyle: WidgetStatePropertyAll(
            TextStyle(
                color: AppColors.textSecondary, fontWeight: FontWeight.w600),
          ),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontWeight: FontWeight.w700),
          titleMedium: TextStyle(fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(height: 1.4),
        ),
      ),
      home: (token != null)
          ? const AttendeeHomePage()
          : const LoginScreen(signUpUrl: Constants.registraionUrl),
    );
  }
}

class AttendeeHomePage extends StatefulWidget {
  const AttendeeHomePage({super.key});

  @override
  State<AttendeeHomePage> createState() => _AttendeeHomePageState();
}

class _AttendeeHomePageState extends State<AttendeeHomePage> {
  int _selectedIndex = 0;

  void _openPanelPage(Widget page) {
    Navigator.of(context).pop();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  final List<Widget> _pages = [
    // HomeDashboard(),
    AgendaMain(),
    DiningMain(),
    SpeakingMain(),
    // NetworkingView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => dining_data()),
        //define multiple providers
        ///agenda

        ///speaking engagement
        ChangeNotifierProvider(create: (ctx) => SpeakingEngagementData()),

        ChangeNotifierProvider(create: (ctx) => Agenda_data()),

        ///speaking engagement
      ],
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 72,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('Welcome, ',
                      style: TextStyle(
                          fontSize: 13, color: AppColors.textSecondary)),
                  Text(
                      "${Hive.box('LoginDetails').get("Profile_details")["name"] ?? ""}",
                      style: TextStyle(
                          fontSize: 13, color: AppColors.textSecondary)),
                ],
              ),
              SizedBox(height: 4),
              Text('Raisina Dialogue',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            ],
          ),
          actions: [
            // IconButton(
            //   onPressed: () {},
            //   icon: const Icon(Icons.search, color: AppColors.textPrimary),
            // ),
            // IconButton(
            //   onPressed: () {},
            //   icon: const Icon(Icons.notifications_outlined,
            //       color: AppColors.textPrimary),
            // ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.navySurface,
                child: Text(
                    "${Hive.box('LoginDetails').get("Profile_details")["name"]?.substring(0, 2).toUpperCase() ?? "USER"}",
                    style: TextStyle(color: AppColors.textPrimary)),
              ),
            ),
          ],
        ),
        // drawer: Drawer(
        //   backgroundColor: AppColors.navyElevated,
        //   child: SafeArea(
        //     child: ListView(
        //       padding: EdgeInsets.zero,
        //       children: [
        //         Container(
        //           padding: const EdgeInsets.fromLTRB(16, 20, 16, 14),
        //           color: AppColors.navyMid,
        //           child: const Text(
        //             'Quick Access',
        //             style: TextStyle(
        //               fontSize: 18,
        //               fontWeight: FontWeight.w700,
        //               color: AppColors.textPrimary,
        //             ),
        //           ),
        //         ),
        //         ListTile(
        //           leading: const Icon(
        //             Icons.folder_outlined,
        //             color: AppColors.textPrimary,
        //           ),
        //           title: const Text(
        //             'Resources',
        //             style: TextStyle(color: AppColors.textPrimary),
        //           ),
        //           onTap: () => _openPanelPage(const ResourcesMain()),
        //         ),
        //         ListTile(
        //           leading: const Icon(
        //             Icons.map_outlined,
        //             color: AppColors.textPrimary,
        //           ),
        //           title: const Text(
        //             'Maps',
        //             style: TextStyle(color: AppColors.textPrimary),
        //           ),
        //           onTap: () => _openPanelPage(const Mapmain()),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        body: _pages[_selectedIndex],
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.event_note_outlined),
              label: 'Agenda',
            ),
            NavigationDestination(
              icon: Icon(Icons.wine_bar_outlined),
              label: 'Dining',
            ),
            NavigationDestination(
              icon: Icon(Icons.school_outlined),
              label: 'Speaking Eng',
            ),
            NavigationDestination(
                icon: Icon(Icons.person_outline), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

// class HomeDashboard extends StatelessWidget {
//   const HomeDashboard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       padding: const EdgeInsets.all(20),
//       children: [
//         const _EventHeroCard(),
//         const SizedBox(height: 24),
//         const Text(
//           'Quick actions',
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
//         ),
//         const SizedBox(height: 12),
//         LayoutBuilder(
//           builder: (context, constraints) {
//             final cardWidth = (constraints.maxWidth - 12) / 2;
//             return Wrap(
//               spacing: 12,
//               runSpacing: 12,
//               children: [
//                 _ActionCard(
//                   icon: Icons.mic_none,
//                   title: 'Speaking',
//                   subtitle: 'Your sessions',
//                   color: AppColors.gold,
//                   width: cardWidth,
//                 ),
//                 _ActionCard(
//                   icon: Icons.restaurant_menu,
//                   title: 'Dining',
//                   subtitle: 'Invites & RSVP',
//                   color: AppColors.teal,
//                   width: cardWidth,
//                 ),
//                 _ActionCard(
//                   icon: Icons.groups_outlined,
//                   title: 'Directory',
//                   subtitle: 'Find attendees',
//                   color: AppColors.goldLight,
//                   width: cardWidth,
//                 ),
//                 _ActionCard(
//                   icon: Icons.folder_open,
//                   title: 'Resources',
//                   subtitle: 'Briefings & kits',
//                   color: AppColors.textSecondary,
//                   width: cardWidth,
//                 ),
//               ],
//             );
//           },
//         ),
//         const SizedBox(height: 24),
//         const _SectionHeader(title: 'Today at a glance', action: 'See full agenda'),
//         const SizedBox(height: 12),
//         const _AgendaCard(
//           time: '09:30 AM',
//           title: 'Opening keynote: The geopolitics of 2030',
//           location: 'Innovation Hall A',
//           speaker: 'Prime Minister Arjun Mehra',
//           isLive: true,
//         ),
//         const SizedBox(height: 12),
//         const _AgendaCard(
//           time: '11:00 AM',
//           title: 'Roundtable: Technology and trust',
//           location: 'Forum Studio 2',
//           speaker: 'Dr. John Doe · Speaker',
//           tag: "You're Speaking",
//           tagColor: AppColors.gold,
//         ),
//         const SizedBox(height: 12),
//         const _AgendaCard(
//           time: '02:00 PM',
//           title: 'Strategic dialogues: Indo-Pacific security',
//           location: 'Raisina Hall B',
//           speaker: 'Session · 45 mins',
//           tag: 'Session',
//           tagColor: AppColors.teal,
//         ),
//         const SizedBox(height: 24),
//         const _SectionHeader(title: 'Key participants', action: 'View all'),
//         const SizedBox(height: 12),
//         SizedBox(
//           height: 160,
//           child: ListView(
//             scrollDirection: Axis.horizontal,
//             children: const [
//               _SpeakerCard(
//                 name: 'Amb. Leena Rao',
//                 role: 'Special Envoy, MEA',
//                 tag: 'Diplomacy',
//               ),
//               _SpeakerCard(
//                 name: 'Dr. R. Banerjee',
//                 role: 'Economist, IGS',
//                 tag: 'Geo-economics',
//               ),
//               _SpeakerCard(
//                 name: 'Maya Torres',
//                 role: 'VP Policy, TerraNet',
//                 tag: 'Tech Policy',
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 24),
//         const _SectionHeader(title: 'Venue updates', action: 'Live status'),
//         const SizedBox(height: 12),
//         Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: AppColors.navyMid,
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.2),
//                 blurRadius: 16,
//                 offset: const Offset(0, 8),
//               ),
//             ],
//           ),
//           child: Column(
//             children: [
//               _StatusRow(
//                 label: 'Innovation Hall A',
//                 status: 'On time',
//                 color: AppColors.gold,
//               ),
//               const Divider(color: AppColors.navySurface),
//               _StatusRow(
//                 label: 'Wellness Suite',
//                 status: '15 min wait',
//                 color: AppColors.teal,
//               ),
//               const Divider(color: AppColors.navySurface),
//               _StatusRow(
//                 label: 'VIP Shuttle',
//                 status: 'Arriving',
//                 color: AppColors.goldLight,
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 32),
//       ],
//     );
//   }
// }

// class NetworkingView extends StatelessWidget {
//   const NetworkingView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       padding: const EdgeInsets.all(20),
//       children: [
//         const Text(
//           'Connect',
//           style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
//         ),
//         const SizedBox(height: 12),
//         Container(
//           padding: const EdgeInsets.all(18),
//           decoration: BoxDecoration(
//             color: AppColors.navySurface,
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Row(
//             children: [
//               const Icon(Icons.auto_awesome, color: AppColors.gold, size: 28),
//               const SizedBox(width: 12),
//               const Expanded(
//                 child: Text(
//                   'AI introductions based on your sessions, interests, and role.',
//                   style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 20),
//         const _SectionHeader(title: 'Recommended connections', action: 'Refresh'),
//         const SizedBox(height: 12),
//         const _ConnectionCard(
//           name: 'Amb. Raghav Menon',
//           role: 'High Commissioner · Singapore',
//           tags: ['Diplomacy', 'ASEAN'],
//         ),
//         const SizedBox(height: 12),
//         const _ConnectionCard(
//           name: 'Dr. Salma Idris',
//           role: 'Director · PeaceLab',
//           tags: ['Conflict resolution', 'MENA'],
//         ),
//         const SizedBox(height: 12),
//         const _ConnectionCard(
//           name: 'Neeraj Kapoor',
//           role: 'Partner · Bharat Ventures',
//           tags: ['Strategic capital', 'South Asia'],
//         ),
//         const SizedBox(height: 20),
//         const _SectionHeader(title: 'Meetups near you', action: 'View map'),
//         const SizedBox(height: 12),
//         const _MeetupCard(
//           title: 'Geo-economics briefing',
//           time: '4:30 PM · Lotus Lounge',
//           members: 18,
//         ),
//         const SizedBox(height: 12),
//         const _MeetupCard(
//           title: 'Speaker green room',
//           time: '6:00 PM · Raisina Garden',
//           members: 9,
//         ),
//       ],
//     );
//   }
// }

class _EventHeroCard extends StatelessWidget {
  const _EventHeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.navyMid,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
        border: Border.all(color: AppColors.goldDim),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.goldDim,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Live · Day 2',
                  style: TextStyle(
                      color: AppColors.goldLight, fontWeight: FontWeight.w600),
                ),
              ),
              const Spacer(),
              const Icon(Icons.wifi_tethering, color: AppColors.teal),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Raisina Dialogue 2026',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'New Delhi · 12-15 Feb',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  foregroundColor: Colors.white,
                ),
                child: const Text('My badge'),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: BorderSide(color: AppColors.goldLight.withOpacity(0.8)),
                ),
                icon: const Icon(Icons.map_outlined, size: 18),
                label: const Text('Venue map'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _HeroStat(label: 'Sessions', value: '12'),
              const SizedBox(width: 16),
              _HeroStat(label: 'Connections', value: '28'),
              const SizedBox(width: 16),
              _HeroStat(label: 'Dining', value: '4'),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.navySurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 12)),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.width,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.navyMid,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 12),
            Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            const SizedBox(height: 4),
            Text(subtitle,
                style: const TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.action});

  final String title;
  final String action;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary),
        ),
        Text(action, style: const TextStyle(color: AppColors.goldLight)),
      ],
    );
  }
}

class _AgendaCard extends StatelessWidget {
  const _AgendaCard({
    required this.time,
    required this.title,
    required this.location,
    required this.speaker,
    this.highlight = false,
    this.tag,
    this.tagColor,
    this.isLive = false,
  });

  final String time;
  final String title;
  final String location;
  final String speaker;
  final bool highlight;
  final String? tag;
  final Color? tagColor;
  final bool isLive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: highlight ? AppColors.navyElevated : AppColors.navyMid,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: highlight ? AppColors.gold : Colors.transparent,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: highlight ? AppColors.navySurface : AppColors.navySurface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  time.split(' ')[0],
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, color: AppColors.gold),
                ),
                Text(
                  time.split(' ')[1],
                  style:
                      const TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary),
                      ),
                    ),
                    if (isLive)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.red.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'LIVE',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.red),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(location,
                    style: const TextStyle(color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                Text(speaker,
                    style: const TextStyle(color: AppColors.textMuted)),
                if (tag != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: (tagColor ?? AppColors.gold).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      tag!,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: tagColor ?? AppColors.gold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const Icon(Icons.bookmark_border, color: AppColors.goldLight),
        ],
      ),
    );
  }
}

class _SpeakerCard extends StatelessWidget {
  const _SpeakerCard(
      {required this.name, required this.role, required this.tag});

  final String name;
  final String role;
  final String tag;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.navyMid,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.navySurface,
            child: Text(name.substring(0, 1),
                style: const TextStyle(color: AppColors.goldLight)),
          ),
          const SizedBox(height: 12),
          Text(name,
              style: const TextStyle(
                  fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          Text(role,
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.navySurface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(tag,
                style:
                    const TextStyle(color: AppColors.goldLight, fontSize: 11)),
          ),
        ],
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow(
      {required this.label, required this.status, required this.color});

  final String label;
  final String status;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(status,
              style: TextStyle(color: color, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}

class _ConnectionCard extends StatelessWidget {
  const _ConnectionCard(
      {required this.name, required this.role, required this.tags});

  final String name;
  final String role;
  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.navyMid,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.navySurface,
            child: Text(name.substring(0, 1),
                style: const TextStyle(color: AppColors.textPrimary)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Text(role,
                    style: const TextStyle(color: AppColors.textSecondary)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  children: tags
                      .map(
                        (tag) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.navySurface,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(tag,
                              style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary)),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
          const Icon(Icons.chat_bubble_outline, color: AppColors.goldLight),
        ],
      ),
    );
  }
}

class _MeetupCard extends StatelessWidget {
  const _MeetupCard(
      {required this.title, required this.time, required this.members});

  final String title;
  final String time;
  final int members;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.navyMid,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.navySurface,
            child:
                const Icon(Icons.groups_outlined, color: AppColors.goldLight),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Text(time,
                    style: const TextStyle(color: AppColors.textSecondary)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.navySurface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$members joined',
              style:
                  const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
