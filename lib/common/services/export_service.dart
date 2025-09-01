import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/appointment.dart';
import '../../models/patient.dart';
import '../../models/protocol.dart';

// ignore: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html show AnchorElement, Blob, Url;

class ExportService {
  static const String _dateFormat = 'dd-MM-yyyy_HH-mm';

  static Future<bool> _requestStoragePermission() async {
    if (kIsWeb) return true;
    if (Platform.isAndroid) {
      final permission = await Permission.storage.status;
      if (permission.isDenied) {
        final result = await Permission.storage.request();
        return result.isGranted;
      }
      return permission.isGranted;
    }
    return true;
  }

  static Future<Directory?> _getExportDirectory() async {
    if (kIsWeb) return null;
    if (Platform.isAndroid) {
      return await getExternalStorageDirectory() ??
          await getApplicationDocumentsDirectory();
    }
    return await getApplicationDocumentsDirectory();
  }

  static String _generateFileName(String baseName, String extension) {
    final timestamp = DateFormat(_dateFormat).format(DateTime.now());
    return '${baseName}_$timestamp.$extension';
  }

  static void _downloadFileOnWeb(
    String content,
    String fileName,
    String mimeType,
  ) {
    if (kIsWeb) {
      final bytes = utf8.encode(content);
      final blob = html.Blob([bytes], mimeType);
      final url = html.Url.createObjectUrlFromBlob(blob);
      (html.AnchorElement(href: url)
        ..setAttribute('download', fileName)
        ..click());
      html.Url.revokeObjectUrl(url);
    }
  }

  static Future<File?> exportAppointmentsToCsv(
    List<Appointment> appointments,
  ) async {
    final fileName = _generateFileName('consultas', 'csv');

    final headers = [
      'ID',
      'Paciente',
      'Data',
      'Horário',
      'Status',
      'Tipo',
      'Duração (min)',
      'Local',
      'Protocolos',
      'Observações',
      'Criado em',
      'Atualizado em',
    ];

    final rows =
        appointments
            .map(
              (appointment) => [
                appointment.id,
                appointment.patientName,
                appointment.formattedDate,
                appointment.time,
                appointment.statusText,
                appointment.typeText,
                appointment.duration.toString(),
                appointment.location ?? '',
                appointment.protocolNames?.join('; ') ?? '',
                appointment.notes ?? '',
                DateFormat('dd/MM/yyyy HH:mm').format(appointment.createdAt),
                DateFormat('dd/MM/yyyy HH:mm').format(appointment.updatedAt),
              ],
            )
            .toList();

    final csvData = [headers, ...rows];
    final csvString = const ListToCsvConverter().convert(csvData);

    if (kIsWeb) {
      _downloadFileOnWeb(csvString, fileName, 'text/csv');
      return null;
    } else {
      final directory = await _getExportDirectory();
      final file = File('${directory!.path}/$fileName');
      await file.writeAsString(csvString);
      return file;
    }
  }

  static Future<File?> exportAppointmentToJson(Appointment appointment) async {
    final fileName = _generateFileName(
      'consulta_${appointment.patientName}',
      'json',
    );

    final jsonData = {
      'id': appointment.id,
      'patientId': appointment.patientId,
      'patientName': appointment.patientName,
      'date': appointment.date.toIso8601String(),
      'time': appointment.time,
      'status': appointment.status.name,
      'type': appointment.type.name,
      'duration': appointment.duration,
      'location': appointment.location,
      'protocolIds': appointment.protocolIds,
      'protocolNames': appointment.protocolNames,
      'protocolResponses': appointment.protocolResponses,
      'notes': appointment.notes,
      'createdAt': appointment.createdAt.toIso8601String(),
      'updatedAt': appointment.updatedAt.toIso8601String(),
    };

    final jsonString = jsonEncode(jsonData);

    if (kIsWeb) {
      _downloadFileOnWeb(jsonString, fileName, 'application/json');
      return null;
    } else {
      final directory = await _getExportDirectory();
      final file = File('${directory!.path}/$fileName');
      await file.writeAsString(jsonString);
      return file;
    }
  }

