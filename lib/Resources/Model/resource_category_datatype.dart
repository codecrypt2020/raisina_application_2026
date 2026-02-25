class ResourceCategory {
  const ResourceCategory({
    required this.label,
    required this.count,
    this.isSelected = false,
    this.index = 0,
  });

  final String label;
  final int count;
  final bool isSelected;
  final int index;
}
