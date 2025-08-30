import 'package:flutter/material.dart';
import 'package:neuro_plus/models/patient.dart';
import 'package:neuro_plus/common/utils/date_formatter.dart';

class PatientFormData {
  final TextEditingController fullNameController;
  final TextEditingController contactPhoneController;
  final TextEditingController contactEmailController;
  final TextEditingController addressController;
  final TextEditingController birthDateController;

  List<Guardian> guardians;

  final TextEditingController referralReasonController;
  final TextEditingController referredByController;
  final TextEditingController previousDiagnosisController;
  final TextEditingController cidCodeController;
  final TextEditingController otherComorbiditiesController;
  final TextEditingController otherScreeningsController;
  final TextEditingController repetitiveBehaviorsDescriptionController;
  final TextEditingController schoolObservationsController;
  final TextEditingController guardiansObservationsController;

  final TextEditingController developmentalDelayController;
  final TextEditingController motorDelayController;
  final TextEditingController speechDelayController;
  final TextEditingController sittingAgeMonthsController;
  final TextEditingController firstStepAgeMonthsController;
  final TextEditingController languageRegressionController;
  final TextEditingController languageRegressionDescriptionController;
  final TextEditingController feedingSelectivityController;
  final TextEditingController feedingSelectivityDescriptionController;
  final TextEditingController sensoryChangesController;
  final TextEditingController sensoryChangesDescriptionController;
  final TextEditingController firstWordAgeController;
  final TextEditingController eyeContactController;
  final TextEditingController repetitiveBehaviorsController;
  final TextEditingController routineResistanceController;
  final TextEditingController socialInteractionController;
  final TextEditingController sensoryHypersensitivityController;

  final TextEditingController schoolNameController;
  final TextEditingController teacherNameController;
  final TextEditingController otherSchoolTypeController;

  DateTime birthDate;
  String gender;
  List<String> comorbidities;
  bool? previouslyEvaluated;
  bool? attendsSchool;
  String? schoolType;
  String? schoolShift;
  String? hasCompanion;
  List<String> screeningsPerformed;

  PatientFormData({Patient? patient})
    : fullNameController = TextEditingController(text: patient?.fullName),
      birthDateController = TextEditingController(
        text:
            patient?.birthDate != null
                ? BrazilianDateValidator.formatDate(patient!.birthDate)
                : '',
      ),
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
      motorDelayController = TextEditingController(
        text:
            patient?.motorDelay == null
                ? 'not_observed'
                : (patient!.motorDelay! ? 'true' : 'false'),
      ),
      speechDelayController = TextEditingController(
        text:
            patient?.speechDelay == null
                ? 'not_observed'
                : (patient!.speechDelay! ? 'true' : 'false'),
      ),
      sittingAgeMonthsController = TextEditingController(
        text: patient?.sittingAgeMonths?.toString() ?? '',
      ),
      firstStepAgeMonthsController = TextEditingController(
        text: patient?.firstStepAgeMonths?.toString() ?? '',
      ),
      languageRegressionController = TextEditingController(
        text:
            patient?.languageRegression == null
                ? 'not_observed'
                : (patient!.languageRegression! ? 'true' : 'false'),
      ),
      languageRegressionDescriptionController = TextEditingController(
        text: patient?.languageRegressionDescription ?? '',
      ),
      feedingSelectivityController = TextEditingController(
        text:
            patient?.feedingSelectivity == null
                ? 'not_observed'
                : (patient!.feedingSelectivity! ? 'true' : 'false'),
      ),
      feedingSelectivityDescriptionController = TextEditingController(
        text: patient?.feedingSelectivityDescription ?? '',
      ),
      sensoryChangesController = TextEditingController(
        text:
            patient?.sensoryChanges == null
                ? 'not_observed'
                : (patient!.sensoryChanges! ? 'true' : 'false'),
      ),
      sensoryChangesDescriptionController = TextEditingController(
        text: patient?.sensoryChangesDescription ?? '',
      ),
      firstWordAgeController = TextEditingController(
        text: patient?.firstWordAge?.toString() ?? '',
      ),
      eyeContactController = TextEditingController(
        text: patient?.eyeContact ?? '',
      ),
      repetitiveBehaviorsController = TextEditingController(
        text:
            patient?.repetitiveBehaviors == null
                ? 'not_observed'
                : (patient!.repetitiveBehaviors! ? 'true' : 'false'),
      ),
      routineResistanceController = TextEditingController(
        text:
            patient?.routineResistance == null
                ? 'not_observed'
                : (patient!.routineResistance! ? 'true' : 'false'),
      ),
      socialInteractionController = TextEditingController(
        text: patient?.socialInteractionWithChildren ?? '',
      ),
      sensoryHypersensitivityController = TextEditingController(
        text: patient?.sensoryHypersensitivity ?? '',
      ),
      schoolNameController = TextEditingController(
        text: patient?.schoolName ?? '',
      ),
      teacherNameController = TextEditingController(
        text: patient?.teacherName ?? '',
      ),
      otherSchoolTypeController = TextEditingController(
        text: patient?.otherSchoolType ?? '',
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
      hasCompanion = patient?.hasCompanion,
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
    birthDateController.dispose();
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
    motorDelayController.dispose();
    speechDelayController.dispose();
    sittingAgeMonthsController.dispose();
    firstStepAgeMonthsController.dispose();
    languageRegressionController.dispose();
    languageRegressionDescriptionController.dispose();
    feedingSelectivityController.dispose();
    feedingSelectivityDescriptionController.dispose();
    sensoryChangesController.dispose();
    sensoryChangesDescriptionController.dispose();
    firstWordAgeController.dispose();
    eyeContactController.dispose();
    repetitiveBehaviorsController.dispose();
    routineResistanceController.dispose();
    socialInteractionController.dispose();
    sensoryHypersensitivityController.dispose();
    schoolNameController.dispose();
    teacherNameController.dispose();
    otherSchoolTypeController.dispose();
  }

