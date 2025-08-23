import 'package:flutter/material.dart';
import 'package:neuro_plus/common/services/patients/patients_service.dart';
import 'package:neuro_plus/models/patient.dart';
import 'package:neuro_plus/screens/patients/models/patient_form_data.dart';

class PatientFormController extends ChangeNotifier {
  PatientFormData? _formData;
  bool _isProcessing = false;
  String? _errorMessage;

  PatientFormData? get formData => _formData;
  bool get isProcessing => _isProcessing;
  String? get errorMessage => _errorMessage;

  void initialize(Patient? patient) {
    _formData = PatientFormData.fromPatient(patient);
    notifyListeners();
  }

  void updateBirthDate(DateTime date) {
    if (_formData != null) {
      _formData!.birthDate = date;
      notifyListeners();
    }
  }

  void updateGender(String gender) {
    if (_formData != null) {
      _formData!.gender = gender;
      notifyListeners();
    }
  }

  void updateGuardians(List<Guardian> guardians) {
    if (_formData != null) {
      _formData!.guardians = guardians;
      notifyListeners();
    }
  }

  void addGuardian() {
    if (_formData != null) {
      _formData!.addGuardian();
      notifyListeners();
    }
  }

  void removeGuardian(int index) {
    if (_formData != null) {
      _formData!.removeGuardian(index);
      notifyListeners();
    }
  }

  void updateGuardian(int index, Guardian guardian) {
    if (_formData != null) {
      _formData!.updateGuardian(index, guardian);
      notifyListeners();
    }
  }

  void updateComorbidities(List<String> comorbidities) {
    if (_formData != null) {
      _formData!.comorbidities = comorbidities;
      notifyListeners();
    }
  }

  void updatePreviouslyEvaluated(bool? value) {
    if (_formData != null) {
      _formData!.previouslyEvaluated = value;
      notifyListeners();
    }
  }

  void updateScreeningsPerformed(List<String> screenings) {
    if (_formData != null) {
      _formData!.screeningsPerformed = screenings;
      notifyListeners();
    }
  }

  void updateAttendsSchool(bool? value) {
    if (_formData != null) {
      _formData!.attendsSchool = value;
      notifyListeners();
    }
  }

  void updateSchoolType(String? type) {
    if (_formData != null) {
      _formData!.schoolType = type;
      notifyListeners();
    }
  }

  void updateSchoolShift(String? shift) {
    if (_formData != null) {
      _formData!.schoolShift = shift;
      notifyListeners();
    }
  }

  void updateHasCompanion(String? hasCompanion) {
    if (_formData != null) {
      _formData!.hasCompanion = hasCompanion;
      notifyListeners();
    }
  }

  bool validatePage(GlobalKey<FormState> formKey) {
    return formKey.currentState?.validate() ?? false;
  }

  Future<bool> savePatient(Patient? existingPatient) async {
    if (_formData == null) return false;

    _setProcessing(true);
    _clearError();

    try {
      final patient =
          existingPatient != null
              ? _formData!.updatePatient(existingPatient)
              : _formData!.toPatient();

      await (existingPatient != null
          ? PatientsService.updatePatient(patient)
          : PatientsService.addPatient(patient));

      return true;
    } catch (e) {
      _setError(
        'Erro ao ${existingPatient != null ? 'atualizar' : 'cadastrar'} paciente: $e',
      );
      return false;
    } finally {
      _setProcessing(false);
    }
  }

  void _setProcessing(bool processing) {
    _isProcessing = processing;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _formData?.dispose();
    super.dispose();
  }
}
