import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'page/main_navigation.dart';
import 'page/select_period_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://jodslfwupimvhdqfqzhb.supabase.co',
    anonKey: 'YOUR_ANON_KEY',
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
        '/home': (context) => const MainNavigation(),
      },
    );
  }
}