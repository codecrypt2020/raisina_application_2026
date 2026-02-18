import 'package:attendee_app/Agenda/Provider/agenda_data.dart';
import 'package:attendee_app/Agenda/widgets/agenda_chip.dart';
import 'package:attendee_app/Agenda/widgets/filterChip.dart';
import 'package:attendee_app/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AgendaView extends StatelessWidget {
  AgendaView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Agenda_data>(context, listen: true);
    print("bhjfhjfbgvh:${provider.agenda_list}");
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: provider.agenda_list.length + 2, // header + spacing
      itemBuilder: (context, index) {
        // Header
        if (index == 0) {
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Agenda',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.start,
                  children: List.generate(provider.days.length, (index) {
                    bool isSelected = provider.selectedIndex == index;

                    return GestureDetector(
                      onTap: () {
                        // setState(() {
                        provider.selectedIndexfun(index); //= index;
                        // });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.goldDim
                              : AppColors.navySurface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.gold
                                : AppColors.navyElevated,
                          ),
                        ),
                        child: Text(
                          "${provider.days[index]["day"]} - ${provider.days[index]["date"]}",
                          style: TextStyle(
                            color: isSelected
                                ? AppColors.gold
                                : AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }),
                )
              ],
            ),
          );
        }
        // Space after header
        if (index == 1) {
          return SizedBox(height: 20);
        }

        final item = provider.agenda_list[index - 2];

        return Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: AgendaCard(
            time: item.time,
            title: item.title,
            location: item.location,
            speaker: item.speaker,
            tag: item.tag,
            description: item.description,
            starttime: item.start_time,
            endtime: item.end_time,
            tagColor: item.tagColor,
            highlight: item.highlight,
            isLive: item.isLive,
          ),
        );
      },
    );

    //  return
    // ListView(
    //   padding:  EdgeInsets.all(20),
    //   children:  [
    //     Text(
    //       'Agenda',
    //       style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
    //     ),
    //     SizedBox(height: 12),
    //     Wrap(
    //       spacing: 8,
    //       runSpacing: 8,
    //       children:  [
    //         FilterChip_agenda(label: 'Day 1 · Feb 12', selected: true),
    //         FilterChip_agenda(label: 'Day 2 · Feb 13'),
    //         FilterChip_agenda(label: 'Day 3 · Feb 14'),
    //         FilterChip_agenda(label: 'Day 4 · Feb 15'),
    //       ],
    //     ),
    //     SizedBox(height: 20),
    //     AgendaCard(
    //       time: '08:00 AM',
    //       title: 'Speaker breakfast: Strategic foresight',
    //       location: 'Grand Atrium',
    //       speaker: 'Invite only',
    //       highlight: true,
    //       tag: "You're Speaking",
    //       tagColor: AppColors.gold,
    //     ),
    //     SizedBox(height: 12),
    //     AgendaCard(
    //       time: '10:30 AM',
    //       title: 'Panel: Global South & climate finance',
    //       location: 'Forum Studio 1',
    //       speaker: 'Session · 60 mins',
    //       tag: 'Session',
    //       tagColor: AppColors.teal,
    //       isLive: true,
    //     ),
    //     SizedBox(height: 12),
    //     AgendaCard(
    //       time: '01:00 PM',
    //       title: 'Closed-door: Maritime security',
    //      ` location: 'Raisin`a Room 3',
    //       speaker: 'Limited seats',
    //       tag: 'Closed-door',
    //       tagColor: AppColors.goldLight,
    //     ),
    //     SizedBox(height: 12),
    //     AgendaCard(
    //       time: '03:30 PM',
    //       title: 'Fireside chat: The future of alliances',
    //       location: 'Summit Theatre',
    //       speaker: 'Session · 40 mins',
    //       tag: 'Session',
    //       tagColor: AppColors.teal,
    //     ),
    //   ],
    // );
  }
}
