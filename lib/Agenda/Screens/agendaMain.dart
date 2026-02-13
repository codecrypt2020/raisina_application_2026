import 'package:attendee_app/Agenda/Provider/agenda_data.dart';
import 'package:attendee_app/Agenda/Screens/agenda_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AgendaMain extends StatelessWidget {
  const AgendaMain({super.key});

  @override
  Widget build(BuildContext context) {
    // return AgendaView();
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (ctx) => Agenda_data()),

          //define multiple providers
        ],
        child: AgendaView(
          
        ));
  }
}
