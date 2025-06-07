import 'package:flutter/material.dart';
import 'package:neuro_plus/models/appointment.dart';
import 'package:neuro_plus/models/patient.dart';
import 'package:neuro_plus/models/protocol.dart';

class AppointmentFormData {
  // Dados principais
  Patient? selectedPatient;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  AppointmentType selectedType;
  List<Protocol> selectedProtocols;
  int duration;
  String? location;
  String? notes;

  // Estado do formulário
  int currentStep;
  bool isLoading;

  // Listas de referência
  List<Patient> patients;
  List<Protocol> protocols;

  AppointmentFormData({
    this.selectedPatient,
    this.selectedDate,
    this.selectedTime,
    this.selectedType = AppointmentType.evaluation,
    this.selectedProtocols = const [],
    this.duration = 60,
    this.location,
    this.notes,
    this.currentStep = 0,
    this.isLoading = false,
    this.patients = const [],
    this.protocols = const [],
  });

  factory AppointmentFormData.fromAppointment(
    Appointment? appointment,
    List<Patient> patients,
    List<Protocol> protocols,
  ) {
    if (appointment == null) {
      return AppointmentFormData(patients: patients, protocols: protocols);
    }

    final selectedPatient = patients.firstWhere(
      (p) => p.id == appointment.patientId,
      orElse:
          () =>
              patients.isNotEmpty
                  ? patients.first
                  : throw Exception('No patients available'),
    );

    final selectedProtocols =
        appointment.protocolIds != null
            ? protocols
                .where((p) => appointment.protocolIds!.contains(p.id))
                .toList()
            : <Protocol>[];

    final timeParts = appointment.time.split(':');
    final selectedTime = TimeOfDay(
      hour: int.parse(timeParts[0]),
      minute: int.parse(timeParts[1]),
    );

    return AppointmentFormData(
      selectedPatient: selectedPatient,
      selectedDate: appointment.date,
      selectedTime: selectedTime,
      selectedType: appointment.type,
      selectedProtocols: selectedProtocols,
      duration: appointment.duration,
      location: appointment.location,
      notes: appointment.notes,
      patients: patients,
      protocols: protocols,
    );
  }

  Appointment toAppointment({
    String? existingId,
    AppointmentStatus? existingStatus,
    DateTime? createdAt,
    Map<String, Map<String, dynamic>>? protocolResponses,
  }) {
    final timeString =
        '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}';

    return Appointment(
      id: existingId,
      patientId: selectedPatient!.id,
      patientName: selectedPatient!.fullName,
      date: selectedDate!,
      time: timeString,
      type: selectedType,
      protocolIds:
          selectedProtocols.isNotEmpty
              ? selectedProtocols.map((p) => p.id).toList()
              : null,
      protocolNames:
          selectedProtocols.isNotEmpty
              ? selectedProtocols.map((p) => p.name).toList()
              : null,
      duration: duration,
      location: location,
      notes: notes,
      status: existingStatus ?? AppointmentStatus.scheduled,
      protocolResponses: protocolResponses,
      createdAt: createdAt,
    );
  }

  AppointmentFormData copyWith({
    Patient? selectedPatient,
    DateTime? selectedDate,
    TimeOfDay? selectedTime,
    AppointmentType? selectedType,
    List<Protocol>? selectedProtocols,
    int? duration,
    String? location,
    String? notes,
    int? currentStep,
    bool? isLoading,
    List<Patient>? patients,
    List<Protocol>? protocols,
  }) {
    return AppointmentFormData(
      selectedPatient: selectedPatient ?? this.selectedPatient,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      selectedType: selectedType ?? this.selectedType,
      selectedProtocols: selectedProtocols ?? this.selectedProtocols,
      duration: duration ?? this.duration,
      location: location ?? this.location,
      notes: notes ?? this.notes,
      currentStep: currentStep ?? this.currentStep,
      isLoading: isLoading ?? this.isLoading,
      patients: patients ?? this.patients,
      protocols: protocols ?? this.protocols,
    );
  }

  bool get hasPatients => patients.isNotEmpty;
  bool get isLastStep => currentStep == 2;
  bool get canGoNext => currentStep < 2;
  bool get canGoBack => currentStep > 0;
}
