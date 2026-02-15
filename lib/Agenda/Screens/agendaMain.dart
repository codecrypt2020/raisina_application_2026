import 'package:attendee_app/Agenda/Provider/agenda_data.dart';
import 'package:attendee_app/Agenda/Screens/agenda.dart';
import 'package:attendee_app/Agenda/widgets/agenda_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AgendaMain extends StatelessWidget {
  const AgendaMain({super.key});

  @override
  Widget build(BuildContext context) {
    // return AgendaView();
    return Agenda();
  }
}
