import 'package:flutter/material.dart';
import 'package:neuro_plus/models/patient.dart';
import 'package:neuro_plus/screens/home/home_page.dart';
import 'package:neuro_plus/screens/appointments_list/appointments_list_screen.dart';
import 'package:neuro_plus/screens/protocols/protocols_screen.dart';
import 'package:neuro_plus/screens/protocols_create/protocols_create_screen.dart';
import 'package:neuro_plus/screens/patients/patients_list/patients_screen.dart';
import 'package:neuro_plus/screens/patients/patients_create_screen.dart';
import 'package:neuro_plus/screens/patients/patients_detail/patient_detail_screen.dart';
import 'package:neuro_plus/screens/appointments_create/appointments_create_screen.dart';
import 'package:neuro_plus/screens/appointment_detail/appointment_detail_screen.dart';
import 'package:neuro_plus/models/appointment.dart';
import 'package:neuro_plus/models/protocol.dart';

/// Classe responsável por gerenciar as rotas da aplicação de forma tipada
class AppRoutes {
  // Rotas principais
  static const String home = '/home';
  static const String schedule = '/schedule';
  static const String protocols = '/protocols';
  static const String patients = '/patients';

  // Rotas de pacientes
  static const String patientsCreate = '/patients/create';
  static const String patientsDetail = '/patients/detail';

  // Rotas de protocolos
  static const String protocolsCreate = '/protocols/create';

  // Rotas de consultas
  static const String appointmentsCreate = '/appointments/create';
  static const String appointmentsList = '/appointments/list';
  static const String appointmentsDetail = '/appointments/detail';

  /// Mapa de rotas com seus respectivos widgets
  static Map<String, Widget Function(BuildContext, Object?)> get routes => {
    home: (context, args) => const HomeScreen(),
    schedule: (context, args) => const AppointmentsScreen(),
    protocols: (context, args) => const ProtocolsScreen(),
    patients: (context, args) => const PatientsScreen(),
    patientsCreate: (context, args) {
      final patient = args as Patient?;
      return PatientsCreateScreen(patient: patient);
    },
    patientsDetail: (context, args) {
      final patient = args as Patient;
      return PatientDetailScreen(patient: patient);
    },
    protocolsCreate: (context, args) {
      final protocol = args as Protocol?;
      return ProtocolsCreateScreen(protocol: protocol);
    },
    appointmentsCreate: (context, args) {
      final appointment = args as Appointment?;
      return AppointmentsCreateScreen(appointment: appointment);
    },
    appointmentsList: (context, args) => const AppointmentsScreen(),
    appointmentsDetail: (context, args) {
      final appointment = args as Appointment;
      return AppointmentDetailScreen(appointment: appointment);
    },
  };

  /// Gera o mapa de rotas para o MaterialApp
  static Map<String, WidgetBuilder> generateRoutes() {
    return routes.map(
      (route, builder) => MapEntry(route, (context) {
        final args = ModalRoute.of(context)?.settings.arguments;
        return builder(context, args);
      }),
    );
  }

  /// Navega para uma rota específica
  static Future<T?> navigateTo<T extends Object?>(
    BuildContext context,
    String route, {
    Object? arguments,
  }) {
    return Navigator.pushNamed<T>(context, route, arguments: arguments);
  }

  /// Navega para uma rota e remove todas as rotas anteriores
  static Future<T?> navigateAndClearStack<T extends Object?>(
    BuildContext context,
    String route, {
    Object? arguments,
  }) {
    return Navigator.pushNamedAndRemoveUntil<T>(
      context,
      route,
      (route) => false,
      arguments: arguments,
    );
  }

  /// Substitui a rota atual
  static Future<T?> navigateAndReplace<T extends Object?, TO extends Object?>(
    BuildContext context,
    String route, {
    Object? arguments,
    TO? result,
  }) {
    return Navigator.pushReplacementNamed<T, TO>(
      context,
      route,
      arguments: arguments,
      result: result,
    );
  }

  /// Volta para a tela anterior
  static void goBack<T extends Object?>(BuildContext context, [T? result]) {
    Navigator.pop<T>(context, result);
  }

  /// Verifica se é possível voltar
  static bool canGoBack(BuildContext context) {
    return Navigator.canPop(context);
  }
}
