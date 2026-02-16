import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:attendee_app/constants.dart';
import 'package:attendee_app/utility.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class MapData extends ChangeNotifier {
  Future fetchMapsApi() async {
    try {
      var response = await http.post(
        Uri.parse(Constants.NODE_URL + Constants.mapsApi),
        headers: {
          "x-encrypted": "1",
          //   'x-access-token': '${Hive.box("LoginDetails").get("token")}',
          // 'x-access-type': '${Hive.box("LoginDetails").get("usertype")}',
          'x-access-token':
              '${Hive.box('LoginDetails').get("Profile_details")['token']}',
          'x-access-type':
              '${Hive.box('LoginDetails').get("Profile_details")['token']}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          encryptPayload(
            {
              "eventId":
                  "${Hive.box('LoginDetails').get("Profile_details")['eventId']}"
            },
          ),
        ),
      );
      var jsonData = decryptResponse(response.body);
      // && jsonData["success"] == true
      if (response.statusCode == 200 && jsonData.length != 0) {
        var res = decryptResponse(response.body);
        print("");
      }
    } catch (e) {
      debugPrint("this is the error in eventStartDateAPI : $e");
    }
  }
}
