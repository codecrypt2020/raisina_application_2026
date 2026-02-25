import 'package:attendee_app/Resources/Screens/resources.dart';
import 'package:attendee_app/Resources/provider/resources_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResourcesMain extends StatelessWidget {
  const ResourcesMain({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => ResourcesData()),
      ],
      child: const Resources(),
    );
  }
}
