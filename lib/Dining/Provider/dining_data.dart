import 'dart:convert';
import 'dart:ui';
import 'package:attendee_app/constants.dart';
import 'package:attendee_app/main.dart';
import 'package:attendee_app/utility.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class dining_data with ChangeNotifier {
  List<DiningDataItem> _dining_list = [];
  var _selectedIndex = 0;
  List<Map<String, String>> _days = [];

  // final List<Map<String, String>> _days = [
  //   {"day": "Day 1", "date": "Feb 14"},
  //   {"day": "Day 2", "date": "Feb 15"},
  //   {"day": "Day 3", "date": "Feb 16"},
  //   {"day": "Day 4", "date": "Feb 17"},
  // ];

  get dining_list {
    return _dining_list;
  }

  get days {
    return _days;
  }

  get selectedIndex {
    return _selectedIndex;
  }

  void selectedIndexfun(int index) {
    _selectedIndex = index; // button highlight
    dining(index + 1); // api call
    notifyListeners();
  }

  void resetSelectedIndex() {
    _selectedIndex = 0; //_selectedIndex value reset
    notifyListeners();
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
          "eventId":
              "${Hive.box('LoginDetails').get("Profile_details")['eventId']}"
        },
      )}');
      var jsonData = decryptResponse(response.body);
      if (response.statusCode == 200 && jsonData.length != 0) {
        var res = decryptResponse(response.body);
        if (res != null && res.isNotEmpty) {
          String startDateString = res[0]['start_date'];

          DateTime startDate = DateTime.parse(startDateString).toLocal();

          generateDays(startDate);
          notifyListeners();
        }
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

  void generateDays(DateTime startDate) {
    _days.clear();

    for (int i = 0; i < 4; i++) {
      DateTime newDate = startDate.add(Duration(days: i));

      String formattedDate = "${_getMonthName(newDate.month)} ${newDate.day}";

      _days.add({
        "day": "Day ${i + 1}",
        "date": formattedDate,
      });
    }
  }

  String _getMonthName(int month) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return months[month - 1];
  }

