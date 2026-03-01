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
  //varible
  var _data;
  var _totalUniqueDays;
  var _logo_short_name;
  var _userRole_name;
  var _rd_numebr;

  //geter
  get data => _data;
  get totalUniqueDays => _totalUniqueDays;
  get logo_short_name => _logo_short_name;
  get userRole_name => _userRole_name;
  get rd_number => _rd_numebr;

  fetch_userRolde() {
    var userRole = Hive.box('LoginDetails').get("Profile_details")['userRole'];
    if (userRole == 1) {
      _userRole_name = "SPEAKER";
    } else if (userRole == 2) {
      _userRole_name = "DELEGATE";
    } else if (userRole == 3) {
      _userRole_name = "AFGG";
    } else if (userRole == 4) {
      _userRole_name = "PARTICIPANTS";
    } else if (userRole == 5) {
      _userRole_name = "MEDIA";
    } else {
      _userRole_name = "No Role Assigned";
    }
  }

  Future<void> fetchUserProfile() async {
    fetch_userRolde();
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
        Hive.box('LoginDetails').put("imagsave", _data);

        //fetch rd numebr
        _rd_numebr = _data['profile']['qr_internal_id'];
        //fetch day of conference
        List<Map<String, dynamic>> confernace_days_value =
            List<Map<String, dynamic>>.from(_data['sessions']);
        _totalUniqueDays =
            confernace_days_value.map((e) => e['day_number']).toSet().length;

        //logo short name
        _logo_short_name =
            "${_data["profile"]["first_name"]?[0].toUpperCase() ?? ""}"
            "${_data["profile"]["last_name"]?[0].toUpperCase() ?? ""}";

        var profile = Map<String, dynamic>.from(
            Hive.box('LoginDetails').get("Profile_details"));
        profile['name'] = _data['profile']['name'];
        profile["logo_short_name"] = _logo_short_name;
        Hive.box('LoginDetails').put("Profile_details", profile);

        print("Profile data fetched: $data");
        print({data['profile']?['bio']});
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error in fetchUserProfile: $e");
      // debugger();
    }
  }
}

class Modaltable {
  String label;
  String value;
  Modaltable({required this.label, required this.value});
}
