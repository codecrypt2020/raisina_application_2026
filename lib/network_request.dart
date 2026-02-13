import 'package:attendee_app/constants.dart';
import 'package:attendee_app/utility.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// default skeleton
// Future skeletonApi() async {
//   try {
//     var response = await http.post(
//       Uri.parse(Constants.NODE_URL + Constants.login),
//       headers: {},
//       body: jsonEncode(
//         encryptPayload(
//           {},
//         ),
//       ),
//     );
//     var jsonData = decryptResponse(response.body);
//     if (response.statusCode == 200 && jsonData["success"] == true) {
//       var res = decryptResponse(response.body);
//     }
//   } catch (e) {
//     debugPrint("this is the error in -------------------- ${e}");
//   }
// }

// login api
Future login_api() async {
  try {
    var response =
        await http.post(Uri.parse(Constants.NODE_URL + Constants.login),
            headers: {},
            body: jsonEncode(encryptPayload({
              "username": "",
              "password": ""
//payload
//           {
//     "username": "mayurwabale1221@gmail.com",
//     "password": "Mjcc$012"
// }
            })));
    Map<String, dynamic> jsonData = decryptResponse(response.body);
    if (response.statusCode == 200 && jsonData["success"] == true) {
      var res = decryptResponse(response.body);
    }
// RESPONSE
// {
//     "success": true,
//     "message": "Login success",
//     "data": {
//         "userId": 567,
//         "token": "581ba50d5a449325db6dcb5e4130af90",
//         "name": "Momentum Mayur Wabale",
//         "type": "user",
//         "eventId": "21"
//     }
// }
  } catch (e) {
    print("this is the error in login_api ${e}");
  }
}

Future assignedUserDetails() async {
  try {
    var response = await http.post(
      Uri.parse(Constants.NODE_URL + Constants.assignedUserDetails),
      headers: {},
      body: jsonEncode(
        encryptPayload(
          {
            "userId": "567"
//respose
// {
//     "userId": "567"
// }
          },
        ),
      ),
    );
    var jsonData = decryptResponse(response.body);
    if (response.statusCode == 200 && jsonData["success"] == true) {
      var res = decryptResponse(response.body);
//       {
//     "status": 200,
//     "success": true,
//     "message": "Fetched Successfully",
//     "data": {
//         "speakingShow": false
//     }
// }
    }
  } catch (e) {
    debugPrint("this is the error in assignedUserDetailsApi: $e");
  }
}

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

Future getAgenda() async {
  try {
    var response = await http.post(
      Uri.parse(Constants.NODE_URL + Constants.getAgenda),
      headers: {},
      body: jsonEncode(
        encryptPayload(
          {
            "day": "",
            "eventId": ""
// {
//     "day": 1,
//     "eventId": "21"
// }
          },
        ),
      ),
    );
    var jsonData = decryptResponse(response.body);
    if (response.statusCode == 200 && jsonData["success"] == true) {
      var res = decryptResponse(response.body);
//       [
//     {
//         "id": 5,
//         "event_ref_id": 21,
//         "gate_ref_id": 26,
//         "day_number": 1,
//         "session_date": "2026-02-14T00:00:00.000Z",
//         "start_time": "08:00:00",
//         "end_time": "09:00:00",
//         "title": "Day 1 Breakfast Agenda",
//         "description": "This Agenda is for Discussion on climate change",
//         "category_ref_id": 2,
//         "tags": [
//             "Climate"
//         ],
//         "expected_attendance": 15,
//         "is_live": 0,
//         "is_active": 1,
//         "sort_order": 0,
//         "created_at": "2026-02-13T07:15:33.000Z",
//         "updated_at": "2026-02-13T07:15:33.000Z",
//         "created_by": null,
//         "gate_name": "Test Gate 1",
//         "speaker_names": "Momentum Mayur Wabale, Rajendra Saini",
//         "speaker_ids": "567, 566"
//     },
//     {
//         "id": 6,
//         "event_ref_id": 21,
//         "gate_ref_id": 27,
//         "day_number": 1,
//         "session_date": "2026-02-14T00:00:00.000Z",
//         "start_time": "12:06:00",
//         "end_time": "13:10:00",
//         "title": "Day 1 Lunch ",
//         "description": "Lunch session on cyber security",
//         "category_ref_id": 3,
//         "tags": [
//             "Cybersecurity"
//         ],
//         "expected_attendance": 25,
//         "is_live": 0,
//         "is_active": 1,
//         "sort_order": 0,
//         "created_at": "2026-02-13T07:25:12.000Z",
//         "updated_at": "2026-02-13T07:25:12.000Z",
//         "created_by": null,
//         "gate_name": "Jawahar Gate",
//         "speaker_names": "Momentum Mayur Wabale, Rajendra Saini",
//         "speaker_ids": "567, 566"
//     }
// ]
    }
  } catch (e) {
    debugPrint("this is the error in getAgendaApi: ${e}");
  }
}
