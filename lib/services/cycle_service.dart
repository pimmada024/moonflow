import 'package:shared_preferences/shared_preferences.dart';
import '../models/home_cycle_info.dart';

/// Service responsible for storing and reading cycle/period data.
class CycleService {
  static const int defaultCycleLength = 28;
  static const String _kPeriodEnd = 'periodEnd';
  static const String _kPeriodStart = 'periodStart';
  static const String _kIsPeriodActive = 'isPeriodActive';
  static const String _kPeriodLength = 'periodLength';
  static const String _kAutoStopHandled = 'periodAutoStopHandled';
  static const String _kCycleLength = 'cycleLength';

  // ===============================
  // START PERIOD
  // ===============================
  /// Start period. If [startDate] is provided it represents the selected
  /// periodEnd (the LAST day). When called without a date (toggle from UI),
  /// we mark period active and store periodEnd as today.
  Future<void> startPeriod({DateTime? startDate}) async {
  final prefs = await SharedPreferences.getInstance();
  final date = startDate ?? DateTime.now();

  // ✅ ON = เก็บแค่ periodStart
  await prefs.setInt(_kPeriodStart, date.millisecondsSinceEpoch);

  // ❌ ห้ามแตะ periodEnd ตรงนี้
  // await prefs.setInt(_kPeriodEnd, date.millisecondsSinceEpoch); ← ลบออก

  await prefs.setBool(_kIsPeriodActive, true);

  await prefs.setBool(_kAutoStopHandled, false);
}

  // ===============================
  // END PERIOD
  // ===============================
  Future<void> endPeriod({DateTime? endDate}) async {
    final prefs = await SharedPreferences.getInstance();
    final date = endDate ?? DateTime.now();

    // Save periodEnd and mark period as not active. Keep periodLength unchanged.
    await prefs.setInt(_kPeriodEnd, date.millisecondsSinceEpoch);
    await prefs.setBool(_kIsPeriodActive, false);

    // If we have a stored periodStart, compute and persist the explicit period length
    final startMillis = prefs.getInt(_kPeriodStart);
    if (startMillis != null) {
      final start = DateTime.fromMillisecondsSinceEpoch(startMillis);
      final length = date.difference(start).inDays + 1;
      if (length > 0) {
        await prefs.setInt(_kPeriodLength, length);
      }
    }
  }

  // ===============================
  // GETTERS
  // ===============================
  Future<bool> getPeriodStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kIsPeriodActive) ?? false;
  }

  Future<DateTime?> getPeriodStart() async {
    final prefs = await SharedPreferences.getInstance();
    // Prefer an explicitly stored periodStart. Fallback to computing from
    // periodEnd and periodLength for backwards compatibility.
    final startMillis = prefs.getInt(_kPeriodStart);
    if (startMillis != null) {
      return DateTime.fromMillisecondsSinceEpoch(startMillis);
    }

    final endMillis = prefs.getInt(_kPeriodEnd);
    if (endMillis == null) return null;

    final periodLength = prefs.getInt(_kPeriodLength) ?? 7;
    final end = DateTime.fromMillisecondsSinceEpoch(endMillis);
    final start = end.subtract(Duration(days: periodLength - 1));
    return start;
  }

  Future<DateTime?> getPeriodEnd() async {
    final prefs = await SharedPreferences.getInstance();
    final millis = prefs.getInt(_kPeriodEnd);
    if (millis == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(millis);
  }

  /// Returns the stored period length (number of days).
  /// Uses SharedPreferences key 'periodLength'. Defaults to 7 when not set.
  Future<int> getPeriodLength() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_kPeriodLength) ?? 7;
  }

  Future<bool> getAutoStopHandled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kAutoStopHandled) ?? false;
  }

  Future<void> setAutoStopHandled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kAutoStopHandled, value);
  }

  // ===============================
  // HOME LOGIC
  // ===============================
  Future<HomeCycleInfo> getHomeCycleInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final isPeriod = prefs.getBool(_kIsPeriodActive) ?? false;
    final endMillis = prefs.getInt(_kPeriodEnd);

    if (endMillis == null) {
      return HomeCycleInfo(isPeriod: false);
    }

    final endDate = DateTime.fromMillisecondsSinceEpoch(endMillis);

    // Use stored cycle length if available, otherwise fallback to default
    final cycleLen = prefs.getInt(_kCycleLength) ?? defaultCycleLength;
    final periodLen = prefs.getInt(_kPeriodLength) ?? 7;

    if (isPeriod) {
      // Prefer explicit stored periodStart when available
      final startMillis = prefs.getInt(_kPeriodStart);
      DateTime startDate;
      if (startMillis != null) {
        startDate = DateTime.fromMillisecondsSinceEpoch(startMillis);
      } else {
        startDate = endDate.subtract(Duration(days: periodLen - 1));
      }

      final currentDay = DateTime.now().difference(startDate).inDays + 1;
      return HomeCycleInfo(isPeriod: true, currentDay: currentDay);
    } else {
      DateTime nextPeriod = endDate.add(Duration(days: cycleLen));
      final today = DateTime.now();
      final todayOnly = DateTime(today.year, today.month, today.day);

      // If nextPeriod is before today, keep adding cycleLen until it's in the future
      while (nextPeriod.isBefore(todayOnly)) {
        nextPeriod = nextPeriod.add(Duration(days: cycleLen));
      }

      int daysLeft = nextPeriod.difference(todayOnly).inDays;
      if (daysLeft < 0) daysLeft = 0;

      return HomeCycleInfo(isPeriod: false, daysUntilNext: daysLeft);
    }
  }
}