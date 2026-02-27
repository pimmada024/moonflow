import 'package:shared_preferences/shared_preferences.dart';
import '../models/home_cycle_info.dart';

/// Service responsible for storing and reading cycle/period data.
class CycleService {
  static const int defaultCycleLength = 28;

  // ===============================
  // START PERIOD
  // ===============================
  Future<void> startPeriod({DateTime? startDate}) async {
    final prefs = await SharedPreferences.getInstance();
    final date = startDate ?? DateTime.now();

    await prefs.setInt('periodStart', date.millisecondsSinceEpoch);
    await prefs.setBool('isPeriodActive', true);
  }

  // ===============================
  // END PERIOD
  // ===============================
  Future<void> endPeriod({DateTime? endDate}) async {
    final prefs = await SharedPreferences.getInstance();
    final date = endDate ?? DateTime.now();

    await prefs.setInt('periodEnd', date.millisecondsSinceEpoch);
    await prefs.setBool('isPeriodActive', false);

    // Calculate and persist actual period length when possible
    final startMillis = prefs.getInt('periodStart');
    if (startMillis != null) {
      final start = DateTime.fromMillisecondsSinceEpoch(startMillis);
      final length = date.difference(start).inDays + 1;
      await prefs.setInt('periodLength', length);
    }
  }

  // ===============================
  // GETTERS
  // ===============================
  Future<bool> getPeriodStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isPeriodActive') ?? false;
  }

  Future<DateTime?> getPeriodStart() async {
    final prefs = await SharedPreferences.getInstance();
    final millis = prefs.getInt('periodStart');
    if (millis == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(millis);
  }

  Future<DateTime?> getPeriodEnd() async {
    final prefs = await SharedPreferences.getInstance();
    final millis = prefs.getInt('periodEnd');
    if (millis == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(millis);
  }

  /// Returns the stored period length (number of days).
  /// Uses SharedPreferences key 'periodLength'. Defaults to 7 when not set.
  Future<int> getPeriodLength() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('periodLength') ?? 7;
  }

  // ===============================
  // HOME LOGIC
  // ===============================
  Future<HomeCycleInfo> getHomeCycleInfo() async {
    final prefs = await SharedPreferences.getInstance();

    final isPeriod = prefs.getBool('isPeriodActive') ?? false;
    final endMillis = prefs.getInt('periodEnd');

    if (endMillis == null) {
      return HomeCycleInfo(isPeriod: false);
    }

    final endDate = DateTime.fromMillisecondsSinceEpoch(endMillis);

    if (isPeriod) {
      final startMillis = prefs.getInt('periodStart');
      if (startMillis == null) return HomeCycleInfo(isPeriod: true);

      final startDate = DateTime.fromMillisecondsSinceEpoch(startMillis);
      final currentDay = DateTime.now().difference(startDate).inDays + 1;

      return HomeCycleInfo(isPeriod: true, currentDay: currentDay);
    } else {
      final nextPeriod = endDate.add(const Duration(days: defaultCycleLength));
      int daysLeft = nextPeriod.difference(DateTime.now()).inDays;
      if (daysLeft < 0) daysLeft = 0;

      return HomeCycleInfo(isPeriod: false, daysUntilNext: daysLeft);
    }
  }
}