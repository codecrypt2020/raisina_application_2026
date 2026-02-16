import 'dart:convert';
import 'dart:ui';

import 'package:attendee_app/constants.dart';
import 'package:attendee_app/main.dart';
import 'package:attendee_app/utility.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';

class SpeakingEngagementData with ChangeNotifier {
  //Data storing variables

  List<SpeakingEngagementItem> _sessions_list = [];
  int _sessions_count = 0;
  int _sessions_days = 0;

  get sessions_list {
    return _sessions_list;
  }

  get session_count {
    return _sessions_count;
  }

  get sessions_days {
    return _sessions_days;
  }

  Future SpeakingDetails() async {
    try {
      var response = await http.post(
        Uri.parse(Constants.NODE_URL + Constants.assignedUserspeakingDetails),
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
            {
              "userId":
                  "${Hive.box('LoginDetails').get("Profile_details")['userId']}",
              "userName":
                  "${Hive.box('LoginDetails').get("Profile_details")['userName']}"
            },
          ),
        ),
      );
      var jsonData = decryptResponse(response.body);
      if (response.statusCode == 200 && jsonData["success"] == true) {
        var res = decryptResponse(response.body);
        _sessions_list = mapSessionsToEngagements(res["data"]["sessions"]);
        _sessions_count = res['data']["totalSessionsCount"];
        _sessions_days = res['data']['eventTotalDays'];
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

  List<SpeakingEngagementItem> mapSessionsToEngagements(
      List<dynamic> sessions) {
    return sessions.map((session) {
      final date = session['date'];

      final String formattedDate =
          "${date['day']} ${date['month']} ${date['weekday']}";

      return SpeakingEngagementItem(
          date: formattedDate, // 14 FEB Sat
          title: session['title'] ?? '',
          location: session['location'] ?? '',
          speaker: session["coSpeakers"]
              .map((e) => e['name'] as String)
              .join(', '), // default
          tag: session["status"], // default
          tagColor: AppColors.teal, // default
          highlight: false,
          isLive: false,
          time: session["time"]);
    }).toList();
  }
}

final List<Map<String, dynamic>> attendees = [
  {"initials": "MMW", "name": "Momentum Mayur Wabale (You)", "isYou": true},
  {"initials": "RS", "name": "Rajendra Saini", "isYou": false}
];

class SpeakingEngagementItem {
  final String date;
  final String title;
  final String location;
  final String speaker;
  final String tag;
  final Color tagColor;
  final bool highlight;
  final bool isLive;
  final time;

  SpeakingEngagementItem(
      {required this.date,
      required this.title,
      required this.location,
      required this.speaker,
      required this.tag,
      required this.tagColor,
      this.highlight = false,
      this.isLive = false,
      this.time});
}
