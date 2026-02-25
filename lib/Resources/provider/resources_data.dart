// import 'dart:developer';

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
  String _searchQuery = '';

  int get selectedCategoryIndex => _selectedCategoryIndex;
  String get searchQuery => _searchQuery;

  void setSelectedCategoryIndex(int index) {
    _selectedCategoryIndex = index;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query.trim();
    notifyListeners();
  }

  var _data;

  List<ResourceCategory> _categories = [
    ResourceCategory(label: 'All', count: 2, isSelected: true, index: 0),
    ResourceCategory(label: 'For you', count: 0, index: 6),
    ResourceCategory(label: 'Event Info', count: 0, index: 1),
    ResourceCategory(label: 'Sessions', count: 1, index: 2),
    ResourceCategory(label: 'Media Kit', count: 0, index: 3),
    ResourceCategory(label: 'Speaker', count: 0, index: 4),
    ResourceCategory(label: 'General', count: 0, index: 5),
    // ResourceCategory(label: 'For you', count: 0, index: 6),
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
        await loadUserRoleFromHive();
        _data = data;
        // debugger();
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
  // void processAndGroupData() {
  //   final rawData = _data?["data"];

  //   if (rawData is! List) return;

  //   _allList = rawData;

  //   _eventInfoList =
  //       rawData.where((e) => e["category_code"] == "event_info").toList();

  //   _sessionsList =
  //       rawData.where((e) => e["category_code"] == "sessions").toList();

  //   _mediaList = rawData.where((e) => e["category_code"] == "media").toList();

  //   _speakerList =
  //       rawData.where((e) => e["category_code"] == "speaker").toList();

  //   _generalList =
  //       rawData.where((e) => e["category_code"] == "general").toList();

  //   _featuredList = rawData.where((e) => e["is_featured"] == 1).toList();
  // }
  void processAndGroupData() {
    final rawData = _data?["data"];

    if (rawData is! List) return;

    // 🔥 ROLE FILTER FIRST
    final roleFilteredList = rawData.where((item) {
      final List<dynamic>? roles = item["target_roles"];

      if (_currentUserRole.isEmpty) {
        return true; // fallback if role missing
      }

      if (roles == null) return false;

      return roles.contains(_currentUserRole);
    }).toList();

    // 🔥 GROUP ONLY FILTERED DATA
    _allList = roleFilteredList;

    _eventInfoList = roleFilteredList
        .where((e) => e["category_code"] == "event_info")
        .toList();

    _sessionsList = roleFilteredList
        .where((e) => e["category_code"] == "sessions")
        .toList();

    _mediaList =
        roleFilteredList.where((e) => e["category_code"] == "media").toList();

    _speakerList =
        roleFilteredList.where((e) => e["category_code"] == "speaker").toList();

    _generalList =
        roleFilteredList.where((e) => e["category_code"] == "general").toList();

    _featuredList =
        roleFilteredList.where((e) => e["is_featured"] == 1).toList();
  }

  int get allCount => _allList.length;
  int get eventInfoCount => _eventInfoList.length;
  int get sessionsCount => _sessionsList.length;
  int get mediaCount => _mediaList.length;
  int get speakerCount => _speakerList.length;
  int get generalCount => _generalList.length;
  int getCountByIndex(int index) {
    switch (index) {
      case 0:
        return _allList.length;

      case 1:
        return _eventInfoList.length;

      case 2:
        return _sessionsList.length;

      case 3:
        return _mediaList.length;

      case 4:
        return _speakerList.length;

      case 5:
        return _generalList.length;
      case 6:
        return _featuredList.length;

      default:
        return 0;
    }
  }

  List<dynamic> _featuredList = [];

  List<dynamic> get featuredList => _featuredList;

  bool _matchesSearch(dynamic item) {
    if (_searchQuery.isEmpty) return true;
    final needle = _searchQuery.toLowerCase();
    final title = (item['title'] ?? '').toString().toLowerCase();
    final description = (item['description'] ?? '').toString().toLowerCase();
    final type = (item['file_type'] ?? '').toString().toLowerCase();
    final category = getCategoryLabel(item['category_code']).toLowerCase();
    return title.contains(needle) ||
        description.contains(needle) ||
        type.contains(needle) ||
        category.contains(needle);
  }

  List<dynamic> _applySearch(List<dynamic> source) {
    if (_searchQuery.isEmpty) return source;
    return source.where(_matchesSearch).toList();
  }

  List<dynamic> get searchedAllList => _applySearch(_allList);
  List<dynamic> get searchedEventInfoList => _applySearch(_eventInfoList);
  List<dynamic> get searchedSessionsList => _applySearch(_sessionsList);
  List<dynamic> get searchedMediaList => _applySearch(_mediaList);
  List<dynamic> get searchedSpeakerList => _applySearch(_speakerList);
  List<dynamic> get searchedGeneralList => _applySearch(_generalList);
  List<dynamic> get searchedFeaturedList => _applySearch(_featuredList);

  Map<String, List<dynamic>> get groupedSearchedAllData {
    final Map<String, List<dynamic>> grouped = {};
    for (final item in searchedAllList) {
      final category = item['category_code'] ?? 'unknown';
      grouped.putIfAbsent(category, () => <dynamic>[]);
      grouped[category]!.add(item);
    }
    return grouped;
  }

  Map<String, List<dynamic>> get groupedFeaturedData {
    Map<String, List<dynamic>> grouped = {};

    for (var item in searchedFeaturedList) {
      final category = item['category_code'] ?? 'unknown';

      if (!grouped.containsKey(category)) {
        grouped[category] = [];
      }

      grouped[category]!.add(item);
    }

    return grouped;
  }

  String _currentUserRole = '';

  String get currentUserRole => _currentUserRole;

  void setUserRoleFromLogin(int roleId) {
    switch (roleId) {
      case 1:
        _currentUserRole = 'speaker';
        break;
      case 2:
        _currentUserRole = 'delegate';
        break;
      case 3:
        _currentUserRole = 'afgg';
        break;
      case 4:
        _currentUserRole = 'participant';
        break;
      case 5:
        _currentUserRole = 'media';
        break;
      default:
        _currentUserRole = '';
    }
  }

  Future<void> loadUserRoleFromHive() async {
    final box = Hive.box("LoginDetails");
    final roleId = box.get("roleId");

    if (roleId != null) {
      setUserRoleFromLogin(roleId);
    }
  }
}
