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
  final String? protocolId;

  @HiveField(6)
  final String? protocolName;

  @HiveField(7)
  final AppointmentStatus status;

  @HiveField(8)
  final AppointmentType type;

  @HiveField(9)
  final String? notes;

  @HiveField(10)
  final Map<String, dynamic>? protocolResponses;

  @HiveField(11)
  final DateTime createdAt;

  @HiveField(12)
  final DateTime updatedAt;

  @HiveField(13)
  final int duration; // em minutos

  @HiveField(14)
  final String? location;

  Appointment({
    String? id,
    required this.patientId,
    required this.patientName,
    required this.date,
    required this.time,
    this.protocolId,
    this.protocolName,
    this.status = AppointmentStatus.scheduled,
    this.type = AppointmentType.evaluation,
    this.notes,
    this.protocolResponses,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.duration = 60,
    this.location,
  }) : 
    id = id ?? const Uuid().v4(),
    createdAt = createdAt ?? DateTime.now(),
    updatedAt = updatedAt ?? DateTime.now();

  Appointment copyWith({
    String? patientId,
    String? patientName,
    DateTime? date,
    String? time,
    String? protocolId,
    String? protocolName,
    AppointmentStatus? status,
    AppointmentType? type,
    String? notes,
    Map<String, dynamic>? protocolResponses,
    int? duration,
    String? location,
  }) {
    return Appointment(
      id: id,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      date: date ?? this.date,
      time: time ?? this.time,
      protocolId: protocolId ?? this.protocolId,
      protocolName: protocolName ?? this.protocolName,
      status: status ?? this.status,
      type: type ?? this.type,
      notes: notes ?? this.notes,
      protocolResponses: protocolResponses ?? this.protocolResponses,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      duration: duration ?? this.duration,
      location: location ?? this.location,
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
      case AppointmentType.therapy:
        return 'Terapia';
      case AppointmentType.followUp:
        return 'Acompanhamento';
      case AppointmentType.consultation:
        return 'Consulta';
    }
  }

  bool get isCompleted => status == AppointmentStatus.completed;
  bool get canEdit => status == AppointmentStatus.scheduled;
  bool get hasProtocol => protocolId != null && protocolId!.isNotEmpty;
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
  therapy,
  
  @HiveField(2)
  followUp,
  
  @HiveField(3)
  consultation,
} 