  Patient toPatient() {
    return Patient(
      fullName: fullNameController.text,
      birthDate:
          BrazilianDateValidator.parseDate(birthDateController.text) ??
          birthDate,
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
      developmentalDelay: _computeDevelopmentalDelay(),
      motorDelay: _parseBoolFromController(motorDelayController),
      speechDelay: _parseBoolFromController(speechDelayController),
      sittingAgeMonths:
          sittingAgeMonthsController.text.isEmpty
              ? null
              : int.tryParse(sittingAgeMonthsController.text),
      firstStepAgeMonths:
          firstStepAgeMonthsController.text.isEmpty
              ? null
              : int.tryParse(firstStepAgeMonthsController.text),
      languageRegression: _parseBoolFromController(
        languageRegressionController,
      ),
      languageRegressionDescription:
          languageRegressionDescriptionController.text.isEmpty
              ? null
              : languageRegressionDescriptionController.text,
      feedingSelectivity: _parseBoolFromController(
        feedingSelectivityController,
      ),
      feedingSelectivityDescription:
          feedingSelectivityDescriptionController.text.isEmpty
              ? null
              : feedingSelectivityDescriptionController.text,
      firstWordAge:
          firstWordAgeController.text.isEmpty
              ? null
              : int.tryParse(firstWordAgeController.text),
      eyeContact:
          eyeContactController.text.isEmpty ? null : eyeContactController.text,
      repetitiveBehaviors: _parseBoolFromController(
        repetitiveBehaviorsController,
      ),
      repetitiveBehaviorsDescription:
          repetitiveBehaviorsDescriptionController.text.isEmpty
              ? null
              : repetitiveBehaviorsDescriptionController.text,
      routineResistance: _parseBoolFromController(routineResistanceController),
      socialInteractionWithChildren:
          socialInteractionController.text.isEmpty
              ? null
              : socialInteractionController.text,
      sensoryHypersensitivity:
          sensoryHypersensitivityController.text.isEmpty
              ? null
              : sensoryHypersensitivityController.text,
      sensoryChanges: _parseBoolFromController(sensoryChangesController),
      sensoryChangesDescription:
          sensoryChangesDescriptionController.text.isEmpty
              ? null
              : sensoryChangesDescriptionController.text,
      attendsSchool: attendsSchool,
      schoolType: schoolType,
      schoolShift: schoolShift,
      hasCompanion: hasCompanion,
      schoolName:
          schoolNameController.text.isEmpty ? null : schoolNameController.text,
      teacherName:
          teacherNameController.text.isEmpty
              ? null
              : teacherNameController.text,
      otherSchoolType:
          schoolType == 'Outra' &&
                  otherSchoolTypeController.text.trim().isNotEmpty
              ? otherSchoolTypeController.text.trim()
              : null,

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
      birthDate:
          BrazilianDateValidator.parseDate(birthDateController.text) ??
          birthDate,
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
      developmentalDelay: _computeDevelopmentalDelay(),
      motorDelay: _parseBoolFromController(motorDelayController),
      speechDelay: _parseBoolFromController(speechDelayController),
      sittingAgeMonths:
          sittingAgeMonthsController.text.isEmpty
              ? null
              : int.tryParse(sittingAgeMonthsController.text),
      firstStepAgeMonths:
          firstStepAgeMonthsController.text.isEmpty
              ? null
              : int.tryParse(firstStepAgeMonthsController.text),
      languageRegression: _parseBoolFromController(
        languageRegressionController,
      ),
      languageRegressionDescription:
          languageRegressionDescriptionController.text.isEmpty
              ? null
              : languageRegressionDescriptionController.text,
      feedingSelectivity: _parseBoolFromController(
        feedingSelectivityController,
      ),
      feedingSelectivityDescription:
          feedingSelectivityDescriptionController.text.isEmpty
              ? null
              : feedingSelectivityDescriptionController.text,
      firstWordAge:
          firstWordAgeController.text.isEmpty
              ? null
              : int.tryParse(firstWordAgeController.text),
      eyeContact:
          eyeContactController.text.isEmpty ? null : eyeContactController.text,
      repetitiveBehaviors: _parseBoolFromController(
        repetitiveBehaviorsController,
      ),
      repetitiveBehaviorsDescription:
          repetitiveBehaviorsDescriptionController.text.isEmpty
              ? null
              : repetitiveBehaviorsDescriptionController.text,
      routineResistance: _parseBoolFromController(routineResistanceController),
      socialInteractionWithChildren:
          socialInteractionController.text.isEmpty
              ? null
              : socialInteractionController.text,
      sensoryHypersensitivity:
          sensoryHypersensitivityController.text.isEmpty
              ? null
              : sensoryHypersensitivityController.text,
      sensoryChanges: _parseBoolFromController(sensoryChangesController),
      sensoryChangesDescription:
          sensoryChangesDescriptionController.text.isEmpty
              ? null
              : sensoryChangesDescriptionController.text,
      attendsSchool: attendsSchool,
      schoolType: schoolType,
      schoolShift: schoolShift,
      hasCompanion: hasCompanion,
      schoolName:
          schoolNameController.text.isEmpty ? null : schoolNameController.text,
      teacherName:
          teacherNameController.text.isEmpty
              ? null
              : teacherNameController.text,
      otherSchoolType:
          schoolType == 'Outra' &&
                  otherSchoolTypeController.text.trim().isNotEmpty
              ? otherSchoolTypeController.text.trim()
              : null,

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

  bool? _parseBoolFromController(TextEditingController controller) {
    if (controller.text == 'true') return true;
    if (controller.text == 'false') return false;
    if (controller.text == 'not_observed' || controller.text.isEmpty) {
      return null;
    }
    return null;
  }

  bool? _computeDevelopmentalDelay() {
    final bool? motor = _parseBoolFromController(motorDelayController);
    final bool? speech = _parseBoolFromController(speechDelayController);
    if (motor == true || speech == true) return true;
    if (motor == false && speech == false) return false;
    if (developmentalDelayController.text.isEmpty) return null;
    return bool.tryParse(developmentalDelayController.text);
  }
}