  static Future<File?> exportPatientsToCsv(List<Patient> patients) async {
    final fileName = _generateFileName('pacientes', 'csv');

    final headers = [
      'ID',
      'Nome Completo',
      'Data de Nascimento',
      'Idade',
      'Gênero',
      'Responsáveis',
      'Telefone',
      'Email',
      'Endereço',
      'Motivo de Encaminhamento',
      'Encaminhado por',
      'Avaliado Anteriormente',
      'Diagnóstico Anterior',
      'Comorbidades',
      'Atraso no Desenvolvimento',
      'Primeira Palavra (meses)',
      'Contato Visual',
      'Comportamentos Repetitivos',
      'Resistência à Rotina',
      'Interação Social',
      'Hipersensibilidade Sensorial',
      'Frequenta Escola',
      'Tipo de Escola',
      'Turno Escolar',
      'Tem Mediador',
      'Observações Escola',
      'Observações Responsáveis',
      'Triagens Realizadas',
      'Criado em',
      'Atualizado em',
    ];

    final rows =
        patients
            .map(
              (patient) => [
                patient.id,
                patient.fullName,
                DateFormat('dd/MM/yyyy').format(patient.birthDate),
                patient.age.toString(),
                patient.gender,
                patient.guardians,
                patient.contactPhone,
                patient.contactEmail ?? '',
                patient.address,
                patient.referralReason ?? '',
                patient.referredBy ?? '',
                patient.previouslyEvaluated?.toString() ?? '',
                patient.previousDiagnosis ?? '',
                patient.comorbidities.join('; '),
                patient.developmentalDelay?.toString() ?? '',
                patient.firstWordAge?.toString() ?? '',
                patient.eyeContact ?? '',
                patient.repetitiveBehaviors?.toString() ?? '',
                patient.routineResistance?.toString() ?? '',
                patient.socialInteractionWithChildren ?? '',
                patient.sensoryHypersensitivity ?? '',
                patient.attendsSchool?.toString() ?? '',
                patient.schoolType ?? '',
                patient.schoolShift ?? '',
                patient.hasCompanion ?? '',
                patient.schoolObservations ?? '',
                patient.guardiansObservations ?? '',
                patient.screeningsPerformed.join('; '),
                DateFormat('dd/MM/yyyy HH:mm').format(patient.createdAt),
                DateFormat('dd/MM/yyyy HH:mm').format(patient.updatedAt),
              ],
            )
            .toList();

    final csvData = [headers, ...rows];
    final csvString = const ListToCsvConverter().convert(csvData);

    if (kIsWeb) {
      _downloadFileOnWeb(csvString, fileName, 'text/csv');
      return null;
    } else {
      final directory = await _getExportDirectory();
      final file = File('${directory!.path}/$fileName');
      await file.writeAsString(csvString);
      return file;
    }
  }

  static Future<File> exportProtocolsToCsv(List<Protocol> protocols) async {
    final fileName = _generateFileName('protocolos', 'csv');

    final headers = [
      'ID',
      'Nome',
      'Descrição',
      'Template',
      'Quantidade de Itens',
      'Criado em',
      'Atualizado em',
    ];

    final rows =
        protocols
            .map(
              (protocol) => [
                protocol.id,
                protocol.name,
                protocol.description ?? '',
                protocol.template,
                protocol.items.length.toString(),
                DateFormat('dd/MM/yyyy HH:mm').format(protocol.createdAt),
                DateFormat('dd/MM/yyyy HH:mm').format(protocol.updatedAt),
              ],
            )
            .toList();

    final csvData = [headers, ...rows];
    final csvString = const ListToCsvConverter().convert(csvData);

    if (kIsWeb) {
      _downloadFileOnWeb(csvString, fileName, 'text/csv');
      return File('');
    } else {
      final directory = await _getExportDirectory();
      final file = File('${directory!.path}/$fileName');
      await file.writeAsString(csvString);
      return file;
    }
  }

  static Future<File?> exportProtocolToJson(Protocol protocol) async {
    final fileName = _generateFileName('protocolo_${protocol.name}', 'json');
    final jsonString = jsonEncode(protocol.toJson());

    if (kIsWeb) {
      _downloadFileOnWeb(jsonString, fileName, 'application/json');
      return null;
    } else {
      final directory = await _getExportDirectory();
      final file = File('${directory!.path}/$fileName');
      await file.writeAsString(jsonString);
      return file;
    }
  }

  static String generateProtocolQrData(Protocol protocol) {
    final shareData = {
      'type': 'protocol_share',
      'version': '1.0',
      'data': protocol.toJson(),
      'sharedAt': DateTime.now().toIso8601String(),
    };
    return jsonEncode(shareData);
  }

  static Protocol? importProtocolFromQrData(String qrData) {
    try {
      final data = jsonDecode(qrData);

      if (data['type'] != 'protocol_share') {
        throw Exception('Tipo de QR Code inválido');
      }

      return Protocol.fromJson(data['data']);
    } catch (e) {
      return null;
    }
  }

  static Future<void> shareFile(File? file, {String? subject}) async {
    if (file == null || kIsWeb) return;

    final xFile = XFile(file.path);
    await Share.shareXFiles([
      xFile,
    ], subject: subject ?? 'Dados exportados - Neuro Plus');
  }

  static Future<void> shareFiles(List<File?> files, {String? subject}) async {
    if (kIsWeb) return;

    final validFiles = files.whereType<File>().toList();
    if (validFiles.isEmpty) return;

    final xFiles = validFiles.map((file) => XFile(file.path)).toList();
    await Share.shareXFiles(
      xFiles,
      subject: subject ?? 'Dados exportados - Neuro Plus',
    );
  }

  static Future<bool> saveFileToDevice(File? file) async {
    if (file == null || kIsWeb) return true;

    final hasPermission = await _requestStoragePermission();
    if (!hasPermission) return false;

    return true;
  }
}
