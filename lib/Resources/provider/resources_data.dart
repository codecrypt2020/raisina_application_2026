import 'package:attendee_app/constants.dart';
import 'package:attendee_app/utility.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResourcesData extends ChangeNotifier {

  Future Ftech_resources() async {
    try {
      var response = await http.post(
        Uri.parse(Constants.NODE_URL + Constants.allresourcesapi),
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
                  "${Hive.box('LoginDetails').get("Profile_details")['eventId']}",
              "userRefId":"${Hive.box('LoginDetails').get("Profile_details")['userId']}"
              
            },
          ),
        ),
      );
      print('this is the payload bhhbhfbhvb${encryptPayload(
        {"eventId": "21"},
      )}');
      var jsonData = decryptResponse(response.body);
      // && jsonData["success"] == true
      if (response.statusCode == 200 && jsonData.length != 0) {
        var data = decryptResponse(response.body);
      }
    } catch (e) {
      debugPrint("this is the error in eventStartDateAPI : $e");
    }
  }

}
