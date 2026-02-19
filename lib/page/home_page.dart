import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isPeriod = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFBFDDE4),
            Color(0xFFCFA8E6),
          ],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 28),
              _header(),
              const SizedBox(height: 42),
              _cycleSection(),
              const SizedBox(height: 28),
              _periodCard(),
              const SizedBox(height: 18),
              _insightCard(),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Column(
      children: [
        const Text(
          "JANUARY",
          style: TextStyle(
            fontSize: 16,
            letterSpacing: 2,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            _DayItem(day: "Mon", date: "5", active: false),
            SizedBox(width: 40),
            _DayItem(day: "Tue", date: "6", active: true),
            SizedBox(width: 40),
            _DayItem(day: "Wed", date: "7", active: false),
          ],
        ),
      ],
    );
  }

  Widget _cycleSection() {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          height: 460,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white,
                Color(0xFFFFF8FB),
                Color(0xFFFDE7F0),
              ],
            ),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(700),
            ),
          ),
        ),
        Column(
          children: [
            const SizedBox(height: 130),
            const Text("Ovulation period in"),
            const SizedBox(height: 14),
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: "10",
                    style: TextStyle(
                      fontSize: 52,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF9B3C88),
                    ),
                  ),
                  TextSpan(
                    text: " days",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "High chance of getting pregnant",
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                SizedBox(width: 4),
                Icon(Icons.info_outline, size: 13, color: Colors.black38),
              ],
            ),
            const SizedBox(height: 30),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 65, vertical: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF48DA5), Color(0xFFF06C8C)],
                ),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Text(
                "Record the menstrual cycle",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _periodCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFF9E9EE),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          children: [
            const Icon(Icons.water_drop,
                color: Color(0xFFF06C8C)),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("My period has arrived.",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  SizedBox(height: 4),
                  Text(
                    "Tap to mark the first day of your period",
                    style:
                        TextStyle(fontSize: 11, color: Colors.black54),
                  ),
                ],
              ),
            ),
            Switch(
              value: isPeriod,
              activeColor: const Color(0xFFF06C8C),
              onChanged: (val) {
                setState(() => isPeriod = val);
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _insightCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
        decoration: BoxDecoration(
          color: const Color(0xFFFCEBF1),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: const [
                Row(
                  children: [
                    Icon(Icons.wb_sunny,
                        color: Color(0xFFFFB300)),
                    SizedBox(width: 8),
                    Text("Today’s Insight",
                        style: TextStyle(
                            fontWeight: FontWeight.w600)),
                  ],
                ),
                Text("Estrogen increase",
                    style: TextStyle(
                        color: Color(0xFFE84A70),
                        fontSize: 12)),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: 240,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEBD7E1),
                borderRadius:
                    BorderRadius.circular(18),
              ),
              child: const Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text("Follicular Phase",
                      style: TextStyle(
                          color: Color(0xFF9B3C88),
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 6),
                  Text(
                    "You may feel more energetic today\nA good day to start new plans",
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DayItem extends StatelessWidget {
  final String day;
  final String date;
  final bool active;

  const _DayItem({
    required this.day,
    required this.date,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(day,
            style: const TextStyle(
                fontSize: 13,
                color: Colors.black54)),
        const SizedBox(height: 6),
        Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active
                ? Colors.white
                : Colors.transparent,
          ),
          child: Text(
            date,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: active
                  ? Colors.black
                  : const Color(0xFF1EBEA5),
            ),
          ),
        ),
      ],
    );
  }
}
