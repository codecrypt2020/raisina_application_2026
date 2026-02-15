import 'package:attendee_app/constants.dart';
import 'package:attendee_app/utility.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Agenda_data with ChangeNotifier {
//agenda
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
}
