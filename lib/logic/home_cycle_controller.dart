import '../services/cycle_service.dart';

class HomeCycleController {
  final CycleService _cycleService = CycleService();

  bool isPeriod = false;
  DateTime? periodStart;
  final int cycleLength = 28;

  // ===============================
  // LOAD DATA
  // ===============================
  Future<void> loadData() async {
    isPeriod = await _cycleService.getPeriodStatus();
    periodStart = await _cycleService.getPeriodStart();
  }

  // ===============================
  // TOGGLE PERIOD STATUS
  // ===============================
  Future<void> togglePeriod(bool value) async {
    isPeriod = value;

    if (value) {
      await _cycleService.startPeriod();
    } else {
      await _cycleService.endPeriod();
    }

    await loadData();
  }

  // ===============================
  // PERIOD DAY (Day 1–5)
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
    if (periodStart == null) return 1;

    final today = DateTime.now();
    final daysSinceStart =
        today.difference(periodStart!).inDays;

    return (daysSinceStart % cycleLength) + 1;
  }

  // ===============================
  // DAYS UNTIL NEXT PERIOD
  // ===============================
  int calculateDaysUntilNextPeriod() {
    if (periodStart == null) return cycleLength;

    final today = DateTime.now();
    final daysSinceStart =
        today.difference(periodStart!).inDays;

    final remaining =
        cycleLength - (daysSinceStart % cycleLength);

    return remaining == cycleLength ? 0 : remaining;
  }

  // ===============================
  // DAYS UNTIL OVULATION (แก้ให้ถูกต้องแล้ว)
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

    if (day >= 1 && day <= 5) {
      return "Menstrual";
    } else if (day >= 6 && day <= 13) {
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