//Dining APIs
  Future dining([i]) async {
    //empyting the list
    _dining_list = [];

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
              "day": i == null ? 1 : i,
              "userId":
                  "${Hive.box('LoginDetails').get("Profile_details")['userId']}",
            },
          ),
        ),
      );
      var jsonData = decryptResponse(response.body);
      if (response.statusCode == 200) {
        var res = decryptResponse(response.body);
        //function to be added here
        if (res.length != 0) {
          mapmeal(res[0]);
        }
      }
    } catch (e) {
      debugPrint("this is the error in Dining : $e");
    }
  }

  String formatTo12Hour(String? time24) {
    if (time24 == null || time24.isEmpty) return '';

    try {
      final parts = time24.split(':');
      int hour = int.parse(parts[0]);
      final minute = parts[1];

      final period = hour >= 12 ? 'PM' : 'AM';

      hour = hour % 12;
      if (hour == 0) hour = 12;

      return '$hour:$minute $period';
    } catch (e) {
      return '';
    }
  }

  mapmeal(dining_list) {
    List<DiningDataItem> dining_list_raw = [];
    String formattedTime = formatTo12Hour(dining_list?['breakfastStartTime']);
    // String timeRange_breakfast = formatTimeRange(
    //   dining_list?['breakfastStartTime'],
    //   dining_list?['breakfastEndTime'],
    // );

    //breakfast
    if (dining_list?['breakfast_agenda'] != null &&
        dining_list!['breakfast_agenda'].toString().isNotEmpty &&
        (int.tryParse(dining_list['breakfast_agenda'].toString()) ?? 0) != 0) {
      dining_list_raw.add(DiningDataItem(
        time: formatTo12Hour(dining_list?['breakfastStartTime']), // 14 FEB Sat
        title: "Breakfast - ${dining_list["breakfastTopic"]}",
        location: dining_list['breakfast_gate_name'] ?? '',
        speaker: 'Session', // default
        tagColor: Colors.red,
        tag: 'Completed', // default
        // tagColor: AppColors.teal, // default
        highlight: false,
        isLive: false,
        time_range: formatTimeRange(
          dining_list?['breakfastStartTime'],
          dining_list?['breakfastEndTime'],
        ),
      ));
    }
    // //lunch
    if (dining_list?['lunch_agenda'] != null &&
        dining_list!['lunch_agenda'].toString().isNotEmpty &&
        (int.tryParse(dining_list['lunch_agenda'].toString()) ?? 0) != 0) {
      dining_list_raw.add(DiningDataItem(
        time: "${formatTo12Hour(dining_list?['lunchStartTime'])}", // 14 FEB Sat
        title: "Lunch - ${dining_list["lunchTopic"]}",
        location: dining_list['lunch_gate_name'] ?? '',
        speaker: 'Session', // default
        tagColor: Colors.red,
        tag: 'Completed', // default
        // tagColor: AppColors.teal, // default
        highlight: false,
        isLive: false,
        time_range: formatTimeRange(
          dining_list?['lunchStartTime'],
          dining_list?['lunchEndTime'],
        ),
      ));
    }
    // //tea
    if (dining_list?['tea_agenda'] != null &&
        dining_list!['tea_agenda'].toString().isNotEmpty &&
        (int.tryParse(dining_list['tea_agenda'].toString()) ?? 0) != 0) {
      dining_list_raw.add(DiningDataItem(
        time: formatTo12Hour(dining_list?['teaStartTime']), // 14 FEB Sat
        title: "High Tea - ${dining_list["teaTopic"]}",
        location: dining_list['tea_gate_name'] ?? '',
        speaker: 'Session', // default
        tagColor: Colors.red,
        tag: 'Completed', // default
        // tagColor: AppColors.teal, // default
        highlight: false,
        isLive: false,
        time_range: formatTimeRange(
          dining_list?['teaStartTime'],
          dining_list?['teaEndTime'],
        ),
      ));
    }
    // //dinner
    if (dining_list?['dinner_agenda'] != null &&
        dining_list!['dinner_agenda'].toString().isNotEmpty &&
        (int.tryParse(dining_list['dinner_agenda'].toString()) ?? 0) != 0) {
      dining_list_raw.add(DiningDataItem(
        time: formatTo12Hour(dining_list?['dinnerStartTime']), // 14 FEB Sat
        title: "Dinner - ${dining_list["dinnerTopic"]}",
        location: dining_list['dinner_gate_name'] ?? '',
        speaker: 'Session', // default
        tagColor: Colors.red,
        tag: 'Completed', // default
        // tagColor: AppColors.teal, // default
        highlight: false,
        isLive: false,
        time_range: formatTimeRange(
          dining_list?['dinnerStartTime'],
          dining_list?['dinnerEndTime'],
        ),
      ));
    }
    _dining_list = dining_list_raw;
    notifyListeners();
  }
}

String formatTimeRange(String? startTime, String? endTime) {
  if (startTime == null ||
      endTime == null ||
      startTime.isEmpty ||
      endTime.isEmpty) {
    return '';
  }

  try {
    String formatSingle(String time) {
      final parts = time.split(':');
      int hour = int.parse(parts[0]);
      final minute = parts[1];

      final period = hour >= 12 ? 'PM' : 'AM';

      hour = hour % 12;
      if (hour == 0) hour = 12;

      return '$hour:$minute$period';
    }

    return '${formatSingle(startTime)} - ${formatSingle(endTime)}';
  } catch (e) {
    return '';
  }
}

//   List<DiningDataItem> mapSessionsToEngagements(List<dynamic> sessions) {
//     return sessions.map((session) {
//       final date = session['date'];

//       final String formattedDate =
//           "${date['day']} ${date['month']} ${date['weekday']}";

//       return DiningDataItem(
//         time: formattedDate, // 14 FEB Sat
//         title: session['title'] ?? '',
//         location: session['location'] ?? '',
//         speaker: 'Session', // default
//         tag: 'Completed', // default
//         // tagColor: AppColors.teal, // default
//         highlight: false,
//         isLive: false,
//       );
//     }).toList();
//   }
// }

class DiningDataItem {
  final String time;
  final String title;
  final String location;
  final String speaker;
  final String tag;
  final Color tagColor;
  final bool highlight;
  final bool isLive;
  final String time_range;

  DiningDataItem({
    required this.time,
    required this.title,
    required this.location,
    required this.speaker,
    required this.tag,
    required this.tagColor,
    this.highlight = false,
    this.isLive = false,
    this.time_range = "",
  });
}
