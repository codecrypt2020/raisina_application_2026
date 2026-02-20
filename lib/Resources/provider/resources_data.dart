import 'package:attendee_app/Resources/Model/resource_category_datatype.dart';
import 'package:flutter/foundation.dart';
import 'package:attendee_app/constants.dart';
import 'package:attendee_app/utility.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
        print("this is the data in resources : $_data");
      }
    } catch (e) {
      debugPrint("this is the error in eventStartDateAPI : $e");
    }
  }
}
