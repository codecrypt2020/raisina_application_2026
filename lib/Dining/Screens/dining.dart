import 'package:attendee_app/Agenda/Provider/agenda_data.dart';
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
  late Future _diningFuture;

  @override
  void initState() {
    super.initState();
    _diningFuture = _loadInitialDining();
  }

  Future<void> _loadInitialDining() async {
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) return;

    final provider = Provider.of<dining_data>(context, listen: false);
    provider.resetSelectedIndex();
    await provider.event_start_date();
    await provider.dining();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      //putting the materail call in the api for first time loading

      future: _diningFuture,
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
          return Dining_list();
        }
      },
    );
  }
}
