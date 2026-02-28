import 'dart:math';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // ---------------------------
  // MOCK STATE (UI ONLY)
  // ---------------------------
  bool isLoggedIn = false;
  String userName = "12345";
  String language = "English";

  // random color for guest avatar
  Color guestColor = Colors.primaries[Random().nextInt(Colors.primaries.length)];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6D6DF),
      body: SafeArea(
        child: Stack(
          children: [
            // ---------------------------
            // BACKGROUND LOGO
            // ---------------------------
            Align(
              alignment: Alignment.bottomCenter,
              child: Opacity(
                opacity: 0.12,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 80),
                  child: Image.asset(
                    "assets/logo.png",
                    width: 280,
                  ),
                ),
              ),
            ),

            // ---------------------------
            // CONTENT
            // ---------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),

                  // ===========================
                  // LOGIN CARD
                  // ===========================
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        // Avatar
                        CircleAvatar(
                          radius: 28,
                          backgroundColor:
                              isLoggedIn ? Colors.pink.shade200 : guestColor,
                          backgroundImage: isLoggedIn
                              ? const AssetImage("assets/logo.png")
                                  as ImageProvider
                              : null,
                        ),

                        const SizedBox(width: 16),

                        // Name
                        Expanded(
                          child: Text(
                            isLoggedIn ? userName : "Guest",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        // Button
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            side: const BorderSide(color: Colors.grey),
                          ),
                          onPressed: () {
                            setState(() {
                              isLoggedIn = !isLoggedIn;
                              if (!isLoggedIn) {
                                guestColor = Colors.primaries[
                                    Random().nextInt(Colors.primaries.length)];
                              }
                            });
                          },
                          child: Text(
                            isLoggedIn ? "Log out" : "Log in",
                            style: const TextStyle(color: Colors.black87),
                          ),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ===========================
                  // LANGUAGE CARD
                  // ===========================
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.translate,
                            color: Colors.pink, size: 24),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            "Change Language",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border:
                                Border.all(color: Colors.grey.shade300),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: language,
                              icon: const Icon(Icons.keyboard_arrow_down,
                                  color: Colors.pink),
                              items: const [
                                DropdownMenuItem(
                                  value: "English",
                                  child: Text("English"),
                                ),
                                DropdownMenuItem(
                                  value: "Thai",
                                  child: Text("ไทย"),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  language = value!;
                                });
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}