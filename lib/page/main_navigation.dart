import 'package:flutter/material.dart';
import 'home_page.dart';
import 'calendar_page.dart';
import 'settings_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    CalendarPage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        height: 75,
        decoration: const BoxDecoration(
          color: Color(0xFFF7F7F7),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () => _onItemTapped(0),
              color: _selectedIndex == 0 
                  ? const Color(0xFFF06C8C) 
                  : Colors.grey,
            ),
            IconButton(
              icon: const Icon(Icons.calendar_month),
              onPressed: () => _onItemTapped(1),
              color: _selectedIndex == 1 
                  ? const Color(0xFFF06C8C) 
                  : Colors.grey,
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => _onItemTapped(2),
              color: _selectedIndex == 2 
                  ? const Color(0xFFF06C8C) 
                  : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
