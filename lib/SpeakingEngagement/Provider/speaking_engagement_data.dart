import 'dart:convert';
 
import 'package:attendee_app/constants.dart';
import 'package:attendee_app/utility.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
 
class SpeakingEngagementData with ChangeNotifier {
 Future assignedUserDetails() async {
  try {
    var response = await http.post(
      Uri.parse(Constants.NODE_URL + Constants.assignedUserDetails),
      headers: {},
      body: jsonEncode(
        encryptPayload(
          {
            "userId": "567"
            //respose{
              //"userId": "567"
            //}
          },
        ),
      ),
    );
    var jsonData = decryptResponse(response.body);
    if (response.statusCode == 200 && jsonData["success"] == true) {
      var res = decryptResponse(response.body);
      {
       // "status": 200,
       // "success": true,
       // "message": "Fetched Successfully",
       // "data": {
      //     "speakingShow": false
      // }
      }
    }
  } catch (e) {
    debugPrint("this is the error in assignedUserDetailsApi: $e");
  }
}
}