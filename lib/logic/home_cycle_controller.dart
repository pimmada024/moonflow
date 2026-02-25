import '../services/cycle_service.dart';

class HomeCycleController {
  final CycleService _cycleService = CycleService();

  bool isPeriod = false;
  DateTime? periodStart;
  final int cycleLength = 28;

  Future<void> loadData() async {
    isPeriod = await _cycleService.getPeriodStatus();
    periodStart = await _cycleService.getPeriodStart();
  }

  Future<void> togglePeriod(bool value) async {
    isPeriod = value;

    if (value) {
      await _cycleService.startPeriod();
    } else {
      await _cycleService.endPeriod();
    }

    await loadData();
  }

  int calculatePeriodDay() {
    if (periodStart == null) return 1;
    final today = DateTime.now();
    return today.difference(periodStart!).inDays + 1;
  }

  int calculateCycleDay() {
    if (periodStart == null) return 1;

    final today = DateTime.now();
    final daysSinceStart =
        today.difference(periodStart!).inDays;

    return (daysSinceStart % cycleLength) + 1;
  }

  int calculateDaysUntilNextPeriod() {
    if (periodStart == null) return cycleLength;

    final today = DateTime.now();
    final daysSinceStart =
        today.difference(periodStart!).inDays;

    return cycleLength - (daysSinceStart % cycleLength);
  }

  // ⭐ ใหม่: ใช้โชว์ Ovulation in X days
  int daysUntilOvulation() {
    final cycleDay = calculateCycleDay();
    const ovulationDay = 14;

    final diff = ovulationDay - cycleDay;
    return diff > 0 ? diff : 0;
  }

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

  // ⭐ ใหม่: ใช้แสดง Hormone label
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
