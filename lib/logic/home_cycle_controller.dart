import '../services/cycle_service.dart';

class HomeCycleController {
  final CycleService _cycleService = CycleService();

  bool isPeriod = false;
  DateTime? periodEnd; // เก็บวันสุดท้าย
  DateTime? periodStart; // คำนวณย้อนหลัง
  final int cycleLength = 28;
  int periodLength = 7;

  // ===============================
  // LOAD DATA
  // ===============================
  Future<void> loadData() async {
    isPeriod = await _cycleService.getPeriodStatus();
    periodEnd = await _cycleService.getPeriodEnd();
    periodStart = await _cycleService.getPeriodStart();
    periodLength = await _cycleService.getPeriodLength();
  }

  // ===============================
  // TOGGLE PERIOD STATUS
  // ===============================
  Future<void> togglePeriod(bool value) async {
    isPeriod = value;

    if (value) {
      // mark period start as today
      await _cycleService.startPeriod(startDate: DateTime.now());
    } else {
      // mark period end as today and compute length
      await _cycleService.endPeriod(endDate: DateTime.now());
    }

    await loadData();
  }

  // ===============================
  // PERIOD DAY (1–7)
  // ===============================
  int calculatePeriodDay() {
    if (periodStart == null) return 1;

    final today = DateTime.now();
    return today.difference(periodStart!).inDays + 1;
  }

  // ===============================
  // CURRENT CYCLE DAY (1–28)
  // ===============================
  int calculateCycleDay() {
    if (periodEnd == null) return 1;

    final today = DateTime.now();
    final daysSinceEnd = today.difference(periodEnd!).inDays;

    return (daysSinceEnd % cycleLength) + 1;
  }

  // ===============================
  // DAYS UNTIL NEXT PERIOD
  // ===============================
  int calculateDaysUntilNextPeriod() {
    if (periodEnd == null) return cycleLength;

    final today = DateTime.now();
    final nextPeriodDate = periodEnd!.add(Duration(days: cycleLength));
    final daysRemaining = nextPeriodDate.difference(DateTime(
      today.year,
      today.month,
      today.day,
    )).inDays;
    return daysRemaining < 0 ? 0 : daysRemaining;
  }

  // ===============================
  // DAYS UNTIL OVULATION
  // ===============================
  int daysUntilOvulation() {
    final cycleDay = calculateCycleDay();
    const ovulationDay = 14;

    if (cycleDay <= ovulationDay) {
      return ovulationDay - cycleDay;
    } else {
      return (cycleLength - cycleDay) + ovulationDay;
    }
  }

  // ===============================
  // PHASE
  // ===============================
  String getPhase() {
    final day = calculateCycleDay();

    if (day >= 1 && day <= 7) {
      return "Menstrual";
    } else if (day >= 8 && day <= 13) {
      return "Follicular";
    } else if (day == 14) {
      return "Ovulation";
    } else {
      return "Luteal";
    }
  }

  // ===============================
  // HORMONE LABEL
  // ===============================
  String getHormoneStatus() {
    final phase = getPhase();

    switch (phase) {
      case "Menstrual":
        return "Estrogen low";
      case "Follicular":
        return "Estrogen increase";
      case "Ovulation":
        return "Estrogen peak";
      case "Luteal":
        return "Progesterone dominant";
      default:
        return "";
    }
  }

  // ===============================
  // TODAY'S INSIGHT
  // ===============================
  String getInsight() {
    final phase = getPhase();

    switch (phase) {
      case "Menstrual":
        return "Your body needs more rest today.\nStay hydrated and take it easy 🩸";
      case "Follicular":
        return "You may feel more energetic today.\nA good day to start new plans 🌱";
      case "Ovulation":
        return "You may feel confident and social today.\nA great time for communication ✨";
      case "Luteal":
        return "You may feel more sensitive today.\nTake time to rest and be kind to yourself 💗";
      default:
        return "";
    }
  }
}