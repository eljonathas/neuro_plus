import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neuro_plus/common/config/theme.dart';
import 'package:neuro_plus/common/main_layout.dart';
import 'package:neuro_plus/common/widgets/custom_button.dart';
import 'package:neuro_plus/common/widgets/custom_card.dart';
import 'package:neuro_plus/models/appointment.dart';
import 'package:neuro_plus/models/patient.dart';
import 'package:neuro_plus/models/protocol.dart';
import 'package:neuro_plus/screens/appointments_create/controllers/appointment_form_controller.dart';
import 'package:neuro_plus/screens/appointments_create/utils/appointment_type_helper.dart';
import 'package:neuro_plus/screens/appointments_create/widgets/appointment_navigation_buttons.dart';
import 'package:neuro_plus/screens/appointments_create/widgets/appointment_step_indicator.dart';

class AppointmentsCreateScreen extends StatefulWidget {
  final Appointment? appointment;

  const AppointmentsCreateScreen({super.key, this.appointment});

  @override
  State<AppointmentsCreateScreen> createState() =>
      _AppointmentsCreateScreenState();
}

class _AppointmentsCreateScreenState extends State<AppointmentsCreateScreen> {
  static const int _totalSteps = 3;

  final PageController _pageController = PageController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final AppointmentFormController _controller;

  bool get _isEditing => widget.appointment != null;

