import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'page/main_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://jodslfwupimvhdqfqzhb.supabase.co',
    anonKey: 'YOUR_ANON_KEY', // ใส่ key จริงของคุณ
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainNavigation(), // 👈 เข้าแอปหลักตรงนี้เลย
    );
  }
}