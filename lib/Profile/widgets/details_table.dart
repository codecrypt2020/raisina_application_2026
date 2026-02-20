import 'package:attendee_app/Profile/widgets/key_value_row.dart';
import 'package:flutter/material.dart';

class DetailsTable extends StatelessWidget {
  var status;

  var dietaryPreference;

  DetailsTable(
      {super.key, required this.status, required this.dietaryPreference});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        KeyValueRow(label: 'Registration', value: status),
        SizedBox(height: 10),
        KeyValueRow(label: 'Dietary Preference', value: dietaryPreference),
      ],
    );
  }
}
