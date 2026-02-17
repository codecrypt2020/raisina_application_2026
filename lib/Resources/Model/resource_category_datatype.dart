class ResourceCategory {
  const ResourceCategory({
    required this.label,
    required this.count,
    this.isSelected = false,
  });

  final String label;
  final int count;
  final bool isSelected;
}
