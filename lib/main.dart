import 'package:flutter/material.dart';
import 'core/config/theme.dart';
import 'features/home/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard Flutter',
      theme: appTheme,
      home: const HomeScreen(),
    );
  }
}
