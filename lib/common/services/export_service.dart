import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/appointment.dart';
import '../../models/patient.dart';
import '../../models/protocol.dart';

class ExportService {
  static const String _dateFormat = 'dd-MM-yyyy_HH-mm';

  /// Solicita permissões de armazenamento se necessário
  static Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      final permission = await Permission.storage.status;
      if (permission.isDenied) {
        final result = await Permission.storage.request();
        return result.isGranted;
      }
      return permission.isGranted;
    }
    return true; // iOS não precisa dessa permissão
  }

  /// Obtém o diretório para salvar arquivos
  static Future<Directory> _getExportDirectory() async {
    if (Platform.isAndroid) {
      return await getExternalStorageDirectory() ??
          await getApplicationDocumentsDirectory();
    }
    return await getApplicationDocumentsDirectory();
  }

  /// Gera nome do arquivo com timestamp
  static String _generateFileName(String baseName, String extension) {
    final timestamp = DateFormat(_dateFormat).format(DateTime.now());
    return '${baseName}_$timestamp.$extension';
  }

  // EXPORTAÇÃO DE CONSULTAS

  /// Exporta lista de consultas para CSV
  static Future<File> exportAppointmentsToCsv(
    List<Appointment> appointments,
  ) async {
    final directory = await _getExportDirectory();
    final fileName = _generateFileName('consultas', 'csv');
    final file = File('${directory.path}/$fileName');

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

    await file.writeAsString(csvString);
    return file;
  }

  /// Exporta dados de uma consulta específica para JSON
  static Future<File> exportAppointmentToJson(Appointment appointment) async {
    final directory = await _getExportDirectory();
    final fileName = _generateFileName(
      'consulta_${appointment.patientName}',
      'json',
    );
    final file = File('${directory.path}/$fileName');

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

    await file.writeAsString(jsonEncode(jsonData));
    return file;
  }

  // EXPORTAÇÃO DE PACIENTES

  /// Exporta lista de pacientes para CSV
  static Future<File> exportPatientsToCsv(List<Patient> patients) async {
    final directory = await _getExportDirectory();
    final fileName = _generateFileName('pacientes', 'csv');
    final file = File('${directory.path}/$fileName');

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
                patient.hasMediator ?? '',
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

    await file.writeAsString(csvString);
    return file;
  }

  // EXPORTAÇÃO DE PROTOCOLOS

  /// Exporta lista de protocolos para CSV
  static Future<File> exportProtocolsToCsv(List<Protocol> protocols) async {
    final directory = await _getExportDirectory();
    final fileName = _generateFileName('protocolos', 'csv');
    final file = File('${directory.path}/$fileName');

    final headers = [
      'ID',
      'Nome',
      'Descrição',
      'Categorias',
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
                protocol.categories.join('; '),
                protocol.template,
                protocol.items.length.toString(),
                DateFormat('dd/MM/yyyy HH:mm').format(protocol.createdAt),
                DateFormat('dd/MM/yyyy HH:mm').format(protocol.updatedAt),
              ],
            )
            .toList();

    final csvData = [headers, ...rows];
    final csvString = const ListToCsvConverter().convert(csvData);

    await file.writeAsString(csvString);
    return file;
  }

  /// Exporta protocolo específico para JSON (usado no compartilhamento)
  static Future<File> exportProtocolToJson(Protocol protocol) async {
    final directory = await _getExportDirectory();
    final fileName = _generateFileName('protocolo_${protocol.name}', 'json');
    final file = File('${directory.path}/$fileName');

    final jsonData = protocol.toJson();
    await file.writeAsString(jsonEncode(jsonData));
    return file;
  }

  /// Gera JSON string do protocolo para QR Code
  static String generateProtocolQrData(Protocol protocol) {
    final shareData = {
      'type': 'protocol_share',
      'version': '1.0',
      'data': protocol.toJson(),
      'sharedAt': DateTime.now().toIso8601String(),
    };
    return jsonEncode(shareData);
  }

  /// Importa protocolo a partir de dados do QR Code
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

  // MÉTODOS DE COMPARTILHAMENTO

  /// Compartilha arquivo usando o sistema nativo
  static Future<void> shareFile(File file, {String? subject}) async {
    final xFile = XFile(file.path);
    await Share.shareXFiles([
      xFile,
    ], subject: subject ?? 'Dados exportados - Neuro Plus');
  }

  /// Compartilha múltiplos arquivos
  static Future<void> shareFiles(List<File> files, {String? subject}) async {
    final xFiles = files.map((file) => XFile(file.path)).toList();
    await Share.shareXFiles(
      xFiles,
      subject: subject ?? 'Dados exportados - Neuro Plus',
    );
  }

  /// Salva arquivo no dispositivo (com permissão)
  static Future<bool> saveFileToDevice(File file) async {
    final hasPermission = await _requestStoragePermission();
    if (!hasPermission) return false;

    // O arquivo já está salvo no diretório de documentos da aplicação
    // Retorna true indicando sucesso
    return true;
  }
}
