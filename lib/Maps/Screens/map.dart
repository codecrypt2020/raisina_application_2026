import 'package:attendee_app/Maps/provider/map_data.dart';
import 'package:attendee_app/Maps/widgets/maps_view.dart';
import 'package:attendee_app/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    final fetchData =
        Provider.of<MapData>(context, listen: false).fetchMapsApi();

    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        title: const Text('Maps'),
        centerTitle: false,
      ),
      body: FutureBuilder(
        future: fetchData,
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (dataSnapshot.error != null) {
            return const Center(
              child: SingleChildScrollView(
                child: Text("An error occured"),
              ),
            );
          } else {
            return const MapsView();
          }
        },
      ),
    );
  }
}
