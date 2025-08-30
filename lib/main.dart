import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:neuro_plus/common/services/patients/patients_service.dart';
import 'package:neuro_plus/common/services/protocols/protocol_service.dart';
import 'package:neuro_plus/common/services/appointments/appointments_service.dart';
import 'package:neuro_plus/core/navigation/app_routes.dart';
import 'common/config/theme.dart';
import 'screens/home/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar os serviços
  await ProtocolsService.init();
  await AppointmentsService.init();
  await PatientsService.init();

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
      locale: const Locale('pt', 'BR'),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt', 'BR')],
      home: const HomeScreen(),
      routes: AppRoutes.generateRoutes(),
      builder: (context, child) {
        if (kIsWeb) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(viewInsets: EdgeInsets.zero),
            child: child!,
          );
        }
        return child!;
      },
    );
  }
}
