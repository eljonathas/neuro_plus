import 'package:flutter/material.dart';
import 'package:neuro_plus/models/patient.dart';

class PatientFormData {
  // Controllers para campos básicos
  final TextEditingController fullNameController;
  final TextEditingController contactPhoneController;
  final TextEditingController contactEmailController;
  final TextEditingController addressController;

  // Lista de responsáveis
  List<Guardian> guardians;

  // Controllers para informações clínicas
  final TextEditingController referralReasonController;
  final TextEditingController referredByController;
  final TextEditingController previousDiagnosisController;
  final TextEditingController cidCodeController;
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

  PatientFormData({Patient? patient})
    : fullNameController = TextEditingController(text: patient?.fullName),
      guardians =
          patient?.guardians.isNotEmpty == true
              ? List.from(patient!.guardians)
              : [
                Guardian(
                  name: '',
                  phone: '',
                  email: '',
                  relationship: '',
                  address: '',
                ),
              ],
      contactPhoneController = TextEditingController(
        text: patient?.contactPhone,
      ),
      contactEmailController = TextEditingController(
        text: patient?.contactEmail,
      ),
      addressController = TextEditingController(text: patient?.address),
      referralReasonController = TextEditingController(
        text: patient?.referralReason ?? '',
      ),
      referredByController = TextEditingController(
        text: patient?.referredBy ?? '',
      ),
      previousDiagnosisController = TextEditingController(
        text: patient?.previousDiagnosis ?? '',
      ),
      cidCodeController = TextEditingController(text: patient?.cidCode ?? ''),
      otherComorbiditiesController = TextEditingController(
        text: patient?.otherComorbidities ?? '',
      ),
      otherScreeningsController = TextEditingController(
        text: patient?.otherScreenings ?? '',
      ),
      repetitiveBehaviorsDescriptionController = TextEditingController(
        text: patient?.repetitiveBehaviorsDescription ?? '',
      ),
      schoolObservationsController = TextEditingController(
        text: patient?.schoolObservations ?? '',
      ),
      guardiansObservationsController = TextEditingController(
        text: patient?.guardiansObservations ?? '',
      ),
      developmentalDelayController = TextEditingController(
        text: patient?.developmentalDelay?.toString() ?? '',
      ),
      firstWordAgeController = TextEditingController(
        text: patient?.firstWordAge?.toString() ?? '',
      ),
      eyeContactController = TextEditingController(
        text: patient?.eyeContact ?? '',
      ),
      repetitiveBehaviorsController = TextEditingController(
        text: patient?.repetitiveBehaviors?.toString() ?? '',
      ),
      routineResistanceController = TextEditingController(
        text: patient?.routineResistance?.toString() ?? '',
      ),
      socialInteractionController = TextEditingController(
        text: patient?.socialInteractionWithChildren ?? '',
      ),
      sensoryHypersensitivityController = TextEditingController(
        text: patient?.sensoryHypersensitivity ?? '',
      ),
      birthDate =
          patient?.birthDate ??
          DateTime.now().subtract(const Duration(days: 365 * 3)),
      gender = patient?.gender ?? PatientEnums.genderOptions.first,
      comorbidities = List.from(patient?.comorbidities ?? []),
      previouslyEvaluated = patient?.previouslyEvaluated,
      attendsSchool = patient?.attendsSchool,
      schoolType = patient?.schoolType,
      schoolShift = patient?.schoolShift,
      hasMediator = patient?.hasMediator,
      screeningsPerformed = List.from(patient?.screeningsPerformed ?? []);

  factory PatientFormData.fromPatient(Patient? patient) {
    return PatientFormData(patient: patient);
  }

  void addGuardian() {
    guardians.add(
      Guardian(name: '', phone: '', email: '', relationship: '', address: ''),
    );
  }

  void removeGuardian(int index) {
    if (guardians.length > 1) {
      guardians.removeAt(index);
    }
  }

  void updateGuardian(int index, Guardian guardian) {
    if (index < guardians.length) {
      guardians[index] = guardian;
    }
  }

  void dispose() {
    fullNameController.dispose();
    contactPhoneController.dispose();
    contactEmailController.dispose();
    addressController.dispose();
    referralReasonController.dispose();
    referredByController.dispose();
    previousDiagnosisController.dispose();
    cidCodeController.dispose();
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

  Patient toPatient() {
    return Patient(
      fullName: fullNameController.text,
      birthDate: birthDate,
      gender: gender,
      guardians: guardians,
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
      cidCode: cidCodeController.text.isEmpty ? null : cidCodeController.text,
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
      guardians: guardians,
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
      cidCode: cidCodeController.text.isEmpty ? null : cidCodeController.text,
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
}
