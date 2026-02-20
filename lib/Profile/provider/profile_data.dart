import 'dart:developer';

import 'package:attendee_app/Profile/widgets/details_table.dart';
import 'package:attendee_app/Profile/widgets/info_card.dart';
import 'package:attendee_app/Profile/widgets/info_line.dart';
import 'package:attendee_app/Profile/widgets/session_tile.dart';
import 'package:attendee_app/Profile/widgets/tag_chip.dart';
import 'package:attendee_app/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../constants.dart';
import '../../utility.dart';
import 'package:hive/hive.dart';

class ProfileData with ChangeNotifier {
  var _data;
  get data => _data;
  Future<void> fetchUserProfile() async {
    try {
      var profileDetails = Hive.box('LoginDetails').get("Profile_details");

      var response = await http.post(
        Uri.parse(Constants.NODE_URL + Constants.userProfileApi),
        headers: {
          "x-encrypted": "1",
          'x-access-token':
              '${Hive.box('LoginDetails').get("Profile_details")['token']}',
          'x-access-type':
              '${Hive.box('LoginDetails').get("Profile_details")['token']}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          encryptPayload({
            "email": "${profileDetails['email']}",
            "userId": "${profileDetails['userId']}"
          }),
        ),
      );

      var jsonData = decryptResponse(response.body);

      if (response.statusCode == 200 && jsonData['success'] == true) {
        var res = decryptResponse(response.body);
        _data = res['data'];
        print("Profile data fetched: $data");
        print({data['profile']?['bio']});
        // notifyListeners();
      }
    } catch (e) {
      debugPrint("Error in fetchUserProfile: $e");
      debugger();
    }
  }
}

class Modaltable {
  String label;
  String value;
  Modaltable({required this.label, required this.value});
}
