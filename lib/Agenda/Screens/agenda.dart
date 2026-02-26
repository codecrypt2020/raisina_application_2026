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
  late Future _agendaFuture;

  @override
  void initState() {
    super.initState();
    _agendaFuture = _loadInitialAgenda();
  }

  Future<void> _loadInitialAgenda() async {
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) return;

    final provider = Provider.of<Agenda_data>(context, listen: false);
    provider.resetSelectedIndex();
    await provider.event_start_date();
    await provider.getAgenda();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      //putting the materail call in the api for first time loading

      future: _agendaFuture,
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
