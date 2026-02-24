import 'package:attendee_app/Maps/provider/map_data.dart';
import 'package:attendee_app/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum _MapMode { floorPlan, campusOverview }

enum _PoiType { restroom, entryExit, sessionHall, lounge }

class _PoiItem {
  const _PoiItem({
    required this.title,
    required this.subtitle,
    required this.type,
    required this.groupLabel,
    required this.icon,
    this.color,
    required this.markerOffset,
  });

  final String title;
  final String subtitle;
  final _PoiType type;
  final String groupLabel;
  final IconData icon;
  final Color? color;
  final Offset markerOffset;
}

class _LegendEntry {
  const _LegendEntry({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;
}

class _FloorData {
  const _FloorData({
    required this.label,
    this.mapImageUrl,
    this.mapSize,
    required this.items,
  });

  final String label;
  final String? mapImageUrl;
  final Size? mapSize;
  final List<_PoiItem> items;
}

class MapsView extends StatefulWidget {
  const MapsView({super.key});

  @override
  State<MapsView> createState() => _MapsViewState();
}

class _MapsViewState extends State<MapsView> {
  _MapMode _mode = _MapMode.floorPlan;
  int _selectedFloor = 0;
  int? _selectedPoi;

  final List<_FloorData> _floors = const [
    _FloorData(
      label: '1st floor',
      items: [
        _PoiItem(
          title: 'sessions',
          subtitle: 'round table, speaker session',
          type: _PoiType.sessionHall,
          groupLabel: 'SESSION HALLS',
          icon: Icons.campaign_rounded,
          color: Color(0xFFC29A3A),
          markerOffset: Offset(0.42, 0.42),
        ),
        _PoiItem(
          title: 'Rest',
          subtitle: 'rest area',
          type: _PoiType.lounge,
          groupLabel: 'LOUNGES',
          icon: Icons.weekend_rounded,
          color: Color(0xFF4CA84D),
          markerOffset: Offset(0.56, 0.48),
        ),
        _PoiItem(
          title: 'Entry / Exit',
          subtitle: 'entry exit gate',
          type: _PoiType.entryExit,
          groupLabel: 'ENTRY/EXITS',
          icon: Icons.sensor_door_rounded,
          color: Color(0xFF21AFC9),
          markerOffset: Offset(0.70, 0.60),
        ),
        _PoiItem(
          title: 'panel',
          subtitle: 'restroom',
          type: _PoiType.restroom,
          groupLabel: 'RESTROOMS',
          icon: Icons.wc_rounded,
          color: Color(0xFF657184),
          markerOffset: Offset(0.78, 0.26),
        ),
      ],
    ),
    _FloorData(
      label: 'ground floor',
      items: [
        _PoiItem(
          title: 'entry exit gate',
          subtitle: 'ground floor',
          type: _PoiType.entryExit,
          groupLabel: 'ENTRY/EXITS',
          icon: Icons.sensor_door_rounded,
          color: Color(0xFF21AFC9),
          markerOffset: Offset(0.35, 0.52),
        ),
        _PoiItem(
          title: 'Restrooms',
          subtitle: 'ground floor',
          type: _PoiType.restroom,
          groupLabel: 'RESTROOMS',
          icon: Icons.wc_rounded,
          color: Color(0xFF657184),
          markerOffset: Offset(0.60, 0.36),
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MapData>(context);
    final sourceFloors = _buildFloorsFromApi(provider.floors);
    final floors = sourceFloors.isEmpty ? _floors : sourceFloors;
    final floorIndex = _selectedFloor >= floors.length ? 0 : _selectedFloor;
    final floor = floors[floorIndex];
    final mapItems = floor.items;
    final listItems = _mode == _MapMode.campusOverview
        ? floors.expand((f) => f.items).toList()
        : mapItems;
    final legends = _buildLegendFromApi(provider.legend, listItems);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF8FAFD), Color(0xFFF2F6FC)],
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        children: [
          _VenueCard(
            mode: _mode,
            floors: floors,
            selectedFloor: floorIndex,
            listItems: listItems,
            onModeChanged: (mode) {
              setState(() {
                _mode = mode;
                _selectedPoi = null;
              });
            },
            onFloorChanged: (index) {
              setState(() {
                _selectedFloor = index;
                _selectedPoi = null;
              });
            },
            onPoiSelected: (item) {
              final markerIndex = mapItems.indexOf(item);
              setState(
                  () => _selectedPoi = markerIndex >= 0 ? markerIndex : null);
            },
          ),
          const SizedBox(height: 14),
          _MapCanvas(
            floorLabel: floor.label,
            points: mapItems,
            mapImageUrl: floor.mapImageUrl,
            mapSize: floor.mapSize,
            legends: legends,
            selectedPoi: _selectedPoi,
            onPoiTap: (index) => setState(() => _selectedPoi = index),
          ),
        ],
      ),
    );
  }

  List<_FloorData> _buildFloorsFromApi(List<MapFloorData> apiFloors) {
    if (apiFloors.isEmpty) return const [];

    return apiFloors.map<_FloorData>((floor) {
      final items = floor.points
          .where((point) => point.markerX != null && point.markerY != null)
          .map<_PoiItem>((point) {
        return _PoiItem(
          title: point.title,
          subtitle: point.subtitle,
          type: _mapPoiType(point.type),
          groupLabel: _groupLabelFromApi(point),
          icon: _iconFromApi(point),
          color: _parseHexColor(point.colorHex),
          markerOffset: Offset(point.markerX!, point.markerY!),
        );
      }).toList();
      final mapSize = floor.mapWidth != null && floor.mapHeight != null
          ? Size(floor.mapWidth!, floor.mapHeight!)
          : null;

      return _FloorData(
        label: floor.label,
        mapImageUrl: floor.mapImageUrl,
        mapSize: mapSize,
        items: items,
      );
    }).toList();
  }

  _PoiType _mapPoiType(String value) {
    final lower = value.toLowerCase();
    if (lower.contains('restroom') ||
        lower.contains('toilet') ||
        lower == 'wc') {
      return _PoiType.restroom;
    }
    if (lower.contains('entry') ||
        lower.contains('exit') ||
        lower.contains('gate')) {
      return _PoiType.entryExit;
    }
    if (lower.contains('session') ||
        lower.contains('hall') ||
        lower.contains('speaker')) {
      return _PoiType.sessionHall;
    }
    if (lower.contains('lounge') || lower.contains('rest')) {
      return _PoiType.lounge;
    }
    return _PoiType.lounge;
  }

  String _groupLabelFromApi(MapPoiData point) {
    final raw = point.groupName?.trim();
    if (raw != null && raw.isNotEmpty) return raw.toUpperCase();
    return _sectionTitleFromType(_mapPoiType(point.type));
  }

  String _sectionTitleFromType(_PoiType type) {
    switch (type) {
      case _PoiType.sessionHall:
        return 'SESSION HALLS';
      case _PoiType.lounge:
        return 'LOUNGES';
      case _PoiType.entryExit:
        return 'ENTRY/EXITS';
      case _PoiType.restroom:
        return 'RESTROOMS';
    }
  }

  List<_LegendEntry> _buildLegendFromApi(
    List<MapLegendData> apiLegend,
    List<_PoiItem> currentFloorItems,
  ) {
    if (apiLegend.isNotEmpty) {
      return apiLegend
          .map(
            (entry) => _LegendEntry(
              label: entry.groupName,
              color: _parseHexColor(entry.colorHex) ?? AppColors.textMuted,
            ),
          )
          .toList();
    }

    final unique = <String, _LegendEntry>{};
    for (final item in currentFloorItems) {
      unique[item.groupLabel] = _LegendEntry(
        label: item.groupLabel,
        color: item.color ?? _typeColor(item.type),
      );
    }
    return unique.values.toList();
  }

  Color? _parseHexColor(String? hex) {
    if (hex == null || hex.trim().isEmpty) return null;
    final normalized = hex.replaceFirst('#', '').trim();
    if (normalized.length != 6) return null;
    final value = int.tryParse(normalized, radix: 16);
    if (value == null) return null;
    return Color(0xFF000000 | value);
  }

  IconData _iconFromApi(MapPoiData point) {
    final lower = (point.iconName ?? point.type).toLowerCase();
    if (lower.contains('door') ||
        lower.contains('entry') ||
        lower.contains('exit')) {
      return Icons.sensor_door_rounded;
    }
    if (lower.contains('wc') ||
        lower.contains('restroom') ||
        lower.contains('toilet')) {
      return Icons.wc_rounded;
    }
    if (lower.contains('session') ||
        lower.contains('hall') ||
        lower.contains('speaker')) {
      return Icons.campaign_rounded;
    }
    if (lower.contains('lounge') ||
        lower.contains('sofa') ||
        lower.contains('rest')) {
      return Icons.weekend_rounded;
    }
    return Icons.location_on_rounded;
  }
}

class _VenueCard extends StatelessWidget {
  const _VenueCard({
    required this.mode,
    required this.floors,
    required this.selectedFloor,
    required this.listItems,
    required this.onModeChanged,
    required this.onFloorChanged,
    required this.onPoiSelected,
  });

