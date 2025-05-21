import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:neuro_plus/screens/protocol/protocols_screen.dart';
import 'package:neuro_plus/services/protocol_service.dart';
import 'core/config/theme.dart';
import 'screens/home/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar o serviço de protocolos
  await ProtocolService.init();
  
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
      theme: appTheme,
      home: const HomeScreen(),
      routes: {
        '/protocols': (context) => const ProtocolsScreen(),
      },
    );
  }
}
