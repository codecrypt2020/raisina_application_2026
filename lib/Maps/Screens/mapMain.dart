import 'package:attendee_app/Maps/Screens/map.dart';
import 'package:attendee_app/Maps/provider/map_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Mapmain extends StatelessWidget {
  const Mapmain({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => MapData()),
      ],
      child: const MapScreen(),
    );
  }
}
