import 'package:shared_preferences/shared_preferences.dart';
import '../models/home_cycle_info.dart';

class CycleService {
  static const int cycleLength = 28;

  // เริ่มมีประจำเดือน
  // หากผู้ใช้เลือกวันเอง จะส่งมาเป็น startDate
  Future<void> startPeriod({DateTime? startDate}) async {
    final prefs = await SharedPreferences.getInstance();

    final date = startDate ?? DateTime.now();
    await prefs.setInt(
      'periodStart',
      date.millisecondsSinceEpoch,
    );

    await prefs.setBool('isPeriodActive', true);
  }

  // หมดประจำเดือน
  Future<void> endPeriod() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(
      'periodEnd',
      DateTime.now().millisecondsSinceEpoch,
    );

    await prefs.setBool('isPeriodActive', false);
  }

  // โหลดสถานะ
  Future<bool> getPeriodStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isPeriodActive') ?? false;
  }

  // โหลดวันเริ่ม
  Future<DateTime?> getPeriodStart() async {
    final prefs = await SharedPreferences.getInstance();
    final millis = prefs.getInt('periodStart');
    if (millis == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(millis);
  }

  // โหลดวันสิ้นสุด
  Future<DateTime?> getPeriodEnd() async {
    final prefs = await SharedPreferences.getInstance();
    final millis = prefs.getInt('periodEnd');
    if (millis == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(millis);
  }

  // ⭐ Logic สำหรับหน้า Home (แยกจาก UI แล้ว)
  Future<HomeCycleInfo> getHomeCycleInfo() async {
    final prefs = await SharedPreferences.getInstance();

    final isPeriod =
        prefs.getBool('isPeriodActive') ?? false;
    final millis = prefs.getInt('periodStart');

    if (millis == null) {
      return HomeCycleInfo(isPeriod: false);
    }

    final startDate =
        DateTime.fromMillisecondsSinceEpoch(millis);

    final diff =
        DateTime.now().difference(startDate).inDays;

    if (isPeriod) {
      return HomeCycleInfo(
        isPeriod: true,
        currentDay: diff + 1,
      );
    } else {
      final nextPeriod =
          startDate.add(const Duration(days: cycleLength));

      int daysLeft =
          nextPeriod.difference(DateTime.now()).inDays;

      if (daysLeft < 0) daysLeft = 0;

      return HomeCycleInfo(
        isPeriod: false,
        daysUntilNext: daysLeft,
      );
    }
  }
}