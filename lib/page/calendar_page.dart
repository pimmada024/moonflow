import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();

  DateTime? periodStart;
  DateTime? periodEnd;
  bool isPeriodActive = true;

  int cycleLength = 28;

  @override
  void initState() {
    super.initState();
    periodStart = DateTime.now().subtract(const Duration(days: 2));
  }

  bool isPastPeriod(DateTime day) {
    if (periodStart == null) return false;

    if (isPeriodActive) {
      return day.isAfter(periodStart!.subtract(const Duration(days: 1))) &&
          day.isBefore(DateTime.now().add(const Duration(days: 1)));
    } else {
      return day.isAfter(periodStart!.subtract(const Duration(days: 1))) &&
          day.isBefore(periodEnd!.add(const Duration(days: 1)));
    }
  }

  bool isPredictedNextPeriod(DateTime day) {
    if (periodStart == null) return false;
    final next = periodStart!.add(Duration(days: cycleLength));
    return day.year == next.year &&
        day.month == next.month &&
        day.day == next.day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDE7EC),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            _header("JANUARY"),

            Expanded(
              child: TableCalendar(
                firstDay: DateTime(2000),
                lastDay: DateTime(2100),
                focusedDay: _focusedDay,
                headerVisible: false,
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, _) {
                    if (isPastPeriod(day)) {
                      return _pinkFilled(day);
                    }

                    if (isPredictedNextPeriod(day)) {
                      return _greenFilled(day);
                    }

                    if (isSameDay(day, DateTime.now())) {
                      return _pinkBorder(day);
                    }

                    return null;
                  },
                ),
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF06C8C),
              ),
              onPressed: () {
                setState(() {
                  isPeriodActive = false;
                  periodEnd = DateTime.now();
                });
              },
              child: const Text("Stop Period"),
            ),

            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget _pinkFilled(DateTime day) {
    return Center(
      child: Container(
        width: 38,
        height: 38,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Color(0xFFF48DA5),
          shape: BoxShape.circle,
        ),
        child: Text(
          "${day.day}",
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _pinkBorder(DateTime day) {
    return Center(
      child: Container(
        width: 38,
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFF48DA5), width: 2),
        ),
        child: Text(
          "${day.day}",
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  Widget _greenFilled(DateTime day) {
    return Center(
      child: Container(
        width: 38,
        height: 38,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Color(0xFF44BAB1),
          shape: BoxShape.circle,
        ),
        child: Text(
          "${day.day}",
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _header(String month) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18),
      color: const Color(0xFFE8A5AD),
      child: Center(
        child: Text(
          month,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
