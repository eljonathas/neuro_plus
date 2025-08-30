import 'package:flutter/material.dart';
import 'package:neuro_plus/common/main_layout.dart';
import 'package:neuro_plus/models/patient.dart';
import 'package:neuro_plus/screens/patients/controllers/patient_form_controller.dart';
import 'package:neuro_plus/screens/patients/validators/patient_form_validators.dart';
import 'package:neuro_plus/screens/patients/widgets/patient_basic_info.dart';
import 'package:neuro_plus/screens/patients/widgets/patient_clinical_info.dart';
import 'package:neuro_plus/screens/patients/widgets/patient_development_info.dart';
import 'package:neuro_plus/screens/patients/widgets/patient_school_info.dart';
import 'package:neuro_plus/screens/patients/widgets/patient_form_navigation.dart';
import 'package:neuro_plus/screens/patients/widgets/patient_form_progress.dart';

class PatientsCreateScreen extends StatefulWidget {
  final Patient? patient;

  const PatientsCreateScreen({super.key, this.patient});

  @override
  State<PatientsCreateScreen> createState() => _PatientsCreateScreenState();
}

class _PatientsCreateScreenState extends State<PatientsCreateScreen> {
  static const int _totalPages = 4;

  final _formKey = GlobalKey<FormState>();
  final _basicInfoFormKey = GlobalKey<FormState>();
  final _clinicalInfoFormKey = GlobalKey<FormState>();
  final _developmentInfoFormKey = GlobalKey<FormState>();
  final _schoolInfoFormKey = GlobalKey<FormState>();
  final _pageController = PageController();

  late final PatientFormController _controller;
  int _currentPage = 0;

  bool get _isEditing => widget.patient != null;

