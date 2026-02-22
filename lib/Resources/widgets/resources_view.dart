import 'package:attendee_app/Resources/Model/resource_category_datatype.dart';
import 'package:attendee_app/Resources/provider/resources_data.dart';
import 'package:attendee_app/Resources/widgets/allData.dart';
import 'package:attendee_app/Resources/widgets/category_chip.dart';
import 'package:attendee_app/Resources/widgets/eventInfo.dart';
import 'package:attendee_app/Resources/widgets/general.dart';
import 'package:attendee_app/Resources/widgets/mediaKit.dart';
import 'package:attendee_app/Resources/widgets/resource_card.dart';
import 'package:attendee_app/Resources/widgets/section_header.dart';
import 'package:attendee_app/Resources/widgets/sessions.dart';
import 'package:attendee_app/Resources/widgets/speaker.dart';
import 'package:attendee_app/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Resources_view extends StatelessWidget {
  const Resources_view({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ResourcesData>(context);
    List<Widget> widgetss = [
      if (provider.selectedCategoryIndex == 0)
        Alldata(data: provider.data)
      else if (provider.selectedCategoryIndex == 1)
        Eventinfo()
      else if (provider.selectedCategoryIndex == 2)
        Sessions()
      else if (provider.selectedCategoryIndex == 3)
        Mediakit()
      else if (provider.selectedCategoryIndex == 4)
        Speaker()
      else if (provider.selectedCategoryIndex == 5)
        General()
      else
        const SizedBox(
          height: 120,
          child: Center(
            child: Text(
              'No resources found for this category',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
        )
    ];

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFF8FAFD),
            Color(0xFFF2F6FC),
          ],
        ),
      ),
      child: Column(
        // padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.navyElevated,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.navySurface),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search resources...',
                  hintStyle: TextStyle(color: AppColors.textMuted),
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors.textMuted,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: provider.categories
                    .map<Widget>((item) => Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: CategoryChip(
                              item: item,
                              index: provider.categories.indexOf(item)),
                        ))
                    .toList(),
              ),
            ),
          ),
          Expanded(
            child: widgetss[0],
          )
        ],
      ),
    );
  }
}
