import 'package:flutter/material.dart';
import '../logic/home_cycle_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeCycleController _controller =
      HomeCycleController();

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _controller.loadData();
    setState(() {});
  }

  Future<void> _handleSwitch(bool value) async {
    await _controller.togglePeriod(value);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final month = _monthNames[now.month - 1];
    final actualDay = now.day;

    final ovulationDays =
        _controller.daysUntilOvulation();
    final phase = _controller.getPhase();
    final hormone =
        _controller.getHormoneStatus();
    final insight =
        _controller.getInsight();

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
        child: Column(
          children: [

            // ===== HEADER =====
            const SizedBox(height: 20),
            Text(
              month.toUpperCase(),
              style: const TextStyle(
                fontSize: 18,
                letterSpacing: 2,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            // Date circle
            CircleAvatar(
              radius: 26,
              backgroundColor: Colors.white,
              child: Text(
                "$actualDay",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ===== MAIN WHITE CURVE SECTION =====
            Expanded(
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(
                        horizontal: 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(
                    top: Radius.circular(60),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [

                      const SizedBox(height: 30),

                      // Ovulation Text
                      Text(
                        "Ovulation period in",
                        style: TextStyle(
                          fontSize: 18,
                          color:
                              Colors.grey.shade700,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "$ovulationDays days",
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight:
                              FontWeight.bold,
                          color:
                              Color(0xFFB046C5),
                        ),
                      ),

                      const SizedBox(height: 8),

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .center,
                        children: [
                          const Text(
                            "High chance of getting pregnant",
                            style: TextStyle(
                              fontSize: 13,
                              color:
                                  Colors.black54,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Icon(Icons.info_outline,
                              size: 16,
                              color: Colors
                                  .grey.shade400),
                        ],
                      ),

                      const SizedBox(height: 25),

                      // Pink Button
                      Container(
                        width: double.infinity,
                        height: 50,
                        decoration:
                            BoxDecoration(
                          borderRadius:
                              BorderRadius
                                  .circular(30),
                          gradient:
                              const LinearGradient(
                            colors: [
                              Color(0xFFFF5C8A),
                              Color(0xFFFF7A9E),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors
                                  .pink
                                  .withOpacity(0.3),
                              blurRadius: 10,
                              offset:
                                  const Offset(
                                      0, 4),
                            )
                          ],
                        ),
                        alignment:
                            Alignment.center,
                        child: const Text(
                          "Record the menstrual cycle",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      // ===== PERIOD CARD =====
                      Container(
                        padding:
                            const EdgeInsets
                                .all(18),
                        decoration:
                            BoxDecoration(
                          color: const Color(
                              0xFFFCE4EC),
                          borderRadius:
                              BorderRadius
                                  .circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.water_drop,
                              color: Color(
                                  0xFFFF5C8A),
                            ),
                            const SizedBox(
                                width: 10),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                children: [
                                  Text(
                                    "My period has arrived.",
                                    style:
                                        TextStyle(
                                      fontWeight:
                                          FontWeight
                                              .w600,
                                    ),
                                  ),
                                  SizedBox(
                                      height: 4),
                                  Text(
                                    "Tap to mark the first day of your period",
                                    style:
                                        TextStyle(
                                      fontSize:
                                          11,
                                      color: Colors
                                          .black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: _controller
                                  .isPeriod,
                              activeColor:
                                  const Color(
                                      0xFFFF5C8A),
                              onChanged:
                                  _handleSwitch,
                            )
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ===== INSIGHT CARD =====
                      Container(
                        padding:
                            const EdgeInsets
                                .all(18),
                        decoration:
                            BoxDecoration(
                          color: const Color(
                              0xFFF3E5F5),
                          borderRadius:
                              BorderRadius
                                  .circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [

                            Row(
                              children: [
                                const Icon(
                                  Icons.wb_sunny,
                                  color: Colors
                                      .orange,
                                ),
                                const SizedBox(
                                    width: 8),
                                const Text(
                                  "Today's Insight",
                                  style:
                                      TextStyle(
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  hormone,
                                  style:
                                      const TextStyle(
                                    fontSize:
                                        11,
                                    color: Colors
                                        .red,
                                  ),
                                )
                              ],
                            ),

                            const SizedBox(
                                height: 15),

                            Container(
                              padding:
                                  const EdgeInsets
                                      .all(14),
                              decoration:
                                  BoxDecoration(
                                color: Colors
                                    .white,
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                            15),
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                children: [
                                  Text(
                                    "$phase Phase",
                                    style:
                                        const TextStyle(
                                      fontWeight:
                                          FontWeight
                                              .bold,
                                      color: Colors
                                          .pink,
                                    ),
                                  ),
                                  const SizedBox(
                                      height:
                                          6),
                                  Text(
                                    insight,
                                    style:
                                        const TextStyle(
                                      fontSize:
                                          13,
                                      color: Colors
                                          .black87,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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