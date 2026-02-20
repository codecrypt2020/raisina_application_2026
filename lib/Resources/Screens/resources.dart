import 'package:attendee_app/Resources/Model/resource_category_datatype.dart';
import 'package:attendee_app/Resources/provider/resources_data.dart';
import 'package:attendee_app/Resources/widgets/resources_view.dart';
import 'package:attendee_app/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Resources extends StatefulWidget {
  const Resources({super.key});

  @override
  State<Resources> createState() => _ResourcesState();
}

class _ResourcesState extends State<Resources> {
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final fetch_data =
        Provider.of<ResourcesData>(context, listen: false).fetchResources();
    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        title: const Text('Resources'),
        centerTitle: false,
      ),
      body: FutureBuilder(
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
            return Resources_view();
          }
        },
      ),
    );
  }
}
