import 'package:attendee_app/Profile/widgets/key_value_row.dart';
import 'package:flutter/material.dart';

class DetailsTable extends StatelessWidget {
  final String rdNumber;
  final String status;
  final String dietaryPreference;

  DetailsTable({
    super.key,
    required this.rdNumber,
    required this.status,
    required this.dietaryPreference,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        KeyValueRow(label: 'RD Number', value: rdNumber),
        SizedBox(height: 10),
        KeyValueRow(label: 'Registration', value: status),
        SizedBox(height: 10),
        KeyValueRow(label: 'Dietary Preference', value: dietaryPreference),
      ],
    );
  }
}
