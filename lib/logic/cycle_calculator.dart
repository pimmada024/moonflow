class CycleCalculator {
  final DateTime? periodEnd; // stored model: last day of menstruation
  final bool isPeriodActive;
  final int cycleLength;
  final int periodLength;

  const CycleCalculator({
    this.periodEnd,
    this.isPeriodActive = false,
    this.cycleLength = 28,
    this.periodLength = 7,
  });

  DateTime? get periodStart {
    if (periodEnd == null) return null;
    return DateTime(
      periodEnd!.year,
      periodEnd!.month,
      periodEnd!.day,
    ).subtract(Duration(days: periodLength - 1));
  }

  // ===============================
  // CURRENT / PAST PERIOD
  // ===============================
  bool isPastPeriod(DateTime day) {
    final start = periodStart;
    final end = periodEnd;
    if (start == null || end == null) return false;

    return !day.isBefore(start) && !day.isAfter(end);
  }

  // ===============================
  // PREDICT NEXT PERIOD
  // ===============================
  bool isPredictedNextPeriod(DateTime day) {
    if (periodEnd == null) return false;

    DateTime nextEnd = periodEnd!;

    // move forward until we are at or after today
    while (nextEnd.isBefore(DateTime.now())) {
      nextEnd = nextEnd.add(Duration(days: cycleLength));
    }

    final nextStart = nextEnd.subtract(Duration(days: periodLength - 1));
    return !day.isBefore(nextStart) && !day.isAfter(nextEnd);
  }
}