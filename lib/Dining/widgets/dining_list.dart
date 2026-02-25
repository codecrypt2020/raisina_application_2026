import 'package:attendee_app/Dining/Provider/dining_data.dart';
import 'package:attendee_app/Dining/widgets/dining_card.dart';
import 'package:attendee_app/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dining_list extends StatelessWidget {
  const Dining_list({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<dining_data>(context, listen: true);
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: provider.dining_list.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dining',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimaryOf(context),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.start,
                children: List.generate(provider.days.length, (dayIndex) {
                  final bool isSelected = provider.selectedIndex == dayIndex;

                  return GestureDetector(
                    onTap: () {
                      provider.selectedIndexfun(dayIndex);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.goldDim
                            : AppColors.surfaceSoftOf(context),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.gold
                              : AppColors.borderOf(context),
                        ),
                      ),
                      child: Text(
                        "${provider.days[dayIndex]["day"]} - ${provider.days[dayIndex]["date"]}",
                        style: TextStyle(
                          color: isSelected
                              ? AppColors.gold
                              : AppColors.textSecondaryOf(context),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
            ],
          );
        }

        if (provider.dining_list.isEmpty) {
          return SizedBox(
            height: 120,
            child: Center(
              child: Text(
                'No dining sessions found',
                style: TextStyle(color: AppColors.textSecondaryOf(context)),
              ),
            ),
          );
        }

        final item = provider.dining_list[index - 1];

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: DiningCard(
            time: item.time,
            title: item.title,
            location: item.location,
            speaker: item.speaker,
            highlight: item.highlight,
            tag: item.tag,
            tagColor: item.tagColor,
            isLive: item.isLive,
            time_range: item.time_range,
          ),
        );
      },
    );
  }
}
