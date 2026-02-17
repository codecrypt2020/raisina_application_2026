import 'package:attendee_app/Resources/Model/resource_category_datatype.dart';
import 'package:attendee_app/Resources/widgets/resources_view.dart';
import 'package:attendee_app/main.dart';
import 'package:flutter/material.dart';

class Resources extends StatelessWidget {
  const Resources({super.key});

  @override
  Widget build(BuildContext context) {
    const List<ResourceCategory> categories = [
      ResourceCategory(label: 'All', count: 2, isSelected: true),
      ResourceCategory(label: 'For You', count: 1),
      ResourceCategory(label: 'Event Info', count: 0),
      ResourceCategory(label: 'Sessions', count: 1),
      ResourceCategory(label: 'Media Kit', count: 0),
    ];

    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        title: const Text('Resources'),
        centerTitle: false,
      ),
      body: Resources_view(categories: categories),
    );
  }
}