  @override
  void initState() {
    super.initState();
    _controller = AppointmentFormController();
    _controller.initialize(widget.appointment);
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

  void _handleNext() {
    _controller.nextStep();
    if (_controller.formData.currentStep > 0) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handlePrevious() {
    _controller.previousStep();
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  String _getGuardianName(List<Guardian> guardians) {
    if (guardians.isEmpty) return '';
    if (guardians.length == 1) return guardians.first.name;
    final List<String> firstGuardianNames = guardians.first.name.split(' ');
    final firstName = firstGuardianNames.first;
    final lastName = firstGuardianNames.last;
    return '$firstName $lastName e ${guardians.length - 1} outro${guardians.length - 1 > 1 ? 's' : ''}';
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await _controller.saveAppointment(widget.appointment);
    if (success && mounted) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing
                ? 'Consulta atualizada com sucesso!'
                : 'Consulta agendada com sucesso!',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: _isEditing ? 'Editar consulta' : 'Nova consulta',
      navIndex: 1,
      isBackButtonVisible: true,
      resizeToAvoidBottomInset: false,
      child: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          if (_controller.formData.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              AppointmentStepIndicator(
                currentStep: _controller.formData.currentStep,
                totalSteps: _totalSteps,
              ),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildPatientSelectionStep(),
                      _buildDateTimeStep(),
                      _buildDetailsStep(),
                    ],
                  ),
                ),
              ),
              AppointmentNavigationButtons(
                currentStep: _controller.formData.currentStep,
                canGoBack: _controller.formData.canGoBack,
                canGoNext: _controller.formData.canGoNext,
                isLastStep: _controller.formData.isLastStep,
                isLoading: _controller.formData.isLoading,
                hasPatients: _controller.formData.hasPatients,
                isEditing: _isEditing,
                canProceed: _controller.canProceed,
                onPrevious: _handlePrevious,
                onNext: _handleNext,
                onSave: _handleSave,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPatientSelectionStep() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selecionar paciente',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.gray[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Escolha o paciente para esta consulta',
            style: TextStyle(fontSize: 16, color: AppColors.gray[600]),
          ),
          const SizedBox(height: 24),
          if (!_controller.formData.hasPatients)
            _buildEmptyPatientsState()
          else
            _buildPatientsList(),
        ],
      ),
    );
  }

  Widget _buildEmptyPatientsState() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_off, size: 64, color: AppColors.gray[400]),
            const SizedBox(height: 16),
            Text(
              'Nenhum paciente cadastrado',
              style: TextStyle(fontSize: 18, color: AppColors.gray[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Cadastre um paciente primeiro',
              style: TextStyle(fontSize: 14, color: AppColors.gray[500]),
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Cadastrar paciente',
              onPressed: () async {
                final result = await Navigator.pushNamed(
                  context,
                  '/patients/create',
                );
                if (result == true) {
                  _controller.initialize(widget.appointment);
                }
              },
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientsList() {
    return Expanded(
      child: ListView.builder(
        itemCount: _controller.formData.patients.length,
        itemBuilder: (context, index) {
          final patient = _controller.formData.patients[index];
          final isSelected =
              _controller.formData.selectedPatient?.id == patient.id;

          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: CustomCard(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                      isSelected
                          ? AppColors.primarySwatch
                          : AppColors.gray[300],
                  child: Icon(
                    Icons.person,
                    color: isSelected ? Colors.white : AppColors.gray[600],
                  ),
                ),
                title: Text(
                  patient.fullName,
                  style: TextStyle(
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                subtitle: Text(
                  '${patient.age} anos • ${_getGuardianName(patient.guardians)}',
                ),
                trailing:
                    isSelected
                        ? Icon(
                          Icons.check_circle,
                          color: AppColors.primarySwatch,
                        )
                        : null,
                onTap: () => _controller.selectPatient(patient),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDateTimeStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Data e horário',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.gray[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Defina quando será a consulta',
            style: TextStyle(fontSize: 16, color: AppColors.gray[600]),
          ),
          const SizedBox(height: 24),
          _buildDateSelector(),
          const SizedBox(height: 16),
          _buildTimeSelector(),
          const SizedBox(height: 16),
          _buildTypeSelector(),
          const SizedBox(height: 16),
          _buildDurationSelector(),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return CustomCard(
      child: ListTile(
        leading: Icon(Icons.calendar_today, color: AppColors.primarySwatch),
        title: const Text('Data da consulta'),
        subtitle: Text(
          _controller.formData.selectedDate != null
              ? DateFormat(
                'dd/MM/yyyy',
              ).format(_controller.formData.selectedDate!)
              : 'Selecionar data',
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () async {
          final date = await showDatePicker(
            context: context,
            initialDate: _controller.formData.selectedDate ?? DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 365)),
          );
          if (date != null) _controller.selectDate(date);
        },
      ),
    );
  }

  Widget _buildTimeSelector() {
    return CustomCard(
      child: ListTile(
        leading: Icon(Icons.access_time, color: AppColors.primarySwatch),
        title: const Text('Horário da consulta'),
        subtitle: Text(
          _controller.formData.selectedTime != null
              ? _controller.formData.selectedTime!.format(context)
              : 'Selecionar horário',
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () async {
          final time = await showTimePicker(
            context: context,
            initialTime:
                _controller.formData.selectedTime ??
                const TimeOfDay(hour: 9, minute: 0),
          );
          if (time != null) _controller.selectTime(time);
        },
      ),
    );
  }

  Widget _buildTypeSelector() {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tipo de consulta',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.gray[800],
              ),
            ),
            const SizedBox(height: 12),
            ...AppointmentType.values.map((type) {
              return RadioListTile<AppointmentType>(
                title: Text(AppointmentTypeHelper.getTypeText(type)),
                value: type,
                groupValue: _controller.formData.selectedType,
                onChanged: (value) => _controller.selectType(value!),
                contentPadding: EdgeInsets.zero,
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationSelector() {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Duração (minutos)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.gray[800],
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              value: _controller.formData.duration,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items:
                  [30, 45, 60, 90, 120].map((duration) {
                    return DropdownMenuItem(
                      value: duration,
                      child: Text('$duration minutos'),
                    );
                  }).toList(),
              onChanged: (value) => _controller.updateDuration(value!),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detalhes da consulta',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.gray[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Informações adicionais e protocolo',
            style: TextStyle(fontSize: 16, color: AppColors.gray[600]),
          ),
          const SizedBox(height: 24),
          _buildProtocolSelector(),
          const SizedBox(height: 16),
          _buildLocationField(),
          const SizedBox(height: 16),
          _buildNotesField(),
        ],
      ),
    );
  }

  Widget _buildProtocolSelector() {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Protocolos (opcional)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.gray[800],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.gray[300]!),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                children: [
                  if (_controller.formData.selectedProtocols.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Nenhum protocolo selecionado',
                        style: TextStyle(
                          color: AppColors.gray[500],
                          fontSize: 14,
                        ),
                      ),
                    )
                  else
                    ..._controller.formData.selectedProtocols.map(
                      (protocol) => ListTile(
                        title: Text(protocol.name),
                        subtitle:
                            protocol.description != null
                                ? Text(protocol.description!)
                                : null,
                        trailing: IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () => _controller.removeProtocol(protocol),
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: DropdownButtonFormField<Protocol>(
                      value: null,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Adicionar protocolo',
                      ),
                      items:
                          _controller.formData.protocols.isEmpty
                              ? []
                              : _controller.formData.protocols
                                  .where(
                                    (p) =>
                                        !_controller.formData.selectedProtocols
                                            .contains(p),
                                  )
                                  .map(
                                    (protocol) => DropdownMenuItem(
                                      value: protocol,
                                      child: Text(protocol.name),
                                    ),
                                  )
                                  .toList(),
                      onChanged:
                          _controller.formData.protocols.isEmpty
                              ? null
                              : (value) {
                                if (value != null) {
                                  _controller.addProtocol(value);
                                }
                              },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationField() {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Local (opcional)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.gray[800],
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              initialValue: _controller.formData.location,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Ex: Consultório 1, Sala de terapia...',
              ),
              onChanged: _controller.updateLocation,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesField() {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Observações (opcional)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.gray[800],
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              initialValue: _controller.formData.notes,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Observações sobre a consulta...',
              ),
              maxLines: 3,
              onChanged: _controller.updateNotes,
            ),
          ],
        ),
      ),
    );
  }
}
