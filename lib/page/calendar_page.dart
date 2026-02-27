import 'package:flutter/material.dart';
import '../logic/cycle_calculator.dart';
import '../services/cycle_service.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final PageController _pageController =
      PageController(initialPage: DateTime.now().month - 1);

  final CycleService _cycleService = CycleService();

  DateTime? periodEnd;
  bool isPeriodActive = false;
  int cycleLength = 28;

  // ⭐ เพิ่มตัวนี้
  int periodLength = 7;

  // Edit mode and selection
  bool _editMode = false;
  DateTime? _selectedDay;

  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    _loadCycleData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isFirstLoad) {
      _loadCycleData();
    }

    _isFirstLoad = false;
  }

  Future<void> _loadCycleData() async {
    final end = await _cycleService.getPeriodEnd();
    final status = await _cycleService.getPeriodStatus();
    final length = await _cycleService.getPeriodLength();

    setState(() {
      periodEnd = end;
      isPeriodActive = status;
      periodLength = length; // ⭐ โหลดค่าจริง
    });

    await _checkAutoStop();
  }

  Future<void> _checkAutoStop() async {
    if (!isPeriodActive || periodEnd == null) return;

    final handled = await _cycleService.getAutoStopHandled();
    if (handled) return;

    final start = periodEnd!.subtract(Duration(days: periodLength - 1));
    final difference = DateTime.now().difference(start).inDays;

    // ⭐ ใช้ periodLength แทน fix 7
    if (difference >= periodLength) {
      _showAutoStopDialog();
    }
  }

  void _showAutoStopDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Still on your period?"),
          content: Text(
              "It has been $periodLength days. Are you still on your period?"),
          actions: [
            TextButton(
              onPressed: () async {
                // User confirms it ended. Keep stored periodEnd as-is
                await _cycleService.endPeriod(endDate: periodEnd);
                await _cycleService.setAutoStopHandled(true);
                if (mounted) {
                  Navigator.pop(dialogContext);
                  await _loadCycleData();
                }
              },
              child: const Text("No, it ended"),
            ),
            TextButton(
              onPressed: () {
                // Still ongoing: extend periodEnd to today
                () async {
                  await _cycleService.startPeriod(startDate: DateTime.now());
                  await _cycleService.setAutoStopHandled(true);
                  if (mounted) {
                    Navigator.pop(dialogContext);
                    await _loadCycleData();
                  }
                }();
              },
              child: const Text("Yes, still ongoing"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final calculator = CycleCalculator(
      periodEnd: periodEnd,
      isPeriodActive: isPeriodActive,
      cycleLength: cycleLength,
      periodLength: periodLength, // ⭐ ส่งเข้า calculator
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.close, color: Colors.pink),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton(
              onPressed: () async {
                if (!_editMode) {
                  setState(() {
                    _editMode = true;
                  });
                } else {
                  if (_selectedDay != null) {
                    await _cycleService.startPeriod(startDate: _selectedDay);
                    await _loadCycleData();
                  }
                  setState(() {
                    _editMode = false;
                    _selectedDay = null;
                  });
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: !_editMode
                    ? const Color(0xFF8A008A)
                    : Colors.white,
                side: _editMode
                    ? const BorderSide(color: Color(0xFF8A008A))
                    : null,
              ),
              child: Text(
                !_editMode ? 'Edit' : 'Save',
                style: TextStyle(
                  color: !_editMode ? Colors.white : const Color(0xFF8A008A),
                ),
              ),
            ),
          )
        ],
      ),
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        controller: _pageController,
        itemCount: 12,
        itemBuilder: (context, index) {
          final month = index + 1;
          final year = DateTime.now().year;
          return _buildMonth(year, month, calculator);
        },
      ),
    );
  }

  Widget _buildMonth(
      int year, int month, CycleCalculator calculator) {
    final daysInMonth = DateUtils.getDaysInMonth(year, month);
    final monthName = "${_monthNames[month - 1]} $year";

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            color: const Color(0xFFFDC3D6),
            child: Center(
              child: Text(
                monthName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1,
              ),
              itemCount: daysInMonth,
              itemBuilder: (context, index) {
                final day = DateTime(year, month, index + 1);
                return GestureDetector(
                  onTap: () {
                    if (_editMode) {
                      setState(() {
                        _selectedDay = day;
                      });
                    }
                  },
                  child: _buildDay(day, calculator),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDay(
      DateTime day, CycleCalculator calculator) {
    final isToday =
        DateUtils.isSameDay(day, DateTime.now());
    final isPeriod =
        calculator.isPastPeriod(day);
    final isPredicted =
        calculator.isPredictedNextPeriod(day);

    final isSelected = _selectedDay != null && DateUtils.isSameDay(day, _selectedDay!);

    Color? bgColor;
    Color textColor = Colors.black;
    Border? border;

    if (isPeriod) {
      bgColor = const Color(0xFFF48DA5);
      textColor = Colors.white;
    } else if (isPredicted) {
      bgColor = const Color(0xFF44BAB1);
      textColor = Colors.white;
    } else if (isSelected) {
      border = Border.all(
        color: const Color(0xFF8A008A),
        width: 2,
      );
    } else if (isToday) {
      border = Border.all(
        color: const Color(0xFFA57ACD),
        width: 2,
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isToday)
          const Text(
            "Today",
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
          ),
        Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
            border: border,
          ),
          child: Text(
            "${day.day}",
            style: TextStyle(color: textColor),
          ),
        ),
      ],
    );
  }

  final List<String> _monthNames = const [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
}