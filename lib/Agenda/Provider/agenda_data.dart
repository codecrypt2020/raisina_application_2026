import 'dart:ui';

import 'package:attendee_app/constants.dart';
import 'package:attendee_app/main.dart';
import 'package:attendee_app/utility.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Agenda_data with ChangeNotifier {
//Agenda data storing varible

  var _selectedIndex = 0;
  List<Map<String, String>> _days = [];

  // final List<Map<String, String>> _days = [
  //   {"day": "Day 1", "date": "Feb 14"},
  //   {"day": "Day 2", "date": "Feb 15"},
  //   {"day": "Day 3", "date": "Feb 16"},
  //   {"day": "Day 4", "date": "Feb 17"},
  // ];
  List<AgendadataItem> _agenda_list = [];

  get agenda_list {
    return _agenda_list;
  }

  get days {
    return _days;
  }

  get selectedIndex {
    return _selectedIndex;
  }

  void selectedIndexfun(int index) {
    _selectedIndex = index; // button highlight
    getAgenda(index + 1); // api call
    notifyListeners();
  }

  void resetSelectedIndex() {
    _selectedIndex = 0; //_selectedIndex value reset
    notifyListeners();
  }

//date formate funtion
  String formatTimeWithAmPm(String time) {
    List<String> parts = time.split(":");

    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);

    String period = hour >= 12 ? "PM" : "AM";

    int formattedHour = hour % 12;
    if (formattedHour == 0) {
      formattedHour = 12;
    }

    String hourString = formattedHour.toString().padLeft(2, '0');
    String minuteString = minute.toString().padLeft(2, '0');

    return "$hourString:$minuteString $period";
  }

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
        {"eventId": "21"},
      )}');
      var jsonData = decryptResponse(response.body);
      // && jsonData["success"] == true
      if (response.statusCode == 200 && jsonData.length != 0) {
        var res = decryptResponse(response.body);

        if (res != null && res.isNotEmpty) {
          String startDateString = res[0]['start_date'];

          DateTime startDate = DateTime.parse(startDateString).toLocal();

          generateDays(startDate);
          notifyListeners();
        }
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
      "Dec"
    ];
    return months[month - 1];
  }

//agenda
  Future getAgenda([i]) async {
    try {
      var response = await http.post(
        Uri.parse(Constants.NODE_URL + Constants.getAgenda),
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
              "day": i == null ? 1 : i,
              "eventId":
                  '${Hive.box('LoginDetails').get("Profile_details")['eventId']}',
              'Content-Type': 'application/json',
// {
//     "day": 1,
//     "eventId": "21"
// }
            },
          ),
        ),
      );
      var jsonData = decryptResponse(response.body);
      if (response.statusCode == 200) {
        var res = decryptResponse(response.body);
        _agenda_list = mapSessionsToEngagements(res);
        notifyListeners();
      }
    } catch (e) {
      debugPrint("this is the error in getAgendaApi: ${e}");
    }
  }

  List<AgendadataItem> mapSessionsToEngagements(List<dynamic> agenda_data) {
    return agenda_data.map((agenda_data_map) {
      final String sessionDate = agenda_data_map['session_date'];

      DateTime parsedDate = DateTime.parse(sessionDate);

      String formattedDate =
          "${parsedDate.day} ${(parsedDate.month)} ${(parsedDate.year)}";

      String startTime = agenda_data_map['start_time'];

      // String startTimehour = startTime.split(":")[0];

      // print("bhdbchjdjbvhdfbvdfhjkbvbdf:${startTimehour}" );

      String endTime = agenda_data_map['end_time'];
      String endTimehour = endTime.split(":")[0];

      // String time = ;

      String period = formatTimeWithAmPm(startTime);

      print("time chkehgfhjerhgb:${period}");

      print("date formate check:${formattedDate}");
      return AgendadataItem(
        time: formattedDate, // 14 FEB Sat
        title: agenda_data_map['title'] ?? '',
        location: agenda_data_map['gate_name'] ?? '',
        description: agenda_data_map['description'] ?? '',
        start_time: period,
        end_time: endTimehour,
        speaker: agenda_data_map['speaker_names'] ?? '', // default
        //gate_name:agenda_data_map['gate_name'],
        // speaker: 'Session', // default
        tag: getSessionStatus(
            endTime: agenda_data_map['end_time'],
            sessionDate: agenda_data_map['session_date'],
            startTime: agenda_data_map['start_time']),
        tagColor: AppColors.teal, // default
        highlight: false,
        isLive: false,
      );
    }).toList();
  }

  String getSessionStatus({
    required String sessionDate,
    required String startTime,
    required String endTime,
  }) {
    final date = DateTime.parse(sessionDate);

    final year = date.year;
    final month = date.month;
    final day = date.day;

    final startParts = startTime.split(":");
    final startDateTime = DateTime(
      year,
      month,
      day,
      int.parse(startParts[0]),
      int.parse(startParts[1]),
      int.parse(startParts[2]),
    );

    final endParts = endTime.split(":");
    final endDateTime = DateTime(
      year,
      month,
      day,
      int.parse(endParts[0]),
      int.parse(endParts[1]),
      int.parse(endParts[2]),
    );

    final now = DateTime.now();

    if (now.isAfter(endDateTime)) {
      return "Completed";
    } else if (now.isBefore(startDateTime)) {
      return "Upcoming";
    } else {
      return "Live";
    }
  }
}

class AgendadataItem {
  final String time;
  final String title;
  final String location;
  final String speaker;
  final String tag;
  final String description;
  final String start_time;
  final String end_time;
  final Color tagColor;
  final bool highlight;
  final bool isLive;

  AgendadataItem({
    required this.time,
    required this.title,
    required this.location,
    required this.speaker,
    required this.tag,
    required this.description,
    required this.start_time,
    required this.end_time,
    required this.tagColor,
    this.highlight = false,
    this.isLive = false,
  });
}
