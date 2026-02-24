import 'dart:convert';

import 'package:attendee_app/constants.dart';
import 'package:attendee_app/utility.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class MapData extends ChangeNotifier {
  dynamic _rawResponse;
  List<MapFloorData> _floors = [];
  List<MapLegendData> _legend = [];

  dynamic get rawResponse => _rawResponse;
  List<MapFloorData> get floors => _floors;
  List<MapLegendData> get legend => _legend;

  Future fetchMapsApi() async {
    try {
      final response = await http.post(
        Uri.parse(Constants.NODE_URL + Constants.mapsApi),
        headers: {
          "x-encrypted": "1",
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

      final jsonData = decryptResponse(response.body);
      if (response.statusCode == 200 && jsonData.length != 0) {
        final res = decryptResponse(response.body);
        _rawResponse = res;
        _floors = _parseFloors(res);
        _legend = _parseLegend(res);
        notifyListeners();

        final root = _asMap(res);
        debugPrint('mapsApi root keys: ${root?.keys.toList() ?? 'non-map'}');
        debugPrint('mapsApi parsed floors: ${_floors.length}');
        debugPrint('mapsApi parsed legend: ${_legend.length}');
      }
    } catch (e) {
      debugPrint("this is the error in fetchMapsApi: $e");
    }
  }

  List<MapFloorData> _parseFloors(dynamic res) {
    final root = _asMap(res);
    final floorCandidates = _asList(root?['floors']) ??
        _asList(root?['data']) ??
        _asList(root?['maps']) ??
        _asList(res);

    if (floorCandidates == null) return [];

    return floorCandidates.map<MapFloorData>((floorRaw) {
      final floorMap = _asMap(floorRaw);

      final floorLabel = _asString(
            floorMap?['floorName'] ??
                floorMap?['floor_name'] ??
                floorMap?['floor'] ??
                floorMap?['name'] ??
                floorMap?['label'],
          ) ??
          'Floor';

      final mapImageUrl = _asString(
        floorMap?['mapImage'] ??
            floorMap?['map_image'] ??
            floorMap?['image'] ??
            floorMap?['map_url'] ??
            floorMap?['floor_plan'],
      );
      final mapWidth = _asPositiveDouble(
        floorMap?['mapWidth'] ??
            floorMap?['map_width'] ??
            floorMap?['imageWidth'] ??
            floorMap?['image_width'] ??
            floorMap?['width'],
      );
      final mapHeight = _asPositiveDouble(
        floorMap?['mapHeight'] ??
            floorMap?['map_height'] ??
            floorMap?['imageHeight'] ??
            floorMap?['image_height'] ??
            floorMap?['height'],
      );

      final groupCandidates = _asList(floorMap?['groups']) ?? <dynamic>[];
      final poisFromGroups = <MapPoiData>[];

      for (final groupRaw in groupCandidates) {
        final groupMap = _asMap(groupRaw);
        final groupName = _asString(
              groupMap?['groupName'] ?? groupMap?['group'] ?? groupMap?['name'],
            ) ??
            'Locations';
        final items = _asList(groupMap?['items']) ?? <dynamic>[];
        for (final item in items) {
          poisFromGroups.add(
            _mapPoiItem(
              item,
              groupName: groupName,
              mapWidth: mapWidth,
              mapHeight: mapHeight,
            ),
          );
        }
      }

      // Fallback for old/alternate API shapes without groups.
      final poiCandidates = _asList(floorMap?['locations']) ??
          _asList(floorMap?['points']) ??
          _asList(floorMap?['markers']) ??
          _asList(floorMap?['poi']) ??
          _asList(floorMap?['map_points']) ??
          <dynamic>[];

      final pois = <MapPoiData>[
        ...poisFromGroups,
        ...poiCandidates.map<MapPoiData>(
          (poiRaw) => _mapPoiItem(
            poiRaw,
            mapWidth: mapWidth,
            mapHeight: mapHeight,
          ),
        ),
      ];

      return MapFloorData(
        label: floorLabel,
        mapImageUrl: mapImageUrl,
        mapWidth: mapWidth,
        mapHeight: mapHeight,
        points: pois,
      );
    }).toList();
  }

  List<MapLegendData> _parseLegend(dynamic res) {
    final root = _asMap(res);
    final candidates = _asList(root?['mapLegend']) ??
        _asList(root?['legend']) ??
        _asList(root?['map_legend']) ??
        <dynamic>[];

    return candidates.map<MapLegendData>((raw) {
      final item = _asMap(raw);
      final groupName = _asString(
            item?['groupName'] ?? item?['group'] ?? item?['name'],
          ) ??
          'Location';
      final colorHex = _asString(item?['color']);
      return MapLegendData(groupName: groupName, colorHex: colorHex);
    }).toList();
  }

  MapPoiData _mapPoiItem(
    dynamic poiRaw, {
    String? groupName,
    double? mapWidth,
    double? mapHeight,
  }) {
    final poiMap = _asMap(poiRaw);
    final title = _asString(
          poiMap?['title'] ??
              poiMap?['name'] ??
              poiMap?['location_name'] ??
              poiMap?['label'],
        ) ??
        'Location';
    final subtitle = _asString(
          poiMap?['desc'] ??
              poiMap?['description'] ??
              poiMap?['sub_title'] ??
              poiMap?['subtitle'] ??
              poiMap?['details'],
        ) ??
        '';
    final type = _asString(
          poiMap?['type'] ?? poiMap?['category'] ?? poiMap?['location_type'],
        ) ??
        'other';
    final iconName = _asString(poiMap?['icon']);
    final colorHex = _asString(poiMap?['color']);

    final x = _normalizeCoordinate(
      poiMap?['x'] ??
          poiMap?['position_x'] ??
          poiMap?['left'] ??
          poiMap?['coord_x'] ??
          poiMap?['x_percent'] ??
          poiMap?['xPercent'],
      axisExtent: mapWidth,
    );
    final y = _normalizeCoordinate(
      poiMap?['y'] ??
          poiMap?['position_y'] ??
          poiMap?['top'] ??
          poiMap?['coord_y'] ??
          poiMap?['y_percent'] ??
          poiMap?['yPercent'],
      axisExtent: mapHeight,
    );

    return MapPoiData(
      title: title,
      subtitle: subtitle,
      type: type,
      groupName: groupName,
      iconName: iconName,
      colorHex: colorHex,
      markerX: x,
      markerY: y,
    );
  }

  Map<String, dynamic>? _asMap(dynamic input) {
    if (input is Map<String, dynamic>) return input;
    if (input is Map) {
      return input.map((key, value) => MapEntry(key.toString(), value));
    }
    return null;
  }

  List<dynamic>? _asList(dynamic input) {
    if (input is List) return input;
    return null;
  }

  String? _asString(dynamic input) {
    if (input == null) return null;
    final value = input.toString().trim();
    if (value.isEmpty) return null;
    return value;
  }

  num? _asNum(dynamic input) {
    if (input is num) return input;
    if (input is String) return num.tryParse(input);
    return null;
  }

  double? _asPositiveDouble(dynamic input) {
    final value = _asNum(input)?.toDouble();
    if (value == null || value <= 0) return null;
    return value;
  }

  double? _parseCoordinateValue(dynamic input) {
    if (input is num) return input.toDouble();
    if (input is! String) return null;
    final cleaned = input.trim().replaceAll('%', '');
    if (cleaned.isEmpty) return null;
    return double.tryParse(cleaned);
  }

  double? _normalizeCoordinate(dynamic rawValue, {double? axisExtent}) {
    final value = _parseCoordinateValue(rawValue);
    if (value == null || value.isNaN || value.isInfinite) return null;
    if (value < 0) return 0.0;
    if (value <= 1) return value.clamp(0.0, 1.0);
    if (value <= 100) return (value / 100).clamp(0.0, 1.0);
    if (axisExtent != null && axisExtent > 0) {
      return (value / axisExtent).clamp(0.0, 1.0);
    }
    return null;
  }
}

class MapFloorData {
  MapFloorData({
    required this.label,
    required this.mapImageUrl,
    required this.mapWidth,
    required this.mapHeight,
    required this.points,
  });

  final String label;
  final String? mapImageUrl;
  final double? mapWidth;
  final double? mapHeight;
  final List<MapPoiData> points;
}

class MapPoiData {
  MapPoiData({
    required this.title,
    required this.subtitle,
    required this.type,
    required this.groupName,
    required this.iconName,
    required this.colorHex,
    required this.markerX,
    required this.markerY,
  });

  final String title;
  final String subtitle;
  final String type;
  final String? groupName;
  final String? iconName;
  final String? colorHex;
  final double? markerX;
  final double? markerY;
}

class MapLegendData {
  MapLegendData({
    required this.groupName,
    required this.colorHex,
  });

  final String groupName;
  final String? colorHex;
}
