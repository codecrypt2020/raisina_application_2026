import 'package:attendee_app/Dining/widgets/dining_card.dart';
import 'package:attendee_app/Dining/widgets/dining_list.dart';
import 'package:attendee_app/Dining/widgets/filter_chip_dining.dart';
import 'package:attendee_app/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/dining_data.dart';

class Dining extends StatefulWidget {
  const Dining({super.key});

  @override
  State<Dining> createState() => _DiningState();
}

class _DiningState extends State<Dining> {
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }
  @override
  Widget build(BuildContext context) {
    final fetch_data =
        Provider.of<dining_data>(context, listen: false).event_start_date();
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
                    child:
                        SingleChildScrollView(child: Text("An error occured")),
                  );
                }
              } else {
                return Dining_list();
              }
            },
          );
  }
}

