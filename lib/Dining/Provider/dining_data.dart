import 'dart:convert';
import 'package:attendee_app/constants.dart';
import 'package:attendee_app/utility.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
 
 
class dining_data with ChangeNotifier {
 
 
  //Dining APIs
  Future event_start_date() async {
  try {
    var response = await http.post(
      Uri.parse(Constants.NODE_URL + Constants.eventStartDate),
      headers: {},
      body: jsonEncode(
        encryptPayload(
          {
            "eventId": ""
            //payload
// {
//     "eventId": "21"
// }
          },
        ),
      ),
    );
    var jsonData = decryptResponse(response.body);
    if (response.statusCode == 200 && jsonData["success"] == true) {
      var res = decryptResponse(response.body);
// Response
//       [
//     {
//         "id": 21,
//         "org_name": "Test Event Raisina",
//         "no_of_person": 6000,
//         "start_date": "2026-02-14T00:00:00.000Z",
//         "created_at": "2026-02-13T06:41:11.000Z",
//         "updated_at": "2026-02-13T06:41:11.000Z"
//     }
// ]
    }
  } catch (e) {
    debugPrint("this is the error in eventStartDateAPI : $e");
  }
}
 
//Dining APIs
Future dining() async {
  try {
    var response = await http.post(
      Uri.parse(Constants.NODE_URL + Constants.getdining),
      headers: {},
      body: jsonEncode(
        encryptPayload(
          {
            "eventId": ""
            //payload
// {
//     "day": 1,
//     "userId": "567"
// }
          },
        ),
      ),
    );
    var jsonData = decryptResponse(response.body);
    if (response.statusCode == 200 && jsonData["success"] == true) {
      var res = decryptResponse(response.body);
// Response
// [
//     {
//         "id": 2785,
//         "user_id": 1110,
//         "user_ref_id": 567,
//         "user_role": 1,
//         "org_ref_id": 21,
//         "day": 1,
//         "breakfast_valid": 1,
//         "breakfast_gate": "26",
//         "breakfast_gate_name": "Test Gate 1",
//         "lunch_valid": 1,
//         "lunch_gate": "27",
//         "lunch_gate_name": "Jawahar Gate",
//         "tea_valid": 0,
//         "tea_gate": "",
//         "tea_gate_name": null,
//         "dinner_valid": 0,
//         "dinner_gate": "",
//         "dinner_gate_name": null,
//         "agenda": null,
//         "speaking_engagement": "",
//         "dinning": null,
//         "about_us": null,
//         "date": "2026-02-14T00:00:00.000Z",
//         "created_at": "2026-02-13T11:59:30.000Z",
//         "updated_at": "2026-02-13T12:35:51.000Z",
//         "breakfast_agenda": "5",
//         "lunch_agenda": "6",
//         "tea_agenda": "0",
//         "dinner_agenda": "0",
//         "breakfastTopic": "Day 1 Breakfast Agenda",
//         "breakfastStartTime": "08:00:00",
//         "breakfastEndTime": "09:00:00",
//         "lunchTopic": "Day 1 Lunch ",
//         "lunchStartTime": "12:06:00",
//         "lunchEndTime": "13:10:00"
//     }
// ]
    }
  } catch (e) {
    debugPrint("this is the error in eventStartDateAPI : $e");
  }
}
 
}