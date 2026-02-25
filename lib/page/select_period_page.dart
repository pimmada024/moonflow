import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../services/cycle_service.dart';

class SelectPeriodScreen extends StatefulWidget {
  const SelectPeriodScreen({super.key});

  @override
  State<SelectPeriodScreen> createState() => _SelectPeriodScreenState();
}

class _SelectPeriodScreenState extends State<SelectPeriodScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();

  final CycleService _cycleService = CycleService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9A3A3),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                const SizedBox(height: 40),

                const Text(
                  "Date of last\nmenstrual period",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    color: Color(0xFF8A008A),
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 30),

                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        )
                      ],
                    ),
                    child: TableCalendar(
                      firstDay: DateTime(2000),
                      lastDay: DateTime(2100),
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) {
                        return _selectedDay != null &&
                            isSameDay(_selectedDay!, day);
                      },
                      onDaySelected:
                          (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      },
                      headerStyle: const HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                      ),
                      calendarStyle: const CalendarStyle(
                        selectedDecoration: BoxDecoration(
                          color: Color(0xFFE88A8A),
                          shape: BoxShape.circle,
                        ),
                        todayDecoration: BoxDecoration(
                          color: Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40),
                  child: GestureDetector(
                    onTap: () async {
                      await _cycleService.startPeriod(
                          startDate: DateTime.now());
                      if (!mounted) return;
                      Navigator.pushReplacementNamed(
                          context, '/home');
                    },
                    child: Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets.symmetric(
                              vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(30),
                      ),
                      child: const Center(
                        child: Text(
                          "I can not remember",
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40),
                  child: GestureDetector(
                    onTap: () async {
                      final date =
                          _selectedDay ?? DateTime.now();
                      await _cycleService
                          .startPeriod(startDate: date);
                      if (!mounted) return;
                      Navigator.pushReplacementNamed(
                          context, '/home');
                    },
                    child: Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets.symmetric(
                              vertical: 16),
                      decoration: BoxDecoration(
                        gradient:
                            const LinearGradient(
                          colors: [
                            Color(0xFF8A008A),
                            Color(0xFFB100B1),
                          ],
                        ),
                        borderRadius:
                            BorderRadius.circular(30),
                      ),
                      child: const Center(
                        child: Text(
                          "READY",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    _dot(true),
                    _dot(false),
                    _dot(false),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dot(bool active) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color:
            active ? Colors.grey[700] : Colors.grey[400],
        shape: BoxShape.circle,
      ),
    );
  }
}