import 'package:attendee_app/Agenda/Provider/agenda_data.dart';
import 'package:attendee_app/Agenda/widgets/agenda_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Agenda extends StatefulWidget {
  const Agenda({super.key});

  @override
  State<Agenda> createState() => _AgendaState();
}

class _AgendaState extends State<Agenda> {
  void initState() {
    // TODO: implement initState
    super.initState();
     Provider.of<Agenda_data>(context, listen: false).event_start_date();
  }

  @override
  Widget build(BuildContext context) {
    final fetch_data =
        Provider.of<Agenda_data>(context, listen: false).getAgenda();
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
          return AgendaView();
        }
      },
    );
  }
}
