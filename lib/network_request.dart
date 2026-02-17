import 'package:attendee_app/constants.dart';
import 'package:attendee_app/utility.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:http/retry.dart';

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

class Network_request {
  // login api

  static Future<Map<String, dynamic>> loginApi(username, password) async {
    try {
      var body = {
        // 'username': username,
        // 'password': password
        "username": "$username",
        "password": "$password"
      };

      ;
      var response = await http.post(
        Uri.parse(Constants.NODE_URL + Constants.login),
        headers: {
          "x-encrypted": "1",
          'Content-Type': 'application/json',
        },
        // body: {"data":"U2FsdGVkX18C+bNt9XK1jDkbPN2KYx1J2LEojy8T5d9ktqcH4vAimeuE54DHSzc+mJ+CmedpqkxT7YxlJBCZungGIt9JwEmpNxJ6ZU675cA="}
        body: jsonEncode(
          encryptPayload(
            body,
          ),
        ),
      );
      Map<String, dynamic> jsonData = decryptResponse(response.body);
      if (response.statusCode == 200 && jsonData["success"] == true) {
        var res = decryptResponse(response.body);
        Hive.box('LoginDetails').put("Profile_details", res["data"]);
        Hive.box("LoginDetails").put("token", res["data"]["token"]);
        return {"success": true, "message": "Login successful"};
      } else {
        return {
          "success": false,
          "message": jsonData["message"] ?? "Login failed"
        };
      }
    } catch (e) {
      print("this is the error in loginApi ${e}");
      return {"success": false, "message": "An error occurred during login."};
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
              "eventId":
                  "${Hive.box('LoginDetails').get("Profile_details")['eventId']}"
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
              "eventId":
                  "${Hive.box('LoginDetails').get("Profile_details")['eventId']}"
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

  Future get_user_qr() async {
    try {
      var response = await http.post(
        Uri.parse(Constants.NODE_URL + Constants.get_user_qr),
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
              //respose{
              //"userId": "567"
              //}
              {"searchText": "Nehemiah Hamid", "sortby": "id", "page": 1}),
        ),
      );
      var jsonData = decryptResponse(response.body);
      if (response.statusCode == 200 && jsonData["success"] == true) {
        var res = decryptResponse(response.body);
        return res["data"][0]["user_qr_img"];
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
