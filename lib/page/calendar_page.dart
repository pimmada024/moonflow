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

  DateTime? periodStart;
  DateTime? periodEnd;
  bool isPeriodActive = false;
  int cycleLength = 28;

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
    final start = await _cycleService.getPeriodStart();
    final end = await _cycleService.getPeriodEnd();
    final status = await _cycleService.getPeriodStatus();

    setState(() {
      periodStart = start;
      periodEnd = end;
      isPeriodActive = status;
    });

    await _checkAutoStop(); // ⭐ ตรวจครบ 7 วัน
  }

  // ⭐ ตรวจว่าครบ 7 วันหรือยัง
  Future<void> _checkAutoStop() async {
    if (!isPeriodActive || periodStart == null) return;

    final difference =
        DateTime.now().difference(periodStart!).inDays;

    if (difference >= 7) {
      _showAutoStopDialog();
    }
  }

  // ⭐ Dialog ถามผู้ใช้
  void _showAutoStopDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Still on your period?"),
          content: const Text(
              "It has been 7 days. Are you still on your period?"),
          actions: [
            TextButton(
              onPressed: () async {
                await _cycleService.endPeriod();
                if (mounted) {
                  Navigator.pop(dialogContext);
                  await _loadCycleData();
                }
              },
              child: const Text("No, it ended"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
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
      periodStart: periodStart,
      periodEnd: periodEnd,
      isPeriodActive: isPeriodActive,
      cycleLength: cycleLength,
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

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          color: const Color(0xFFE8A5AD),
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
              final day =
                  DateTime(year, month, index + 1);
              return _buildDay(day, calculator);
            },
          ),
        )
      ],
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

    Color? bgColor;
    Color textColor = Colors.black;
    Border? border;

    if (isPeriod) {
      bgColor = const Color(0xFFF48DA5);
      textColor = Colors.white;
    } else if (isPredicted) {
      bgColor = const Color(0xFF44BAB1);
      textColor = Colors.white;
    } else if (isToday) {
      border = Border.all(
        color: const Color(0xFFF48DA5),
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