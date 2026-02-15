import 'dart:convert';
import 'package:attendee_app/constants.dart';
import 'package:attendee_app/main.dart';
import 'package:attendee_app/utility.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class dining_data with ChangeNotifier {
  List<DiningDataItem> _sessions_list = [];

  get sessions_list {
    return _sessions_list;
  }

  //Dining APIs
  Future event_start_date() async {
    try {
      var response = await http.post(
        Uri.parse(Constants.NODE_URL + Constants.eventStartDate),
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
      print('this is the payload bhhbhfbhvb${encryptPayload(
        {
          "eventId": "21"
          //payload
// {
//     "eventId": "21"
// }
        },
      )}');
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
              // "eventId": '${Hive.box('LoginDetails').get("Profile_details")['token']}',
              "day": 1,
              "userId": 567,
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
      if (response.statusCode == 200) {
        var res = decryptResponse(response.body);
        _sessions_list = res;
        print("");
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
      debugPrint("this is the error in Dining : $e");
    }
  }

  List<DiningDataItem> mapSessionsToEngagements(List<dynamic> sessions) {
    return sessions.map((session) {
      final date = session['date'];

      final String formattedDate =
          "${date['day']} ${date['month']} ${date['weekday']}";

      return DiningDataItem(
        time: formattedDate, // 14 FEB Sat
        title: session['title'] ?? '',
        location: session['location'] ?? '',
        speaker: 'Session', // default
        tag: 'Completed', // default
        // tagColor: AppColors.teal, // default
        highlight: false,
        isLive: false,
      );
    }).toList();
  }
}

class DiningDataItem {
  final String time;
  final String title;
  final String location;
  final String speaker;
  final String tag;
  // final Color tagColor;
  final bool highlight;
  final bool isLive;

  DiningDataItem({
    required this.time,
    required this.title,
    required this.location,
    required this.speaker,
    required this.tag,
    // required this.tagColor,
    this.highlight = false,
    this.isLive = false,
  });
}
