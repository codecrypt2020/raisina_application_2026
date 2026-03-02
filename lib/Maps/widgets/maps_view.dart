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
  int _mapResetToken = 0;
  bool _isMapGestureActive = false;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _mapSectionKey = GlobalKey();

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
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToMapSection() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final mapContext = _mapSectionKey.currentContext;
      if (mapContext == null) return;
      Scrollable.ensureVisible(
        mapContext,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
        alignment: 0.05,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MapData>(context);
    final sourceFloors = _buildFloorsFromApi(provider.floors);
    final floors = sourceFloors;
    if (floors.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.isDark(context)
                ? const [Color(0xFF111A2B), Color(0xFF0C1220)]
                : const [Color(0xFFF8FAFD), Color(0xFFF2F6FC)],
          ),
        ),
        child: RefreshIndicator(
          onRefresh: () async {
            await provider.fetchMapsApi();
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 20),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.elevatedOf(context),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderOf(context)),
                ),
                child: Text(
                  'Map data not available',
                  style: TextStyle(
                    color: AppColors.textPrimaryOf(context),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    final floorIndex = _selectedFloor >= floors.length ? 0 : _selectedFloor;
    final floor = floors[floorIndex];
    final mapItems = floor.items;
    final listItems = _mode == _MapMode.campusOverview
        ? floors.expand((f) => f.items).toList()
        : mapItems;
    final legends = _buildLegendFromApi(provider.legend, listItems);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: AppColors.isDark(context)
              ? const [Color(0xFF111A2B), Color(0xFF0C1220)]
              : const [Color(0xFFF8FAFD), Color(0xFFF2F6FC)],
        ),
      ),
      child: RefreshIndicator(
        onRefresh: () async {
          await provider.fetchMapsApi();
        },
        child: ListView(
          controller: _scrollController,
          physics: _isMapGestureActive
              ? const NeverScrollableScrollPhysics()
              : const AlwaysScrollableScrollPhysics(),
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
                  if (mode != _MapMode.floorPlan) {
                    _isMapGestureActive = false;
                  }
                });
              },
              onFloorChanged: (index) {
                setState(() {
                  if (_selectedFloor != index) {
                    _mapResetToken++;
                  }
                  _selectedFloor = index;
                  _selectedPoi = null;
                });
              },
              onPoiSelected: (item) {
                int targetFloorIndex =
                    floors.indexWhere((f) => f.items.contains(item));
                if (targetFloorIndex < 0) {
                  targetFloorIndex = floors.indexWhere((f) => f.items.any(
                        (poi) =>
                            poi.title == item.title &&
                            poi.markerOffset == item.markerOffset,
                      ));
                }
                if (targetFloorIndex < 0) return;

                final targetItems = floors[targetFloorIndex].items;
                int targetPoiIndex = targetItems.indexOf(item);
                if (targetPoiIndex < 0) {
                  targetPoiIndex = targetItems.indexWhere((poi) =>
                      poi.title == item.title &&
                      poi.markerOffset == item.markerOffset);
                }
                if (targetPoiIndex < 0) return;

                setState(() {
                  _mode = _MapMode.floorPlan;
                  _selectedFloor = targetFloorIndex;
                  _selectedPoi = targetPoiIndex;
                  _mapResetToken++;
                });
                _scrollToMapSection();
              },
            ),
            if (_mode == _MapMode.floorPlan) ...[
              const SizedBox(height: 14),
              Container(
                key: _mapSectionKey,
                child: _MapCanvas(
                  floorLabel: floor.label,
                  points: mapItems,
                  mapImageUrl: floor.mapImageUrl,
                  mapSize: floor.mapSize,
                  legends: legends,
                  selectedPoi: _selectedPoi,
                  resetZoomToken: _mapResetToken,
                  onMapInteractionChanged: (isActive) {
                    if (_isMapGestureActive == isActive) return;
                    setState(() {
                      _isMapGestureActive = isActive;
                    });
                  },
                  onPoiTap: (index) =>
                      setState(() => _selectedPoi = index >= 0 ? index : null),
                ),
              ),
            ],
          ],
        ),
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
    final lower = [
      point.iconName,
      point.type,
      point.groupName,
      point.title,
      point.subtitle,
    ].whereType<String>().join(' ').toLowerCase();

    if (lower.contains('info') || lower.contains('information')) {
      return Icons.info_outline_rounded;
    }
    if (lower.contains('medical') ||
        lower.contains('first aid') ||
        lower.contains('clinic') ||
        lower.contains('doctor') ||
        lower.contains('health')) {
      return Icons.medical_services_rounded;
    }
    if (lower.contains('parking') ||
        lower.contains('car') ||
        lower.contains('vehicle')) {
      return Icons.directions_car_rounded;
    }
    if (lower.contains('dining') ||
        lower.contains('food') ||
        lower.contains('restaurant') ||
        lower.contains('buffet') ||
        lower.contains('lunch') ||
        lower.contains('dinner')) {
      return Icons.restaurant_rounded;
    }
    if (lower.contains('lounge') ||
        lower.contains('cafe') ||
        lower.contains('coffee')) {
      return Icons.local_cafe_rounded;
    }
    if (lower.contains('door') ||
        lower.contains('entry') ||
        lower.contains('exit') ||
        lower.contains('gate')) {
      return Icons.sensor_door_rounded;
    }
    if (lower.contains('wc') ||
        lower.contains('restroom') ||
        lower.contains('toilet')) {
      return Icons.wc_rounded;
    }
    if (lower.contains('session') ||
        lower.contains('hall') ||
        lower.contains('speaker') ||
        lower.contains('speaking')) {
      return Icons.mic_rounded;
    }
    return Icons.location_on_rounded;
  }
}

