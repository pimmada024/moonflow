import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'page/main_navigation.dart';
import 'page/select_period_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://jodslfwupimvhdqfqzhb.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpvZHNsZnd1cGltdmhkcWZxemhiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjkwOTczOTQsImV4cCI6MjA4NDY3MzM5NH0.4xKn4MCrbPHFwsffgjfP3WTrSMR6sNcVNAyeVg66AX8',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SelectPeriodScreen(),
        '/select-period': (context) => const SelectPeriodScreen(),
        '/home': (context) => const MainNavigation(),
      },
    );
  }
}