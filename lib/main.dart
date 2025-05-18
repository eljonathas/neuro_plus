import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/config/theme.dart';
import 'screens/home/home_page.dart';

void main() {
  initializeDateFormatting('pt_BR', null).then((_) {
    runApp(const MyApp());
  });
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
