class CycleCalculator {
  final DateTime? periodStart;
  final DateTime? periodEnd;
  final bool isPeriodActive;
  final int cycleLength;
  final int periodLength;

  const CycleCalculator({
    this.periodStart,
    this.periodEnd,
    this.isPeriodActive = false,
    this.cycleLength = 28,
    this.periodLength = 7,
  });

  // ===============================
  // CURRENT / PAST PERIOD
  // ===============================
  bool isPastPeriod(DateTime day) {
    if (periodStart == null) return false;

    final start =
        DateTime(periodStart!.year, periodStart!.month, periodStart!.day);

    DateTime end;

    if (periodEnd != null) {
      end = DateTime(periodEnd!.year, periodEnd!.month, periodEnd!.day);
    } else if (isPeriodActive) {
      final now = DateTime.now();
      end = DateTime(now.year, now.month, now.day);
    } else {
      end = start.add(Duration(days: periodLength - 1));
    }

    return !day.isBefore(start) && !day.isAfter(end);
  }

  // ===============================
  // PREDICT NEXT PERIOD
  // ===============================
  bool isPredictedNextPeriod(DateTime day) {
    if (periodEnd == null) return false;

    DateTime nextEnd = periodEnd!;

    while (nextEnd.isBefore(DateTime.now())) {
      nextEnd = nextEnd.add(Duration(days: cycleLength));
    }

    final nextStart = nextEnd.subtract(Duration(days: periodLength - 1));

    return !day.isBefore(nextStart) && !day.isAfter(nextEnd);
  }
}