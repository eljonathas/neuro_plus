import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:neuro_plus/common/services/protocols/protocol_service.dart';
import 'package:neuro_plus/screens/patients/patients_screen.dart';
import 'package:neuro_plus/screens/protocols/protocols_screen.dart';
import 'package:neuro_plus/screens/home/schedule_screen.dart';
import 'common/config/theme.dart';
import 'screens/home/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // // Inicializar o serviço de protocolos
  await ProtocolsService.init();

  // Inicializar formatação de data
  await initializeDateFormatting('pt_BR', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neuro+',
      theme: generateTheme(context),
      home: const HomeScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/schedule': (context) => const ScheduleScreen(),
        '/protocols': (context) => const ProtocolsScreen(),
        '/patients': (context) => const PatientsScreen(),
      },
    );
  }
}
