// A lightweight calculator used by the UI to determine
// whether a given day is within the current period or
// a predicted next period window.

class CycleCalculator {
  final DateTime? periodStart;
  final DateTime? periodEnd;
  final bool isPeriodActive;
  final int cycleLength;

  const CycleCalculator({
    this.periodStart,
    this.periodEnd,
    this.isPeriodActive = false,
    this.cycleLength = 28,
  });

  // Returns true when [day] is within the recorded/active period.
  bool isPastPeriod(DateTime day) {
    if (periodStart == null) return false;

    final start = DateTime(periodStart!.year, periodStart!.month, periodStart!.day);

    DateTime end;
    if (periodEnd != null) {
      end = DateTime(periodEnd!.year, periodEnd!.month, periodEnd!.day);
    } else if (isPeriodActive) {
      final now = DateTime.now();
      end = DateTime(now.year, now.month, now.day);
    } else {
      // default period length assumed to be 5 days
      end = start.add(const Duration(days: 4));
    }

    return !day.isBefore(start) && !day.isAfter(end);
  }

  // Predicts the next period window based on the last known start
  // and `cycleLength`. Returns true when [day] falls into that
  // predicted window (assumed 5-day duration).
  bool isPredictedNextPeriod(DateTime day) {
    if (periodStart == null) return false;

    DateTime nextStart = DateTime(periodStart!.year, periodStart!.month, periodStart!.day);

    // advance until nextStart is on/after today
    while (nextStart.isBefore(DateTime.now())) {
      nextStart = nextStart.add(Duration(days: cycleLength));
    }

    final nextEnd = nextStart.add(const Duration(days: 4));

    return !day.isBefore(nextStart) && !day.isAfter(nextEnd);
  }
}