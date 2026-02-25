class HomeCycleInfo {
  final bool isPeriod;
  final int? currentDay;
  final int? daysUntilNext;

  HomeCycleInfo({
    required this.isPeriod,
    this.currentDay,
    this.daysUntilNext,
  });
}