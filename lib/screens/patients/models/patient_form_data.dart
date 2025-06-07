import 'package:flutter/material.dart';
import 'package:neuro_plus/models/patient.dart';

class PatientFormData {
  // Controllers para campos básicos
  final TextEditingController fullNameController;
  final TextEditingController guardiansController;
  final TextEditingController contactPhoneController;
  final TextEditingController contactEmailController;
  final TextEditingController addressController;

  // Controllers para informações clínicas
  final TextEditingController referralReasonController;
  final TextEditingController referredByController;
  final TextEditingController previousDiagnosisController;
  final TextEditingController otherComorbiditiesController;
  final TextEditingController otherScreeningsController;
  final TextEditingController repetitiveBehaviorsDescriptionController;
  final TextEditingController schoolObservationsController;
  final TextEditingController guardiansObservationsController;

  // Controllers para informações de desenvolvimento
  final TextEditingController developmentalDelayController;
  final TextEditingController firstWordAgeController;
  final TextEditingController eyeContactController;
  final TextEditingController repetitiveBehaviorsController;
  final TextEditingController routineResistanceController;
  final TextEditingController socialInteractionController;
  final TextEditingController sensoryHypersensitivityController;

  // Dados do formulário
  DateTime birthDate;
  String gender;
  List<String> comorbidities;
  bool? previouslyEvaluated;
  bool? attendsSchool;
  String? schoolType;
  String? schoolShift;
  String? hasMediator;
  List<String> screeningsPerformed;

  PatientFormData({
    required this.fullNameController,
    required this.guardiansController,
    required this.contactPhoneController,
    required this.contactEmailController,
    required this.addressController,
    required this.referralReasonController,
    required this.referredByController,
    required this.previousDiagnosisController,
    required this.otherComorbiditiesController,
    required this.otherScreeningsController,
    required this.repetitiveBehaviorsDescriptionController,
    required this.schoolObservationsController,
    required this.guardiansObservationsController,
    required this.developmentalDelayController,
    required this.firstWordAgeController,
    required this.eyeContactController,
    required this.repetitiveBehaviorsController,
    required this.routineResistanceController,
    required this.socialInteractionController,
    required this.sensoryHypersensitivityController,
    required this.birthDate,
    required this.gender,
    required this.comorbidities,
    this.previouslyEvaluated,
    this.attendsSchool,
    this.schoolType,
    this.schoolShift,
    this.hasMediator,
    required this.screeningsPerformed,
  });

  factory PatientFormData.fromPatient(Patient? patient) {
    return PatientFormData(
      fullNameController: TextEditingController(text: patient?.fullName ?? ''),
      guardiansController: TextEditingController(
        text: patient?.guardians ?? '',
      ),
      contactPhoneController: TextEditingController(
        text: patient?.contactPhone ?? '',
      ),
      contactEmailController: TextEditingController(
        text: patient?.contactEmail ?? '',
      ),
      addressController: TextEditingController(text: patient?.address ?? ''),
      referralReasonController: TextEditingController(
        text: patient?.referralReason ?? '',
      ),
      referredByController: TextEditingController(
        text: patient?.referredBy ?? '',
      ),
      previousDiagnosisController: TextEditingController(
        text: patient?.previousDiagnosis ?? '',
      ),
      otherComorbiditiesController: TextEditingController(
        text: patient?.otherComorbidities ?? '',
      ),
      otherScreeningsController: TextEditingController(
        text: patient?.otherScreenings ?? '',
      ),
      repetitiveBehaviorsDescriptionController: TextEditingController(
        text: patient?.repetitiveBehaviorsDescription ?? '',
      ),
      schoolObservationsController: TextEditingController(
        text: patient?.schoolObservations ?? '',
      ),
      guardiansObservationsController: TextEditingController(
        text: patient?.guardiansObservations ?? '',
      ),
      developmentalDelayController: TextEditingController(
        text: patient?.developmentalDelay?.toString() ?? '',
      ),
      firstWordAgeController: TextEditingController(
        text: patient?.firstWordAge?.toString() ?? '',
      ),
      eyeContactController: TextEditingController(
        text: patient?.eyeContact ?? '',
      ),
      repetitiveBehaviorsController: TextEditingController(
        text: patient?.repetitiveBehaviors?.toString() ?? '',
      ),
      routineResistanceController: TextEditingController(
        text: patient?.routineResistance?.toString() ?? '',
      ),
      socialInteractionController: TextEditingController(
        text: patient?.socialInteractionWithChildren ?? '',
      ),
      sensoryHypersensitivityController: TextEditingController(
        text: patient?.sensoryHypersensitivity ?? '',
      ),
      birthDate:
          patient?.birthDate ??
          DateTime.now().subtract(const Duration(days: 365 * 3)),
      gender: patient?.gender ?? PatientEnums.genderOptions.first,
      comorbidities: List.from(patient?.comorbidities ?? []),
      previouslyEvaluated: patient?.previouslyEvaluated,
      attendsSchool: patient?.attendsSchool,
      schoolType: patient?.schoolType,
      schoolShift: patient?.schoolShift,
      hasMediator: patient?.hasMediator,
      screeningsPerformed: List.from(patient?.screeningsPerformed ?? []),
    );
  }

