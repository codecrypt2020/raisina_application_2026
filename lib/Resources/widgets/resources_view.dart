import 'package:attendee_app/Resources/Model/resource_category_datatype.dart';
import 'package:attendee_app/Resources/provider/resources_data.dart';
import 'package:attendee_app/Resources/widgets/allData.dart';
import 'package:attendee_app/Resources/widgets/category_chip.dart';
import 'package:attendee_app/Resources/widgets/eventInfo.dart';
import 'package:attendee_app/Resources/widgets/forYou.dart';
import 'package:attendee_app/Resources/widgets/general.dart';
import 'package:attendee_app/Resources/widgets/mediaKit.dart';
import 'package:attendee_app/Resources/widgets/resource_card.dart';
import 'package:attendee_app/Resources/widgets/section_header.dart';
import 'package:attendee_app/Resources/widgets/sessions.dart';
import 'package:attendee_app/Resources/widgets/speaker.dart';
import 'package:attendee_app/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Resources_view extends StatefulWidget {
  const Resources_view({
    super.key,
  });

  @override
  State<Resources_view> createState() => _Resources_viewState();
}

class _Resources_viewState extends State<Resources_view> {
  List<GlobalKey> _chipKeys = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final categoriesLength =
        Provider.of<ResourcesData>(context, listen: false).categories.length;
    if (_chipKeys.length != categoriesLength) {
      _chipKeys = List.generate(categoriesLength, (_) => GlobalKey());
    }
  }

  void _scrollToChip(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || index >= _chipKeys.length) return;
      final chipContext = _chipKeys[index].currentContext;
      if (chipContext == null) return;
      Scrollable.ensureVisible(
        chipContext,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeInOut,
        alignment: 0.5,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ResourcesData>(context);
    final bool isDark = AppColors.isDark(context);
    final Color textSecondaryColor = AppColors.textSecondaryOf(context);
    final Color textMutedColor = AppColors.textMutedOf(context);
    final Color cardColor = AppColors.elevatedOf(context);
    final Color borderColor = AppColors.borderOf(context);
    final List<Color> backgroundGradient = isDark
        ? const [Color(0xFF0C1220), Color(0xFF101A2B)]
        : const [Color(0xFFF8FAFD), Color(0xFFF2F6FC)];
    List<Widget> widgetss = [
      if (provider.selectedCategoryIndex == 0)
        const Alldata()
      else if (provider.selectedCategoryIndex == 1)
        const ForYou()
      else if (provider.selectedCategoryIndex == 2)
        const Eventinfo()
      else if (provider.selectedCategoryIndex == 3)
        const Sessions()
      else if (provider.selectedCategoryIndex == 4)
        Mediakit()
      else if (provider.selectedCategoryIndex == 5)
        const Speaker()
      else if (provider.selectedCategoryIndex == 6)
        General()
      else
        SizedBox(
          height: 120,
          child: Center(
            child: Text(
              'No resources found for this category',
              style: TextStyle(color: textSecondaryColor),
            ),
          ),
        )
    ];

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: backgroundGradient,
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
                  color: cardColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: borderColor),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: provider.setSearchQuery,
                  decoration: InputDecoration(
                    hintText: 'Search resources...',
                    hintStyle: TextStyle(color: textMutedColor),
                    prefixIcon: Icon(
                      Icons.search,
                      color: textMutedColor,
                    ),
                    suffixIcon: provider.searchQuery.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _searchController.clear();
                              provider.setSearchQuery('');
                            },
                            icon: Icon(
                              Icons.close,
                              color: textMutedColor,
                            ),
                          )
                        : null,
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
                  children:
                      provider.categories.asMap().entries.map<Widget>((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: KeyedSubtree(
                        key: _chipKeys[index],
                        child: CategoryChip(
                          item: item,
                          index: index,
                          onTap: () {
                            provider.setSelectedCategoryIndex(index);
                            _scrollToChip(index);
                          },
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Expanded(
              child: widgetss[0],
            )
          ],
        ),
      ),
    );
  }
}