  @override
  void initState() {
    super.initState();
    _controller = PatientFormController();
    _controller.initialize(widget.patient);
    _controller.addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    if (_controller.errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_controller.errorMessage!)));
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      _pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      return;
    }

    final success = await _controller.savePatient(widget.patient);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Paciente ${_isEditing ? 'atualizado' : 'cadastrado'} com sucesso!',
          ),
        ),
      );
      Navigator.pop(context, true);
    }
  }

  void _handleNext() {
    if (_validateCurrentPage() && _currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handlePrevious() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _validateCurrentPage() {
    final formKeys = [
      _basicInfoFormKey,
      _clinicalInfoFormKey,
      _developmentInfoFormKey,
      _schoolInfoFormKey,
    ];

    return _controller.validatePage(formKeys[_currentPage]);
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: "${_isEditing ? 'Editar' : 'Novo'} paciente",
      isBackButtonVisible: true,
      navIndex: 3,
      resizeToAvoidBottomInset: false,
      child: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          if (_controller.formData == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Form(
            key: _formKey,
            child: Column(
              children: [
                PatientFormProgress(
                  currentPage: _currentPage,
                  totalPages: _totalPages,
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged:
                        (page) => setState(() => _currentPage = page),
                    children: [
                      _buildBasicInfoPage(),
                      _buildClinicalInfoPage(),
                      _buildDevelopmentInfoPage(),
                      _buildSchoolInfoPage(),
                    ],
                  ),
                ),
                PatientFormNavigation(
                  currentPage: _currentPage,
                  totalPages: _totalPages,
                  isProcessing: _controller.isProcessing,
                  isEditing: _isEditing,
                  onPrevious: _handlePrevious,
                  onNext: _handleNext,
                  onSave: _handleSave,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBasicInfoPage() {
    return PatientBasicInfo(
      formKey: _basicInfoFormKey,
      fullNameController: _controller.formData!.fullNameController,
      contactPhoneController: _controller.formData!.contactPhoneController,
      contactEmailController: _controller.formData!.contactEmailController,
      addressController: _controller.formData!.addressController,
      birthDateController: _controller.formData!.birthDateController,
      guardians: _controller.formData!.guardians,
      birthDate: _controller.formData!.birthDate,
      gender: _controller.formData!.gender,
      onDateChanged: _controller.updateBirthDate,
      onGenderChanged: _controller.updateGender,
      onGuardiansChanged: _controller.updateGuardians,
      requiredValidator: PatientFormValidators.requiredValidator,
      emailValidator: PatientFormValidators.emailValidator,
      phoneValidator: PatientFormValidators.phoneValidator,
    );
  }

  Widget _buildClinicalInfoPage() {
    return PatientClinicalInfo(
      formKey: _clinicalInfoFormKey,
      referralReasonController: _controller.formData!.referralReasonController,
      referredByController: _controller.formData!.referredByController,
      previousDiagnosisController:
          _controller.formData!.previousDiagnosisController,
      cidCodeController: _controller.formData!.cidCodeController,
      otherComorbiditiesController:
          _controller.formData!.otherComorbiditiesController,
      otherScreeningsController:
          _controller.formData!.otherScreeningsController,
      previouslyEvaluated: _controller.formData!.previouslyEvaluated,
      comorbidities: _controller.formData!.comorbidities,
      screeningsPerformed: _controller.formData!.screeningsPerformed,
      onPreviouslyEvaluatedChanged: _controller.updatePreviouslyEvaluated,
      onComorbiditiesChanged: _controller.updateComorbidities,
      onScreeningsChanged: _controller.updateScreeningsPerformed,
    );
  }

  Widget _buildDevelopmentInfoPage() {
    return PatientDevelopmentInfo(
      formKey: _developmentInfoFormKey,
      gender: _controller.formData!.gender,
      repetitiveBehaviorsDescriptionController:
          _controller.formData!.repetitiveBehaviorsDescriptionController,
      developmentalDelayController:
          _controller.formData!.developmentalDelayController,
      motorDelayController: _controller.formData!.motorDelayController,
      speechDelayController: _controller.formData!.speechDelayController,
      sittingAgeMonthsController:
          _controller.formData!.sittingAgeMonthsController,
      firstStepAgeMonthsController:
          _controller.formData!.firstStepAgeMonthsController,
      languageRegressionController:
          _controller.formData!.languageRegressionController,
      languageRegressionDescriptionController:
          _controller.formData!.languageRegressionDescriptionController,
      feedingSelectivityController:
          _controller.formData!.feedingSelectivityController,
      feedingSelectivityDescriptionController:
          _controller.formData!.feedingSelectivityDescriptionController,
      sensoryChangesController: _controller.formData!.sensoryChangesController,
      sensoryChangesDescriptionController:
          _controller.formData!.sensoryChangesDescriptionController,
      firstWordAgeController: _controller.formData!.firstWordAgeController,
      eyeContactController: _controller.formData!.eyeContactController,
      repetitiveBehaviorsController:
          _controller.formData!.repetitiveBehaviorsController,
      routineResistanceController:
          _controller.formData!.routineResistanceController,
      socialInteractionController:
          _controller.formData!.socialInteractionController,
      sensoryHypersensitivityController:
          _controller.formData!.sensoryHypersensitivityController,
      guardiansObservationsController:
          _controller.formData!.guardiansObservationsController,
    );
  }

  Widget _buildSchoolInfoPage() {
    return PatientSchoolInfo(
      formKey: _schoolInfoFormKey,
      schoolObservationsController:
          _controller.formData!.schoolObservationsController,
      schoolNameController: _controller.formData!.schoolNameController,
      teacherNameController: _controller.formData!.teacherNameController,
      otherSchoolTypeController:
          _controller.formData!.otherSchoolTypeController,
      attendsSchool: _controller.formData!.attendsSchool,
      schoolType: _controller.formData!.schoolType,
      schoolShift: _controller.formData!.schoolShift,
      hasCompanion: _controller.formData!.hasCompanion,
      onAttendsSchoolChanged: _controller.updateAttendsSchool,
      onSchoolTypeChanged: _controller.updateSchoolType,
      onSchoolShiftChanged: _controller.updateSchoolShift,
      onHasCompanionChanged: _controller.updateHasCompanion,
    );
  }
}