class _VenueCard extends StatefulWidget {
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
  State<_VenueCard> createState() => _VenueCardState();
}

class _VenueCardState extends State<_VenueCard> {
  int? _expandedFloorIndex;

  @override
  void initState() {
    super.initState();
    _expandedFloorIndex = widget.selectedFloor;
  }

  @override
  void didUpdateWidget(covariant _VenueCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.mode == _MapMode.campusOverview) return;
    if (widget.selectedFloor != oldWidget.selectedFloor &&
        _expandedFloorIndex != null) {
      _expandedFloorIndex = widget.selectedFloor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final panelBg = AppColors.elevatedOf(context);
    final panelBorder = AppColors.borderOf(context);
    final titleColor = AppColors.textPrimaryOf(context);
    final bool showPoiList = widget.mode == _MapMode.campusOverview
        ? true
        : _expandedFloorIndex != null;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: panelBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: panelBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Venue Locations',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 22,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ModeChip(
                  label: 'Floor Plan',
                  selected: widget.mode == _MapMode.floorPlan,
                  onTap: () => widget.onModeChanged(_MapMode.floorPlan),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ModeChip(
                  label: 'Campus Overview',
                  selected: widget.mode == _MapMode.campusOverview,
                  onTap: () => widget.onModeChanged(_MapMode.campusOverview),
                ),
              ),
            ],
          ),
          if (widget.mode == _MapMode.floorPlan) ...[
            const SizedBox(height: 12),
            ...List.generate(widget.floors.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _FloorRow(
                  label: widget.floors[index].label,
                  selected: index == _expandedFloorIndex,
                  onTap: () {
                    if (_expandedFloorIndex == index) {
                      setState(() => _expandedFloorIndex = null);
                      return;
                    }
                    setState(() => _expandedFloorIndex = index);
                    widget.onFloorChanged(index);
                  },
                ),
              );
            }),
          ] else
            const SizedBox(height: 12),
          if (showPoiList && widget.listItems.isNotEmpty) ...[
            const SizedBox(height: 10),
            _PoiList(
              items: widget.listItems,
              onPoiSelected: widget.onPoiSelected,
            ),
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
    final chipBg = AppColors.surfaceSoftOf(context);
    final chipBorder = AppColors.borderOf(context);
    final chipText = AppColors.textSecondaryOf(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        alignment: Alignment.center,
        height: 36,
        decoration: BoxDecoration(
          color: selected ? AppColors.goldDim : chipBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AppColors.gold : chipBorder,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: selected ? AppColors.gold : chipText,
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
    final chipBg = AppColors.surfaceSoftOf(context);
    final chipBorder = AppColors.borderOf(context);
    final chipText = AppColors.textSecondaryOf(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.goldDim : chipBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AppColors.gold : chipBorder,
          ),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? AppColors.gold : chipText,
              ),
            ),
            const Spacer(),
            Icon(
              selected ? Icons.remove : Icons.chevron_right,
              size: 18,
              color: AppColors.textMutedOf(context),
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
    final muted = AppColors.textMutedOf(context);
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
                style: TextStyle(
                  fontSize: 11,
                  letterSpacing: 1.1,
                  fontWeight: FontWeight.w800,
                  color: muted,
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
    final titleColor = AppColors.textPrimaryOf(context);
    final subtitleColor = AppColors.textSecondaryOf(context);
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
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: titleColor,
                  ),
                ),
                Text(
                  item.subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: subtitleColor,
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

class _MapCanvas extends StatefulWidget {
  const _MapCanvas({
    required this.floorLabel,
    required this.points,
    required this.mapImageUrl,
    required this.mapSize,
    required this.legends,
    required this.selectedPoi,
    required this.resetZoomToken,
    required this.onMapInteractionChanged,
    required this.onPoiTap,
  });

  final String floorLabel;
  final List<_PoiItem> points;
  final String? mapImageUrl;
  final Size? mapSize;
  final List<_LegendEntry> legends;
  final int? selectedPoi;
  final int resetZoomToken;
  final ValueChanged<bool> onMapInteractionChanged;
  final ValueChanged<int> onPoiTap;

  @override
  State<_MapCanvas> createState() => _MapCanvasState();
}

class _MapCanvasState extends State<_MapCanvas> {
  final TransformationController _transformController =
      TransformationController();
  static const double _minScale = 1.0;
  static const double _maxScale = 4.0;
  Size _viewportSize = Size.zero;
  int _activePointerCount = 0;

  @override
  void didUpdateWidget(covariant _MapCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.resetZoomToken != oldWidget.resetZoomToken) {
      _transformController.value = Matrix4.identity();
      _activePointerCount = 0;
      widget.onMapInteractionChanged(false);
    }
  }

  @override
  void dispose() {
    widget.onMapInteractionChanged(false);
    _transformController.dispose();
    super.dispose();
  }

  bool get _isZoomed => _transformController.value.getMaxScaleOnAxis() > 1.001;

  void _updateParentScrollLockFromPointers() {
    widget.onMapInteractionChanged(_activePointerCount > 0 && _isZoomed);
  }

  void _zoomBy(double step) {
    if (_viewportSize == Size.zero) return;
    final currentScale = _transformController.value.getMaxScaleOnAxis();
    final targetScale = (currentScale + step).clamp(_minScale, _maxScale);
    if ((targetScale - currentScale).abs() < 0.001) return;

    final scaleFactor = targetScale / currentScale;
    final matrix = _transformController.value.clone();
    final focalPoint =
        Offset(_viewportSize.width / 2, _viewportSize.height / 2);
    matrix.translate(focalPoint.dx, focalPoint.dy);
    matrix.scale(scaleFactor);
    matrix.translate(-focalPoint.dx, -focalPoint.dy);
    _transformController.value = _clampMatrixToViewport(matrix);
  }

  Matrix4 _clampMatrixToViewport(Matrix4 input) {
    if (_viewportSize == Size.zero) return input;
    final matrix = input.clone();

    final scale =
        matrix.getMaxScaleOnAxis().clamp(_minScale, _maxScale).toDouble();
    matrix.storage[0] = scale;
    matrix.storage[5] = scale;
    matrix.storage[10] = 1.0;

    final minX = _viewportSize.width - (_viewportSize.width * scale);
    final minY = _viewportSize.height - (_viewportSize.height * scale);
    matrix.storage[12] = matrix.storage[12].clamp(minX, 0.0).toDouble();
    matrix.storage[13] = matrix.storage[13].clamp(minY, 0.0).toDouble();

    return matrix;
  }

  @override
  Widget build(BuildContext context) {
    final _PoiItem? selectedItem = (widget.selectedPoi != null &&
            widget.selectedPoi! >= 0 &&
            widget.selectedPoi! < widget.points.length)
        ? widget.points[widget.selectedPoi!]
        : null;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.elevatedOf(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderOf(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.map_outlined, size: 16, color: AppColors.gold),
              const SizedBox(width: 6),
              Text(
                widget.floorLabel,
                style: const TextStyle(
                  color: AppColors.gold,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              _ZoomButton(
                icon: Icons.remove,
                onTap: () => _zoomBy(-0.25),
              ),
              const SizedBox(width: 8),
              _ZoomButton(
                icon: Icons.add,
                onTap: () => _zoomBy(0.25),
              ),
            ],
          ),
          const SizedBox(height: 10),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  _viewportSize =
                      Size(constraints.maxWidth, constraints.maxHeight);
                  return Listener(
                    onPointerDown: (_) {
                      _activePointerCount++;
                      _updateParentScrollLockFromPointers();
                    },
                    onPointerUp: (_) {
                      _activePointerCount =
                          (_activePointerCount - 1).clamp(0, 99);
                      _updateParentScrollLockFromPointers();
                    },
                    onPointerCancel: (_) {
                      _activePointerCount =
                          (_activePointerCount - 1).clamp(0, 99);
                      _updateParentScrollLockFromPointers();
                    },
                    child: InteractiveViewer(
                      transformationController: _transformController,
                      minScale: _minScale,
                      maxScale: _maxScale,
                      onInteractionEnd: (_) {
                        _transformController.value =
                            _clampMatrixToViewport(_transformController.value);
                        _updateParentScrollLockFromPointers();
                      },
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          const markerDiameter = 28.0;
                          final canvasSize = Size(
                            constraints.maxWidth,
                            constraints.maxHeight,
                          );
                          final imageRect =
                              _imageRectForCanvas(canvasSize, widget.mapSize);
                          return Stack(
                            children: [
                              const Positioned.fill(
                                  child: _FallbackMapBackground()),
                              if (widget.mapImageUrl != null &&
                                  widget.mapImageUrl!.isNotEmpty)
                                Positioned.fromRect(
                                  rect: imageRect,
                                  child: Image.network(
                                    widget.mapImageUrl!,
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
                              ...List.generate(widget.points.length, (index) {
                                final point = widget.points[index];
                                final isSelected = widget.selectedPoi == index;
                                return Positioned(
                                  left: imageRect.left +
                                      (point.markerOffset.dx * imageRect.width),
                                  top: imageRect.top +
                                      (point.markerOffset.dy *
                                          imageRect.height),
                                  child: Transform.translate(
                                    offset: const Offset(-markerDiameter / 2,
                                        -markerDiameter / 2),
                                    child: GestureDetector(
                                      onTap: () => widget.onPoiTap(index),
                                      child: _MarkerBubble(
                                        icon: point.icon,
                                        color: point.color ??
                                            _typeColor(point.type),
                                        isSelected: isSelected,
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
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: selectedItem == null
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _SelectedPoiChip(
                      key: ValueKey<String>(selectedItem.title),
                      item: selectedItem,
                      onClose: () => widget.onPoiTap(-1),
                    ),
                  ),
          ),
          _LegendCard(entries: widget.legends),
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
  const _ZoomButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final controlBg = AppColors.surfaceSoftOf(context);
    final controlBorder = AppColors.borderOf(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Ink(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: controlBg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: controlBorder),
          ),
          child: Icon(icon, size: 16, color: AppColors.textMutedOf(context)),
        ),
      ),
    );
  }
}

class _MarkerBubble extends StatelessWidget {
  const _MarkerBubble({
    required this.icon,
    required this.color,
    this.isSelected = false,
  });

  static const Color _selectedGold = Color(0xFFC29A3A);
  static const Color _selectedGoldFill = Color(0x33C29A3A);

  final IconData icon;
  final Color color;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final Color bgColor =
        isSelected ? _selectedGoldFill : AppColors.elevatedOf(context);
    final Color borderColor =
        isSelected ? _selectedGold : AppColors.borderOf(context);
    final Color iconColor = isSelected ? _selectedGold : color;
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: isSelected ? 1.8 : 1.0),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: _selectedGold.withOpacity(0.45),
                  blurRadius: 10,
                  spreadRadius: 0.8,
                ),
              ]
            : null,
      ),
      child: Icon(icon, color: iconColor, size: 16),
    );
  }
}

class _SelectedPoiChip extends StatelessWidget {
  const _SelectedPoiChip({
    super.key,
    required this.item,
    required this.onClose,
  });

  final _PoiItem item;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final Color accent = item.color ?? _typeColor(item.type);
    final panelBg = AppColors.surfaceSoftOf(context);
    final panelBorder = AppColors.borderOf(context);
    final titleColor = AppColors.textPrimaryOf(context);
    final subtitleColor = AppColors.textSecondaryOf(context);
    final mutedColor = AppColors.textMutedOf(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
      decoration: BoxDecoration(
        color: panelBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: panelBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.16),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(item.icon, color: accent, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: titleColor,
                  ),
                ),
                if (item.subtitle.trim().isNotEmpty)
                  Text(
                    item.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: subtitleColor,
                    ),
                  ),
              ],
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onClose,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: EdgeInsets.all(4),
                child: Icon(
                  Icons.close_rounded,
                  size: 16,
                  color: mutedColor,
                ),
              ),
            ),
          ),
        ],
      ),
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
    final panelBg = AppColors.surfaceSoftOf(context);
    final panelBorder = AppColors.borderOf(context);
    final muted = AppColors.textMutedOf(context);
    return Container(
      width: 150,
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
      decoration: BoxDecoration(
        color: panelBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: panelBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'LEGEND',
            style: TextStyle(
              fontSize: 10,
              letterSpacing: 1.0,
              fontWeight: FontWeight.w800,
              color: muted,
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
    final textColor = AppColors.textSecondaryOf(context);
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
            style: TextStyle(
              fontSize: 12,
              color: textColor,
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
