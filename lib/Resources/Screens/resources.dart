import 'package:attendee_app/Resources/provider/resources_data.dart';
import 'package:attendee_app/Resources/widgets/resources_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Resources extends StatefulWidget {
  const Resources({super.key});

  @override
  State<Resources> createState() => _ResourcesState();
}

class _ResourcesState extends State<Resources> {
    // void initState() {
    // TODO: implement initState
    //super.initState();
    // Provider.of<Agenda_data>(context, listen: false).event_start_date();
    // Future.microtask(() {
    //   //“Do this task a little later — after the build is complete.
    //   Provider.of<Agenda_data>(context, listen: false).resetSelectedIndex();
    // });
  // }
  @override
  Widget build(BuildContext context) {
    final fetch_data = 
         Provider.of<ResourcesData>(context, listen: false).Ftech_resources();
    return FutureBuilder(
      //putting the materail call in the api for first time loading

      future: fetch_data,
      builder: (ctx, dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (dataSnapshot.error != null) {
          {
            //do error handling
            return Center(
              child: SingleChildScrollView(child: Text("An error occured")),
            );
          }
        } else {
          return ResourcesView();
        }
      },
    );
  }
}