  final _MapMode mode;
  final List<_FloorData> floors;
  final int selectedFloor;
  final List<_PoiItem> listItems;
  final ValueChanged<_MapMode> onModeChanged;
  final ValueChanged<int> onFloorChanged;
  final ValueChanged<_PoiItem> onPoiSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.navyElevated,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.navySurface),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Venue Locations',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ModeChip(
                  label: 'Floor Plan',
                  selected: mode == _MapMode.floorPlan,
                  onTap: () => onModeChanged(_MapMode.floorPlan),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ModeChip(
                  label: 'Campus Overview',
                  selected: mode == _MapMode.campusOverview,
                  onTap: () => onModeChanged(_MapMode.campusOverview),
                ),
              ),
            ],
          ),
          if (mode == _MapMode.floorPlan) ...[
            const SizedBox(height: 12),
            ...List.generate(floors.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _FloorRow(
                  label: floors[index].label,
                  selected: index == selectedFloor,
                  onTap: () => onFloorChanged(index),
                ),
              );
            }),
          ] else
            const SizedBox(height: 12),
          if (listItems.isNotEmpty) ...[
            const SizedBox(height: 10),
            _PoiList(items: listItems, onPoiSelected: onPoiSelected),
          ]
        ],
      ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  const _ModeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        alignment: Alignment.center,
        height: 36,
        decoration: BoxDecoration(
          color: selected ? AppColors.goldDim : AppColors.navyMid,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AppColors.gold : AppColors.navySurface,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: selected ? AppColors.gold : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _FloorRow extends StatelessWidget {
  const _FloorRow({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.goldDim : AppColors.navyMid,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AppColors.gold : AppColors.navySurface,
          ),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: selected ? AppColors.gold : AppColors.textSecondary,
              ),
            ),
            const Spacer(),
            Icon(
              selected ? Icons.remove : Icons.chevron_right,
              size: 18,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}

class _PoiList extends StatelessWidget {
  const _PoiList({
    required this.items,
    required this.onPoiSelected,
  });

  final List<_PoiItem> items;
  final ValueChanged<_PoiItem> onPoiSelected;

  @override
  Widget build(BuildContext context) {
    final grouped = <String, List<_PoiItem>>{};
    for (final item in items) {
      grouped.putIfAbsent(item.groupLabel, () => []).add(item);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: grouped.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.key,
                style: const TextStyle(
                  fontSize: 11,
                  letterSpacing: 1.1,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 8),
              ...List.generate(entry.value.length, (index) {
                final item = entry.value[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _PoiTile(
                    item: item,
                    onTap: () => onPoiSelected(item),
                  ),
                );
              })
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _PoiTile extends StatelessWidget {
  const _PoiTile({
    required this.item,
    required this.onTap,
  });

  final _PoiItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = item.color ?? _typeColor(item.type);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(item.icon, size: 16, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  item.subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MapCanvas extends StatelessWidget {
  const _MapCanvas({
    required this.floorLabel,
    required this.points,
    required this.mapImageUrl,
    required this.mapSize,
    required this.legends,
    required this.selectedPoi,
    required this.onPoiTap,
  });

  final String floorLabel;
  final List<_PoiItem> points;
  final String? mapImageUrl;
  final Size? mapSize;
  final List<_LegendEntry> legends;
  final int? selectedPoi;
  final ValueChanged<int> onPoiTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.navyElevated,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.navySurface),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.map_outlined, size: 16, color: AppColors.gold),
              const SizedBox(width: 6),
              Text(
                floorLabel,
                style: const TextStyle(
                  color: AppColors.gold,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              const _ZoomButton(icon: Icons.remove),
              const SizedBox(width: 8),
              const _ZoomButton(icon: Icons.add),
            ],
          ),
          const SizedBox(height: 10),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  const markerDiameter = 28.0;
                  final canvasSize = Size(
                    constraints.maxWidth,
                    constraints.maxHeight,
                  );
                  final imageRect = _imageRectForCanvas(canvasSize, mapSize);
                  return Stack(
                    children: [
                      const Positioned.fill(child: _FallbackMapBackground()),
                      if (mapImageUrl != null && mapImageUrl!.isNotEmpty)
                        Positioned.fromRect(
                          rect: imageRect,
                          child: Image.network(
                            mapImageUrl!,
                            fit: BoxFit.fill,
                            errorBuilder: (_, __, ___) =>
                                const _FallbackMapBackground(),
                          ),
                        )
                      else
                        Positioned.fromRect(
                          rect: imageRect,
                          child: const _FallbackMapBackground(),
                        ),
                      ...List.generate(points.length, (index) {
                        final point = points[index];
                        final selected = selectedPoi == index;
                        return Positioned(
                          left: imageRect.left +
                              (point.markerOffset.dx * imageRect.width),
                          top: imageRect.top +
                              (point.markerOffset.dy * imageRect.height),
                          child: Transform.translate(
                            offset: const Offset(
                                -markerDiameter / 2, -markerDiameter / 2),
                            child: GestureDetector(
                              onTap: () => onPoiTap(index),
                              child: _MarkerBubble(
                                icon: point.icon,
                                color: point.color ?? _typeColor(point.type),
                                label: selected ? point.title : null,
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          _LegendCard(entries: legends),
        ],
      ),
    );
  }

  Rect _imageRectForCanvas(Size canvasSize, Size? sourceSize) {
    if (sourceSize == null || sourceSize.width <= 0 || sourceSize.height <= 0) {
      return Offset.zero & canvasSize;
    }
    final fitted = applyBoxFit(BoxFit.contain, sourceSize, canvasSize);
    final destination = fitted.destination;
    final dx = (canvasSize.width - destination.width) / 2;
    final dy = (canvasSize.height - destination.height) / 2;
    return Rect.fromLTWH(dx, dy, destination.width, destination.height);
  }
}

class _FallbackMapBackground extends StatelessWidget {
  const _FallbackMapBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFDDE6D8), Color(0xFFD5C8AF)],
        ),
      ),
    );
  }
}

class _ZoomButton extends StatelessWidget {
  const _ZoomButton({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: AppColors.navyMid,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.navySurface),
      ),
      child: Icon(icon, size: 16, color: AppColors.textMuted),
    );
  }
}

class _MarkerBubble extends StatelessWidget {
  const _MarkerBubble({
    required this.icon,
    required this.color,
    this.label,
  });

  final IconData icon;
  final Color color;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.navySurface),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        if (label != null) ...[
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.navyElevated,
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: AppColors.navySurface),
            ),
            child: Text(
              label!,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _LegendCard extends StatelessWidget {
  const _LegendCard({
    required this.entries,
  });

  final List<_LegendEntry> entries;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
      decoration: BoxDecoration(
        color: AppColors.navyMid,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.navySurface),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'LEGEND',
            style: TextStyle(
              fontSize: 10,
              letterSpacing: 1.0,
              fontWeight: FontWeight.w800,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 6),
          ...entries.map(
            (entry) => _LegendRow(label: entry.label, color: entry.color),
          ),
        ],
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 7),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

Color _typeColor(_PoiType type) {
  switch (type) {
    case _PoiType.restroom:
      return const Color(0xFF657184);
    case _PoiType.entryExit:
      return const Color(0xFF21AFC9);
    case _PoiType.sessionHall:
      return const Color(0xFFC29A3A);
    case _PoiType.lounge:
      return const Color(0xFF4CA84D);
  }
}
