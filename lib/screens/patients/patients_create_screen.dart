import 'package:flutter/material.dart';
import 'package:neuro_plus/common/main_layout.dart';
import 'package:neuro_plus/common/services/patients/patients_service.dart';
import 'package:neuro_plus/common/config/theme.dart';
import 'package:neuro_plus/common/widgets/custom_button.dart';
import 'package:neuro_plus/models/patient.dart';
import 'package:neuro_plus/screens/patients/widgets/patient_basic_info.dart';
import 'package:neuro_plus/screens/patients/widgets/patient_clinical_info.dart';
import 'package:neuro_plus/screens/patients/widgets/patient_development_info.dart';
import 'package:neuro_plus/screens/patients/widgets/patient_school_info.dart';

class PatientsCreateScreen extends StatefulWidget {
  final Patient? patient;

  const PatientsCreateScreen({super.key, this.patient});

  @override
  State<PatientsCreateScreen> createState() => _PatientsCreateScreenState();
}

class _PatientsCreateScreenState extends State<PatientsCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _basicInfoFormKey = GlobalKey<FormState>();
  final _clinicalInfoFormKey = GlobalKey<FormState>();
  final _developmentInfoFormKey = GlobalKey<FormState>();
  final _schoolInfoFormKey = GlobalKey<FormState>();
  final _pageController = PageController();
  int _currentPage = 0;
  bool _isProcessing = false;

  // Controllers para campos básicos
  late final TextEditingController _fullNameController;
  late final TextEditingController _guardiansController;
  late final TextEditingController _contactPhoneController;
  late final TextEditingController _contactEmailController;
  late final TextEditingController _addressController;

  // Controllers para informações clínicas
  late final TextEditingController _referralReasonController;
  late final TextEditingController _referredByController;
  late final TextEditingController _previousDiagnosisController;
  late final TextEditingController _repetitiveBehaviorsDescriptionController;
  late final TextEditingController _schoolObservationsController;
  late final TextEditingController _guardiansObservationsController;

  // Dados do formulário
  late DateTime _birthDate;
  late String _gender;
  late List<String> _comorbidities;
  late bool? _previouslyEvaluated;
  late bool? _developmentalDelay;
  late int? _firstWordAge;
  late String? _eyeContact;
  late bool? _repetitiveBehaviors;
  late bool? _routineResistance;
  late String? _socialInteractionWithChildren;
  late String? _sensoryHypersensitivity;
  late bool? _attendsSchool;
  late String? _schoolType;
  late String? _schoolShift;
  late String? _hasMediator;
  late List<String> _screeningsPerformed;

  bool get _isEditing => widget.patient != null;

  // Validadores
  late final String? Function(String?) _requiredValidator;
  late final String? Function(String?) _emailValidator;
  late final String? Function(String?) _phoneValidator;

  @override
  void initState() {
    super.initState();
    _initializeValidators();
    _initializeData();
  }

  void _initializeValidators() {
    _requiredValidator = (String? value) => 
      (value?.isEmpty ?? true) ? 'Este campo é obrigatório' : null;
    
    _emailValidator = (String? value) {
      if (value?.isEmpty ?? true) return null;
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      return emailRegex.hasMatch(value!) ? null : 'E-mail inválido';
    };
    
    _phoneValidator = (String? value) {
      if (value?.isEmpty ?? true) return 'Este campo é obrigatório';
      final phoneRegex = RegExp(r'^\+?[0-9\s\-()]{8,20}$');
      return phoneRegex.hasMatch(value!) ? null : 'Telefone inválido';
    };
  }

  void _initializeData() {
    final patient = widget.patient;
    
    // Controllers básicos
    _fullNameController = TextEditingController(text: patient?.fullName ?? '');
    _guardiansController = TextEditingController(text: patient?.guardians ?? '');
    _contactPhoneController = TextEditingController(text: patient?.contactPhone ?? '');
    _contactEmailController = TextEditingController(text: patient?.contactEmail ?? '');
    _addressController = TextEditingController(text: patient?.address ?? '');
    
    // Controllers clínicos
    _referralReasonController = TextEditingController(text: patient?.referralReason ?? '');
    _referredByController = TextEditingController(text: patient?.referredBy ?? '');
    _previousDiagnosisController = TextEditingController(text: patient?.previousDiagnosis ?? '');
    _repetitiveBehaviorsDescriptionController = TextEditingController(text: patient?.repetitiveBehaviorsDescription ?? '');
    _schoolObservationsController = TextEditingController(text: patient?.schoolObservations ?? '');
    _guardiansObservationsController = TextEditingController(text: patient?.guardiansObservations ?? '');
    
    // Dados do formulário
    _birthDate = patient?.birthDate ?? DateTime.now().subtract(const Duration(days: 365 * 3));
    _gender = patient?.gender ?? PatientEnums.genderOptions.first;
    _comorbidities = List.from(patient?.comorbidities ?? []);
    _previouslyEvaluated = patient?.previouslyEvaluated;
    _developmentalDelay = patient?.developmentalDelay;
    _firstWordAge = patient?.firstWordAge;
    _eyeContact = patient?.eyeContact;
    _repetitiveBehaviors = patient?.repetitiveBehaviors;
    _routineResistance = patient?.routineResistance;
    _socialInteractionWithChildren = patient?.socialInteractionWithChildren;
    _sensoryHypersensitivity = patient?.sensoryHypersensitivity;
    _attendsSchool = patient?.attendsSchool;
    _schoolType = patient?.schoolType;
    _schoolShift = patient?.schoolShift;
    _hasMediator = patient?.hasMediator;
    _screeningsPerformed = List.from(patient?.screeningsPerformed ?? []);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _guardiansController.dispose();
    _contactPhoneController.dispose();
    _contactEmailController.dispose();
    _addressController.dispose();
    _referralReasonController.dispose();
    _referredByController.dispose();
    _previousDiagnosisController.dispose();
    _repetitiveBehaviorsDescriptionController.dispose();
    _schoolObservationsController.dispose();
    _guardiansObservationsController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _savePatient() async {
    if (!_formKey.currentState!.validate()) {
      // Volta para a primeira página se houver erro de validação
      _pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final patient = _isEditing 
        ? widget.patient!.copyWith(
            fullName: _fullNameController.text,
            birthDate: _birthDate,
            gender: _gender,
            guardians: _guardiansController.text,
            contactPhone: _contactPhoneController.text,
            address: _addressController.text,
            contactEmail: _contactEmailController.text.isEmpty ? null : _contactEmailController.text,
            referralReason: _referralReasonController.text.isEmpty ? null : _referralReasonController.text,
            referredBy: _referredByController.text.isEmpty ? null : _referredByController.text,
            previouslyEvaluated: _previouslyEvaluated,
            previousDiagnosis: _previousDiagnosisController.text.isEmpty ? null : _previousDiagnosisController.text,
            comorbidities: _comorbidities,
            developmentalDelay: _developmentalDelay,
            firstWordAge: _firstWordAge,
            eyeContact: _eyeContact,
            repetitiveBehaviors: _repetitiveBehaviors,
            repetitiveBehaviorsDescription: _repetitiveBehaviorsDescriptionController.text.isEmpty ? null : _repetitiveBehaviorsDescriptionController.text,
            routineResistance: _routineResistance,
            socialInteractionWithChildren: _socialInteractionWithChildren,
            sensoryHypersensitivity: _sensoryHypersensitivity,
            attendsSchool: _attendsSchool,
            schoolType: _schoolType,
            schoolShift: _schoolShift,
            hasMediator: _hasMediator,
            schoolObservations: _schoolObservationsController.text.isEmpty ? null : _schoolObservationsController.text,
            guardiansObservations: _guardiansObservationsController.text.isEmpty ? null : _guardiansObservationsController.text,
            screeningsPerformed: _screeningsPerformed,
          )
        : Patient(
            fullName: _fullNameController.text,
            birthDate: _birthDate,
            gender: _gender,
            guardians: _guardiansController.text,
            contactPhone: _contactPhoneController.text,
            address: _addressController.text,
            contactEmail: _contactEmailController.text.isEmpty ? null : _contactEmailController.text,
            referralReason: _referralReasonController.text.isEmpty ? null : _referralReasonController.text,
            referredBy: _referredByController.text.isEmpty ? null : _referredByController.text,
            previouslyEvaluated: _previouslyEvaluated,
            previousDiagnosis: _previousDiagnosisController.text.isEmpty ? null : _previousDiagnosisController.text,
            comorbidities: _comorbidities,
            developmentalDelay: _developmentalDelay,
            firstWordAge: _firstWordAge,
            eyeContact: _eyeContact,
            repetitiveBehaviors: _repetitiveBehaviors,
            repetitiveBehaviorsDescription: _repetitiveBehaviorsDescriptionController.text.isEmpty ? null : _repetitiveBehaviorsDescriptionController.text,
            routineResistance: _routineResistance,
            socialInteractionWithChildren: _socialInteractionWithChildren,
            sensoryHypersensitivity: _sensoryHypersensitivity,
            attendsSchool: _attendsSchool,
            schoolType: _schoolType,
            schoolShift: _schoolShift,
            hasMediator: _hasMediator,
            schoolObservations: _schoolObservationsController.text.isEmpty ? null : _schoolObservationsController.text,
            guardiansObservations: _guardiansObservationsController.text.isEmpty ? null : _guardiansObservationsController.text,
            screeningsPerformed: _screeningsPerformed,
          );

      await (_isEditing 
        ? PatientsService.updatePatient(patient)
        : PatientsService.addPatient(patient));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Paciente ${_isEditing ? 'atualizado' : 'cadastrado'} com sucesso!')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao ${_isEditing ? 'atualizar' : 'cadastrar'} paciente: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  void _nextPage() {
    // Valida apenas os campos da página atual
    if (_validateCurrentPage()) {
      if (_currentPage < 3) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  bool _validateCurrentPage() {
    switch (_currentPage) {
      case 0: // Página de informações básicas
        return _basicInfoFormKey.currentState?.validate() ?? false;
      case 1: // Página de informações clínicas
        return _clinicalInfoFormKey.currentState?.validate() ?? true;
      case 2: // Página de desenvolvimento
        return _developmentInfoFormKey.currentState?.validate() ?? true;
      case 3: // Página escolar
        return _schoolInfoFormKey.currentState?.validate() ?? true;
      default:
        return true;
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: "${_isEditing ? 'Editar' : 'Novo'} paciente",
      isBackButtonVisible: true,
      navIndex: 3,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildProgressIndicator(),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) => setState(() => _currentPage = page),
                children: [
                  _buildBasicInfoPage(),
                  _buildClinicalInfoPage(),
                  _buildDevelopmentInfoPage(),
                  _buildSchoolInfoPage(),
                ],
              ),
            ),
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: List.generate(4, (index) {
          final isActive = index <= _currentPage;
          return Expanded(
            child: Container(
              height: 4,
              margin: EdgeInsets.only(right: index < 3 ? 8 : 0),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primarySwatch : AppColors.gray[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBasicInfoPage() {
    return PatientBasicInfo(
      formKey: _basicInfoFormKey,
      fullNameController: _fullNameController,
      guardiansController: _guardiansController,
      contactPhoneController: _contactPhoneController,
      contactEmailController: _contactEmailController,
      addressController: _addressController,
      birthDate: _birthDate,
      gender: _gender,
      onDateChanged: (date) => setState(() => _birthDate = date),
      onGenderChanged: (gender) => setState(() => _gender = gender),
      requiredValidator: _requiredValidator,
      emailValidator: _emailValidator,
      phoneValidator: _phoneValidator,
    );
  }

  Widget _buildClinicalInfoPage() {
    return PatientClinicalInfo(
      formKey: _clinicalInfoFormKey,
      referralReasonController: _referralReasonController,
      referredByController: _referredByController,
      previousDiagnosisController: _previousDiagnosisController,
      previouslyEvaluated: _previouslyEvaluated,
      comorbidities: _comorbidities,
      screeningsPerformed: _screeningsPerformed,
      onPreviouslyEvaluatedChanged: (value) => setState(() => _previouslyEvaluated = value),
      onComorbiditiesChanged: (value) => setState(() => _comorbidities = value),
      onScreeningsChanged: (value) => setState(() => _screeningsPerformed = value),
    );
  }

  Widget _buildDevelopmentInfoPage() {
    return PatientDevelopmentInfo(
      formKey: _developmentInfoFormKey,
      repetitiveBehaviorsDescriptionController: _repetitiveBehaviorsDescriptionController,
      developmentalDelay: _developmentalDelay,
      firstWordAge: _firstWordAge,
      eyeContact: _eyeContact,
      repetitiveBehaviors: _repetitiveBehaviors,
      routineResistance: _routineResistance,
      socialInteractionWithChildren: _socialInteractionWithChildren,
      sensoryHypersensitivity: _sensoryHypersensitivity,
      onDevelopmentalDelayChanged: (value) => setState(() => _developmentalDelay = value),
      onFirstWordAgeChanged: (value) => setState(() => _firstWordAge = value),
      onEyeContactChanged: (value) => setState(() => _eyeContact = value),
      onRepetitiveBehaviorsChanged: (value) => setState(() => _repetitiveBehaviors = value),
      onRoutineResistanceChanged: (value) => setState(() => _routineResistance = value),
      onSocialInteractionChanged: (value) => setState(() => _socialInteractionWithChildren = value),
      onSensoryHypersensitivityChanged: (value) => setState(() => _sensoryHypersensitivity = value),
    );
  }

  Widget _buildSchoolInfoPage() {
    return PatientSchoolInfo(
      formKey: _schoolInfoFormKey,
      schoolObservationsController: _schoolObservationsController,
      guardiansObservationsController: _guardiansObservationsController,
      attendsSchool: _attendsSchool,
      schoolType: _schoolType,
      schoolShift: _schoolShift,
      hasMediator: _hasMediator,
      onAttendsSchoolChanged: (value) => setState(() => _attendsSchool = value),
      onSchoolTypeChanged: (value) => setState(() => _schoolType = value),
      onSchoolShiftChanged: (value) => setState(() => _schoolShift = value),
      onHasMediatorChanged: (value) => setState(() => _hasMediator = value),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          if (_currentPage > 0)
            Expanded(
              child: CustomButton(
                text: 'Anterior',
                onPressed: _previousPage,
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primarySwatch,
              ),
            ),
          if (_currentPage > 0) const SizedBox(width: 16),
          Expanded(
            child: CustomButton(
              text: _currentPage == 3 
                ? (_isEditing ? 'Salvar' : 'Cadastrar')
                : 'Próximo',
              onPressed: _currentPage == 3 ? _savePatient : _nextPage,
              isLoading: _isProcessing,
            ),
          ),
        ],
      ),
    );
  }
} 