  Patient toPatient() {
    return Patient(
      fullName: fullNameController.text,
      birthDate: birthDate,
      gender: gender,
      guardians: guardiansController.text,
      contactPhone: contactPhoneController.text,
      address: addressController.text,
      contactEmail:
          contactEmailController.text.isEmpty
              ? null
              : contactEmailController.text,
      referralReason:
          referralReasonController.text.isEmpty
              ? null
              : referralReasonController.text,
      referredBy:
          referredByController.text.isEmpty ? null : referredByController.text,
      previouslyEvaluated: previouslyEvaluated,
      previousDiagnosis:
          previousDiagnosisController.text.isEmpty
              ? null
              : previousDiagnosisController.text,
      comorbidities: comorbidities,
      otherComorbidities:
          comorbidities.contains('Outros') &&
                  otherComorbiditiesController.text.trim().isNotEmpty
              ? otherComorbiditiesController.text.trim()
              : null,
      developmentalDelay:
          developmentalDelayController.text.isEmpty
              ? null
              : bool.tryParse(developmentalDelayController.text),
      firstWordAge:
          firstWordAgeController.text.isEmpty
              ? null
              : int.tryParse(firstWordAgeController.text),
      eyeContact:
          eyeContactController.text.isEmpty ? null : eyeContactController.text,
      repetitiveBehaviors:
          repetitiveBehaviorsController.text.isEmpty
              ? null
              : bool.tryParse(repetitiveBehaviorsController.text),
      repetitiveBehaviorsDescription:
          repetitiveBehaviorsDescriptionController.text.isEmpty
              ? null
              : repetitiveBehaviorsDescriptionController.text,
      routineResistance:
          routineResistanceController.text.isEmpty
              ? null
              : bool.tryParse(routineResistanceController.text),
      socialInteractionWithChildren:
          socialInteractionController.text.isEmpty
              ? null
              : socialInteractionController.text,
      sensoryHypersensitivity:
          sensoryHypersensitivityController.text.isEmpty
              ? null
              : sensoryHypersensitivityController.text,
      attendsSchool: attendsSchool,
      schoolType: schoolType,
      schoolShift: schoolShift,
      hasMediator: hasMediator,
      schoolObservations:
          schoolObservationsController.text.isEmpty
              ? null
              : schoolObservationsController.text,
      guardiansObservations:
          guardiansObservationsController.text.isEmpty
              ? null
              : guardiansObservationsController.text,
      screeningsPerformed: screeningsPerformed,
      otherScreenings:
          screeningsPerformed.contains('Outros') &&
                  otherScreeningsController.text.trim().isNotEmpty
              ? otherScreeningsController.text.trim()
              : null,
    );
  }

  Patient updatePatient(Patient existingPatient) {
    return existingPatient.copyWith(
      fullName: fullNameController.text,
      birthDate: birthDate,
      gender: gender,
      guardians: guardiansController.text,
      contactPhone: contactPhoneController.text,
      address: addressController.text,
      contactEmail:
          contactEmailController.text.isEmpty
              ? null
              : contactEmailController.text,
      referralReason:
          referralReasonController.text.isEmpty
              ? null
              : referralReasonController.text,
      referredBy:
          referredByController.text.isEmpty ? null : referredByController.text,
      previouslyEvaluated: previouslyEvaluated,
      previousDiagnosis:
          previousDiagnosisController.text.isEmpty
              ? null
              : previousDiagnosisController.text,
      comorbidities: comorbidities,
      otherComorbidities:
          comorbidities.contains('Outros') &&
                  otherComorbiditiesController.text.trim().isNotEmpty
              ? otherComorbiditiesController.text.trim()
              : null,
      developmentalDelay:
          developmentalDelayController.text.isEmpty
              ? null
              : bool.tryParse(developmentalDelayController.text),
      firstWordAge:
          firstWordAgeController.text.isEmpty
              ? null
              : int.tryParse(firstWordAgeController.text),
      eyeContact:
          eyeContactController.text.isEmpty ? null : eyeContactController.text,
      repetitiveBehaviors:
          repetitiveBehaviorsController.text.isEmpty
              ? null
              : bool.tryParse(repetitiveBehaviorsController.text),
      repetitiveBehaviorsDescription:
          repetitiveBehaviorsDescriptionController.text.isEmpty
              ? null
              : repetitiveBehaviorsDescriptionController.text,
      routineResistance:
          routineResistanceController.text.isEmpty
              ? null
              : bool.tryParse(routineResistanceController.text),
      socialInteractionWithChildren:
          socialInteractionController.text.isEmpty
              ? null
              : socialInteractionController.text,
      sensoryHypersensitivity:
          sensoryHypersensitivityController.text.isEmpty
              ? null
              : sensoryHypersensitivityController.text,
      attendsSchool: attendsSchool,
      schoolType: schoolType,
      schoolShift: schoolShift,
      hasMediator: hasMediator,
      schoolObservations:
          schoolObservationsController.text.isEmpty
              ? null
              : schoolObservationsController.text,
      guardiansObservations:
          guardiansObservationsController.text.isEmpty
              ? null
              : guardiansObservationsController.text,
      screeningsPerformed: screeningsPerformed,
      otherScreenings:
          screeningsPerformed.contains('Outros') &&
                  otherScreeningsController.text.trim().isNotEmpty
              ? otherScreeningsController.text.trim()
              : null,
    );
  }

  void dispose() {
    fullNameController.dispose();
    guardiansController.dispose();
    contactPhoneController.dispose();
    contactEmailController.dispose();
    addressController.dispose();
    referralReasonController.dispose();
    referredByController.dispose();
    previousDiagnosisController.dispose();
    otherComorbiditiesController.dispose();
    otherScreeningsController.dispose();
    repetitiveBehaviorsDescriptionController.dispose();
    schoolObservationsController.dispose();
    guardiansObservationsController.dispose();
    developmentalDelayController.dispose();
    firstWordAgeController.dispose();
    eyeContactController.dispose();
    repetitiveBehaviorsController.dispose();
    routineResistanceController.dispose();
    socialInteractionController.dispose();
    sensoryHypersensitivityController.dispose();
  }
}
