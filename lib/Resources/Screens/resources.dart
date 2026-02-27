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
  late Future _resourcesFuture;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ResourcesData>(context, listen: false);
    _resourcesFuture = provider.fetchResources();
  }

  Future<void> _refreshResources() async {
    final refreshedFuture =
        Provider.of<ResourcesData>(context, listen: false).fetchResources();
    setState(() {
      _resourcesFuture = refreshedFuture;
    });
    await refreshedFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Resources',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimaryOf(context),
          ),
        ),
        centerTitle: false,
      ),
      body: FutureBuilder(
        //putting the materail call in the api for first time loading

        future: _resourcesFuture,
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (dataSnapshot.error != null) {
            {
              //do error handling
              return RefreshIndicator(
                onRefresh: _refreshResources,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [
                    SizedBox(
                      height: 400,
                      child: Center(
                        child: Text("An error occured"),
                      ),
                    ),
                  ],
                ),
              );
            }
          } else {
            return const Resources_view();
          }
        },
      ),
    );
  }
}
