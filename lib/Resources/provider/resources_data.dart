import 'package:attendee_app/Resources/Model/resource_category_datatype.dart';
import 'package:flutter/foundation.dart';
import 'package:attendee_app/constants.dart';
import 'package:attendee_app/utility.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class ResourcesData with ChangeNotifier {
  int _selectedCategoryIndex = 0;

  int get selectedCategoryIndex => _selectedCategoryIndex;

  void setSelectedCategoryIndex(int index) {
    _selectedCategoryIndex = index;
    notifyListeners();
  }

  var _data;

  List<ResourceCategory> _categories = [
    const ResourceCategory(label: 'All', count: 2, isSelected: true, index: 0),
    ResourceCategory(label: 'Event Info', count: 0, index: 1),
    ResourceCategory(label: 'Sessions', count: 1, index: 2),
    ResourceCategory(label: 'Media Kit', count: 0, index: 3),
    ResourceCategory(label: 'Speaker', count: 0, index: 4),
    ResourceCategory(label: 'General', count: 0, index: 5),
  ];

  get data {
    return _data;
  }

  get categories {
    return _categories;
  }

  Future fetchResources() async {
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
              "userRefId":
                  "${Hive.box('LoginDetails').get("Profile_details")['userId']}"
            },
          ),
        ),
      );

      var jsonData = decryptResponse(response.body);
      // && jsonData["success"] == true
      if (response.statusCode == 200 && jsonData.length != 0) {
        var data = decryptResponse(response.body);
        _data = data;
        processAndGroupData();
        notifyListeners();
        print("this is the data in resources : $_data");
      }
    } catch (e) {
      debugPrint("this is the error in eventStartDateAPI : $e");
    }
  }

  String formatDate(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) {
      return 'Unknown date';
    }

    try {
      final dateTime = DateTime.parse(isoDate).toLocal();
      return DateFormat('MMM d, yyyy').format(dateTime);
    } catch (e) {
      return 'Unknown date';
    }
  }

  String formatFileSize(dynamic rawSize) {
    if (rawSize == null) return 'Unknown size';
    double bytes;
    if (rawSize is String) {
      bytes = double.tryParse(rawSize) ?? 0;
    } else if (rawSize is num) {
      bytes = rawSize.toDouble();
    } else {
      return 'Unknown size';
    }

    if (bytes <= 0) return 'Unknown size';

    final kb = bytes / 1024;

    if (kb < 1024) {
      return '${kb.toStringAsFixed(1)} KB';
    } else {
      final mb = kb / 1024;
      return '${mb.toStringAsFixed(1)} MB';
    }
  }

  String getCategoryLabel(String? category) {
    switch (category) {
      case 'sessions':
        return 'Sessions';
      case 'event_info':
        return 'Event Info';
      case 'media':
        return 'Media Kit';
      case 'speaker':
        return 'Speaker';
      case 'general':
        return 'General';
      default:
        return 'Unknown';
    }
  }

  // List<dynamic> sortByCategoryCode(String categoryCode) {
  //   if (_data == null || _data["data"] == null) return [];
  //   final List<dynamic> list = _data["data"];
  //   if (categoryCode == 'all') return list;
  //   return list.where((item) {
  //     return item["category_code"] == categoryCode;
  //   }).toList();
  // }

  List<dynamic> _allList = [];
  List<dynamic> _eventInfoList = [];
  List<dynamic> _sessionsList = [];
  List<dynamic> _mediaList = [];
  List<dynamic> _speakerList = [];
  List<dynamic> _generalList = [];
  List<dynamic> get allList => _allList;
  List<dynamic> get eventInfoList => _eventInfoList;
  List<dynamic> get sessionsList => _sessionsList;
  List<dynamic> get mediaList => _mediaList;
  List<dynamic> get speakerList => _speakerList;
  List<dynamic> get generalList => _generalList;
  void processAndGroupData() {
    final rawData = _data?["data"];

    if (rawData is! List) return;

    _allList = rawData;

    _eventInfoList =
        rawData.where((e) => e["category_code"] == "event_info").toList();

    _sessionsList =
        rawData.where((e) => e["category_code"] == "sessions").toList();

    _mediaList = rawData.where((e) => e["category_code"] == "media").toList();

    _speakerList =
        rawData.where((e) => e["category_code"] == "speaker").toList();

    _generalList =
        rawData.where((e) => e["category_code"] == "general").toList();
  }
}
