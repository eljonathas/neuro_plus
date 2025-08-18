import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'appointment.g.dart';

@HiveType(typeId: 4)
class Appointment extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String patientId;

  @HiveField(2)
  final String patientName;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final String time;

  @HiveField(5)
  final List<String>? protocolIds;

  @HiveField(6)
  final List<String>? protocolNames;

  @HiveField(7)
  final AppointmentStatus status;

  @HiveField(8)
  final AppointmentType type;

  @HiveField(9)
  final String? notes;

  @HiveField(10)
  final Map<String, Map<String, dynamic>>? protocolResponses;

  @HiveField(11)
  final DateTime createdAt;

  @HiveField(12)
  final DateTime updatedAt;

  @HiveField(13)
  final int duration;

  @HiveField(14)
  final String? location;

  @HiveField(15)
  final String? soapSubjective;

  @HiveField(16)
  final String? soapObjective;

  @HiveField(17)
  final String? soapAssessment;

  @HiveField(18)
  final String? soapPlan;

  Appointment({
    String? id,
    required this.patientId,
    required this.patientName,
    required this.date,
    required this.time,
    this.protocolIds,
    this.protocolNames,
    this.status = AppointmentStatus.scheduled,
    this.type = AppointmentType.evaluation,
    this.notes,
    this.protocolResponses,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.duration = 60,
    this.location,
    this.soapSubjective,
    this.soapObjective,
    this.soapAssessment,
    this.soapPlan,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Appointment copyWith({
    String? patientId,
    String? patientName,
    DateTime? date,
    String? time,
    List<String>? protocolIds,
    List<String>? protocolNames,
    AppointmentStatus? status,
    AppointmentType? type,
    String? notes,
    Map<String, Map<String, dynamic>>? protocolResponses,
    int? duration,
    String? location,
    String? soapSubjective,
    String? soapObjective,
    String? soapAssessment,
    String? soapPlan,
  }) {
    return Appointment(
      id: id,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      date: date ?? this.date,
      time: time ?? this.time,
      protocolIds: protocolIds ?? this.protocolIds,
      protocolNames: protocolNames ?? this.protocolNames,
      status: status ?? this.status,
      type: type ?? this.type,
      notes: notes ?? this.notes,
      protocolResponses: protocolResponses ?? this.protocolResponses,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      duration: duration ?? this.duration,
      location: location ?? this.location,
      soapSubjective: soapSubjective ?? this.soapSubjective,
      soapObjective: soapObjective ?? this.soapObjective,
      soapAssessment: soapAssessment ?? this.soapAssessment,
      soapPlan: soapPlan ?? this.soapPlan,
    );
  }

  // Getters úteis
  String get formattedDate {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String get statusText {
    switch (status) {
      case AppointmentStatus.scheduled:
        return 'Agendada';
      case AppointmentStatus.inProgress:
        return 'Em andamento';
      case AppointmentStatus.completed:
        return 'Concluída';
      case AppointmentStatus.cancelled:
        return 'Cancelada';
      case AppointmentStatus.noShow:
        return 'Faltou';
    }
  }

  String get typeText {
    switch (type) {
      case AppointmentType.evaluation:
        return 'Avaliação';
      case AppointmentType.revaluation:
        return 'Reavaliação';
      case AppointmentType.followUp:
        return 'Acompanhamento';
      case AppointmentType.consultation:
        return 'Consulta';
    }
  }

  bool get isCompleted => status == AppointmentStatus.completed;
  bool get canEdit => status == AppointmentStatus.scheduled;
  bool get hasProtocol => protocolIds != null && protocolIds!.isNotEmpty;

  // Métodos para extrair notas SOAP
  bool get hasSoapNotes {
    return (soapSubjective?.trim().isNotEmpty == true) ||
        (soapObjective?.trim().isNotEmpty == true) ||
        (soapAssessment?.trim().isNotEmpty == true) ||
        (soapPlan?.trim().isNotEmpty == true) ||
        _hasSoapInNotes();
  }

  bool _hasSoapInNotes() {
    if (notes == null || notes!.isEmpty) return false;
    try {
      final notesData = jsonDecode(notes!);
      if (notesData is Map<String, dynamic>) {
        final soapData = notesData['SOAP'] as Map<String, dynamic>?;
        if (soapData != null) {
          return (soapData['S'] as String?)?.trim().isNotEmpty == true ||
              (soapData['O'] as String?)?.trim().isNotEmpty == true ||
              (soapData['A'] as String?)?.trim().isNotEmpty == true ||
              (soapData['P'] as String?)?.trim().isNotEmpty == true;
        }
      }
    } catch (e) {
      // Ignorar erros de JSON
    }
    return false;
  }

  String? get readableNotes {
    if (notes == null || notes!.isEmpty) return null;

    try {
      final notesData = jsonDecode(notes!);
      if (notesData is Map<String, dynamic>) {
        return notesData['text'] as String?;
      }
    } catch (e) {
      // Se não for JSON, retornar como texto simples
    }
    return notes;
  }

  String? get soapNotesSummary {
    final List<String> summaries = [];

    // Verificar campos diretos primeiro
    if (soapSubjective?.trim().isNotEmpty == true) {
      final text = soapSubjective!.trim();
      summaries.add(
        'S: ${text.length > 30 ? '${text.substring(0, 30)}...' : text}',
      );
    }
    if (soapObjective?.trim().isNotEmpty == true) {
      final text = soapObjective!.trim();
      summaries.add(
        'O: ${text.length > 30 ? '${text.substring(0, 30)}...' : text}',
      );
    }
    if (soapAssessment?.trim().isNotEmpty == true) {
      final text = soapAssessment!.trim();
      summaries.add(
        'A: ${text.length > 30 ? '${text.substring(0, 30)}...' : text}',
      );
    }
    if (soapPlan?.trim().isNotEmpty == true) {
      final text = soapPlan!.trim();
      summaries.add(
        'P: ${text.length > 30 ? '${text.substring(0, 30)}...' : text}',
      );
    }

    // Se não há dados nos campos diretos, verificar no JSON
    if (summaries.isEmpty && notes != null && notes!.isNotEmpty) {
      try {
        final notesData = jsonDecode(notes!);
        if (notesData is Map<String, dynamic>) {
          final soapData = notesData['SOAP'] as Map<String, dynamic>?;
          if (soapData != null) {
            if ((soapData['S'] as String?)?.trim().isNotEmpty == true) {
              final text = (soapData['S'] as String).trim();
              summaries.add(
                'S: ${text.length > 30 ? '${text.substring(0, 30)}...' : text}',
              );
            }
            if ((soapData['O'] as String?)?.trim().isNotEmpty == true) {
              final text = (soapData['O'] as String).trim();
              summaries.add(
                'O: ${text.length > 30 ? '${text.substring(0, 30)}...' : text}',
              );
            }
            if ((soapData['A'] as String?)?.trim().isNotEmpty == true) {
              final text = (soapData['A'] as String).trim();
              summaries.add(
                'A: ${text.length > 30 ? '${text.substring(0, 30)}...' : text}',
              );
            }
            if ((soapData['P'] as String?)?.trim().isNotEmpty == true) {
              final text = (soapData['P'] as String).trim();
              summaries.add(
                'P: ${text.length > 30 ? '${text.substring(0, 30)}...' : text}',
              );
            }
          }
        }
      } catch (e) {
        // Ignorar erros de JSON
      }
    }

    return summaries.isNotEmpty ? summaries.join(' • ') : null;
  }
}

@HiveType(typeId: 5)
enum AppointmentStatus {
  @HiveField(0)
  scheduled,

  @HiveField(1)
  inProgress,

  @HiveField(2)
  completed,

  @HiveField(3)
  cancelled,

  @HiveField(4)
  noShow,
}

@HiveType(typeId: 6)
enum AppointmentType {
  @HiveField(0)
  evaluation,

  @HiveField(1)
  revaluation,

  @HiveField(2)
  followUp,

  @HiveField(3)
  consultation,
}
