import 'package:flutter/material.dart';
import 'package:neuro_plus/common/services/appointments/appointments_service.dart';
import 'package:neuro_plus/common/services/patients/patients_service.dart';
import 'package:neuro_plus/common/services/protocols/protocol_service.dart';
import 'package:neuro_plus/models/appointment.dart';
import 'package:neuro_plus/models/patient.dart';
import 'package:neuro_plus/models/protocol.dart';
import 'package:neuro_plus/screens/appointments_create/models/appointment_form_data.dart';
import 'package:neuro_plus/screens/appointments_create/validators/appointment_form_validators.dart';

class AppointmentFormController extends ChangeNotifier {
  AppointmentFormData _formData = AppointmentFormData();
  String? _errorMessage;

  AppointmentFormData get formData => _formData;
  String? get errorMessage => _errorMessage;

  Future<void> initialize(Appointment? appointment) async {
    _setLoading(true);
    _clearError();

    try {
      final patients = PatientsService.getAllPatients();
      final protocols = ProtocolsService.getAllProtocols();

      _formData = AppointmentFormData.fromAppointment(
        appointment,
        patients,
        protocols,
      );
    } catch (e) {
      _setError('Erro ao carregar dados: $e');
    } finally {
      _setLoading(false);
    }
  }

  void selectPatient(Patient patient) {
    _formData = _formData.copyWith(selectedPatient: patient);
    notifyListeners();
  }

  void selectDate(DateTime date) {
    _formData = _formData.copyWith(selectedDate: date);
    notifyListeners();
  }

  void selectTime(TimeOfDay time) {
    _formData = _formData.copyWith(selectedTime: time);
    notifyListeners();
  }

  void selectType(AppointmentType type) {
    _formData = _formData.copyWith(selectedType: type);
    notifyListeners();
  }

  void updateDuration(int duration) {
    _formData = _formData.copyWith(duration: duration);
    notifyListeners();
  }

  void updateLocation(String? location) {
    _formData = _formData.copyWith(location: location);
    notifyListeners();
  }

  void updateNotes(String? notes) {
    _formData = _formData.copyWith(notes: notes);
    notifyListeners();
  }

  void addProtocol(Protocol protocol) {
    final newProtocols = List<Protocol>.from(_formData.selectedProtocols);
    if (!newProtocols.contains(protocol)) {
      newProtocols.add(protocol);
      _formData = _formData.copyWith(selectedProtocols: newProtocols);
      notifyListeners();
    }
  }

  void removeProtocol(Protocol protocol) {
    final newProtocols = List<Protocol>.from(_formData.selectedProtocols);
    newProtocols.remove(protocol);
    _formData = _formData.copyWith(selectedProtocols: newProtocols);
    notifyListeners();
  }

  void nextStep() {
    if (_formData.canGoNext && validateCurrentStep()) {
      _formData = _formData.copyWith(currentStep: _formData.currentStep + 1);
      notifyListeners();
    }
  }

  void previousStep() {
    if (_formData.canGoBack) {
      _formData = _formData.copyWith(currentStep: _formData.currentStep - 1);
      notifyListeners();
    }
  }

  bool validateCurrentStep() {
    final validation = AppointmentFormValidators.validateStep(
      _formData.currentStep,
      _formData,
    );

    if (validation != null) {
      _setError(validation);
      return false;
    }

    // Verificar conflitos de horário no step 1
    if (_formData.currentStep == 1 && _formData.selectedTime != null) {
      final timeString =
          '${_formData.selectedTime!.hour.toString().padLeft(2, '0')}:${_formData.selectedTime!.minute.toString().padLeft(2, '0')}';

      if (AppointmentsService.hasTimeConflict(
        _formData.selectedDate!,
        timeString,
        _formData.duration,
      )) {
        _setError('Já existe uma consulta agendada neste horário');
        return false;
      }
    }

    _clearError();
    return true;
  }

  Future<bool> saveAppointment(Appointment? existingAppointment) async {
    if (!validateCurrentStep()) return false;

    _setLoading(true);
    _clearError();

    try {
      final appointment = _formData.toAppointment(
        existingId: existingAppointment?.id,
        existingStatus: existingAppointment?.status,
        createdAt: existingAppointment?.createdAt,
        protocolResponses: existingAppointment?.protocolResponses,
      );

      if (existingAppointment != null) {
        await AppointmentsService.updateAppointment(appointment);
      } else {
        await AppointmentsService.createAppointment(appointment);
      }

      return true;
    } catch (e) {
      _setError('Erro ao salvar consulta: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _formData = _formData.copyWith(isLoading: loading);
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

  bool get canProceed {
    final validation = AppointmentFormValidators.validateStep(
      _formData.currentStep,
      _formData,
    );
    return validation == null;
  }
}
