import 'package:flutter/material.dart';
import 'package:neuro_plus/common/main_layout.dart';
import 'package:neuro_plus/common/services/appointments/appointments_service.dart';
import 'package:neuro_plus/common/services/patients/patients_service.dart';
import 'package:neuro_plus/common/services/protocols/protocol_service.dart';
import 'package:neuro_plus/common/config/theme.dart';
import 'package:neuro_plus/common/widgets/custom_button.dart';
import 'package:neuro_plus/models/appointment.dart';
import 'package:neuro_plus/models/patient.dart';
import 'package:neuro_plus/models/protocol.dart';
import 'package:intl/intl.dart';

class AppointmentsCreateScreen extends StatefulWidget {
  final Appointment? appointment;

  const AppointmentsCreateScreen({super.key, this.appointment});

  @override
  State<AppointmentsCreateScreen> createState() => _AppointmentsCreateScreenState();
}

class _AppointmentsCreateScreenState extends State<AppointmentsCreateScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 3;

  // Controladores dos formulários
  final _formKey = GlobalKey<FormState>();
  
  // Dados da consulta
  Patient? _selectedPatient;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  AppointmentType _selectedType = AppointmentType.evaluation;
  Protocol? _selectedProtocol;
  int _duration = 60;
  String? _location;
  String? _notes;

  // Listas
  List<Patient> _patients = [];
  List<Protocol> _protocols = [];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
    _initializeFromAppointment();
  }

  void _initializeFromAppointment() {
    if (widget.appointment != null) {
      final appointment = widget.appointment!;
      _selectedDate = appointment.date;
      _selectedTime = TimeOfDay(
        hour: int.parse(appointment.time.split(':')[0]),
        minute: int.parse(appointment.time.split(':')[1]),
      );
      _selectedType = appointment.type;
      _duration = appointment.duration;
      _location = appointment.location;
      _notes = appointment.notes;
    }
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    try {
      await PatientsService.init();
      await ProtocolsService.init();
      
      final patients = PatientsService.getAllPatients();
      final protocols = ProtocolsService.getAllProtocols();
      
      if (mounted) {
        setState(() {
          _patients = patients;
          _protocols = protocols;
          
          // Se editando, encontrar o paciente e protocolo
          if (widget.appointment != null) {
            _selectedPatient = patients.firstWhere(
              (p) => p.id == widget.appointment!.patientId,
              orElse: () => patients.first,
            );
            
            if (widget.appointment!.protocolId != null) {
              _selectedProtocol = protocols.firstWhere(
                (p) => p.id == widget.appointment!.protocolId,
                orElse: () => protocols.first,
              );
            }
          }
          
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar dados: $e')),
        );
      }
    }
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      if (_validateCurrentStep()) {
        setState(() => _currentStep++);
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        if (_selectedPatient == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Selecione um paciente')),
          );
          return false;
        }
        return true;
      case 1:
        if (_selectedDate == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Selecione uma data')),
          );
          return false;
        }
        if (_selectedTime == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Selecione um horário')),
          );
          return false;
        }
        
        // Verificar conflitos de horário
        final timeString = '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}';
        if (AppointmentsService.hasTimeConflict(_selectedDate!, timeString, _duration, excludeId: widget.appointment?.id)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Já existe uma consulta agendada neste horário')),
          );
          return false;
        }
        return true;
      case 2:
        return true;
      default:
        return true;
    }
  }

  Future<void> _saveAppointment() async {
    if (!_formKey.currentState!.validate() || !_validateCurrentStep()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final timeString = '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}';
      
      final appointment = Appointment(
        id: widget.appointment?.id,
        patientId: _selectedPatient!.id,
        patientName: _selectedPatient!.fullName,
        date: _selectedDate!,
        time: timeString,
        type: _selectedType,
        protocolId: _selectedProtocol?.id,
        protocolName: _selectedProtocol?.name,
        duration: _duration,
        location: _location,
        notes: _notes,
        status: widget.appointment?.status ?? AppointmentStatus.scheduled,
        protocolResponses: widget.appointment?.protocolResponses,
        createdAt: widget.appointment?.createdAt,
      );

      if (widget.appointment != null) {
        await AppointmentsService.updateAppointment(appointment);
      } else {
        await AppointmentsService.createAppointment(appointment);
      }

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.appointment != null 
                ? 'Consulta atualizada com sucesso!' 
                : 'Consulta agendada com sucesso!'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar consulta: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: widget.appointment != null ? 'Editar consulta' : 'Nova consulta',
      navIndex: 1,
      isBackButtonVisible: true,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildStepIndicator(),
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
                _buildNavigationButtons(),
              ],
            ),
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int index = 0; index < _totalSteps; index++) ...[
            _buildStepCircle(index),
            if (index < _totalSteps - 1) _buildStepConnector(index),
          ],
        ],
      ),
    );
  }

  Widget _buildStepCircle(int index) {
    final isActive = index == _currentStep;
    final isCompleted = index < _currentStep;
    
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCompleted
            ? AppColors.primarySwatch
            : isActive
                ? AppColors.primarySwatch
                : AppColors.gray[300],
        border: Border.all(
          color: isActive || isCompleted 
              ? AppColors.primarySwatch 
              : AppColors.gray[300]!,
          width: 2,
        ),
      ),
      child: Center(
        child: isCompleted
            ? const Icon(Icons.check, color: Colors.white, size: 20)
            : Text(
                '${index + 1}',
                style: TextStyle(
                  color: isActive ? Colors.white : AppColors.gray[600],
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
      ),
    );
  }

  Widget _buildStepConnector(int index) {
    final isCompleted = index < _currentStep;
    
    return Expanded(
      child: Container(
        height: 3,
        margin: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isCompleted
              ? AppColors.primarySwatch
              : AppColors.gray[300],
          borderRadius: BorderRadius.circular(1.5),
        ),
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
            style: TextStyle(
              fontSize: 16,
              color: AppColors.gray[600],
            ),
          ),
          const SizedBox(height: 24),
          if (_patients.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person_off, size: 64, color: AppColors.gray[400]),
                    const SizedBox(height: 16),
                    Text(
                      'Nenhum paciente cadastrado',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.gray[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Cadastre um paciente primeiro',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.gray[500],
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: _patients.length,
                itemBuilder: (context, index) {
                  final patient = _patients[index];
                  final isSelected = _selectedPatient?.id == patient.id;
                  
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isSelected 
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
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                      subtitle: Text('${patient.age} anos • ${patient.guardians}'),
                      trailing: isSelected
                          ? Icon(Icons.check_circle, color: AppColors.primarySwatch)
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedPatient = patient;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
        ],
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
            style: TextStyle(
              fontSize: 16,
              color: AppColors.gray[600],
            ),
          ),
          const SizedBox(height: 24),
          
          // Seleção de data
          Card(
            child: ListTile(
              leading: Icon(Icons.calendar_today, color: AppColors.primarySwatch),
              title: const Text('Data da consulta'),
              subtitle: Text(_selectedDate != null 
                  ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                  : 'Selecionar data'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) {
                  setState(() {
                    _selectedDate = date;
                  });
                }
              },
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Seleção de horário
          Card(
            child: ListTile(
              leading: Icon(Icons.access_time, color: AppColors.primarySwatch),
              title: const Text('Horário da consulta'),
              subtitle: Text(_selectedTime != null 
                  ? _selectedTime!.format(context)
                  : 'Selecionar horário'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: _selectedTime ?? const TimeOfDay(hour: 9, minute: 0),
                );
                if (time != null) {
                  setState(() {
                    _selectedTime = time;
                  });
                }
              },
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Tipo de consulta
          Card(
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
                      title: Text(_getTypeText(type)),
                      value: type,
                      groupValue: _selectedType,
                      onChanged: (value) {
                        setState(() {
                          _selectedType = value!;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                    );
                  }),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Duração
          Card(
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
                    value: _duration,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    items: [30, 45, 60, 90, 120].map((duration) {
                      return DropdownMenuItem(
                        value: duration,
                        child: Text('$duration minutos'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _duration = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
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
            style: TextStyle(
              fontSize: 16,
              color: AppColors.gray[600],
            ),
          ),
          const SizedBox(height: 24),
          
          // Seleção de protocolo
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Protocolo (opcional)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.gray[800],
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<Protocol>(
                    value: _selectedProtocol,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Selecionar protocolo',
                    ),
                    items: [
                      const DropdownMenuItem<Protocol>(
                        value: null,
                        child: Text('Nenhum protocolo'),
                      ),
                      ..._protocols.map((protocol) {
                        return DropdownMenuItem(
                          value: protocol,
                          child: Text(protocol.name),
                        );
                      }),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedProtocol = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Local
          Card(
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
                    initialValue: _location,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Ex: Consultório 1, Sala de terapia...',
                    ),
                    onChanged: (value) {
                      _location = value.isEmpty ? null : value;
                    },
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Observações
          Card(
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
                    initialValue: _notes,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Observações sobre a consulta...',
                    ),
                    maxLines: 3,
                    onChanged: (value) {
                      _notes = value.isEmpty ? null : value;
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: CustomButton(
                text: 'Voltar',
                onPressed: _previousStep,
                backgroundColor: Colors.grey[300],
                foregroundColor: Colors.black87,
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 16),
          Expanded(
            child: CustomButton(
              text: _currentStep == _totalSteps - 1 
                  ? (widget.appointment != null ? 'Atualizar' : 'Agendar')
                  : 'Próximo',
              onPressed: _currentStep == _totalSteps - 1 
                  ? _saveAppointment 
                  : _nextStep,
              isLoading: _isLoading,
            ),
          ),
        ],
      ),
    );
  }

  String _getTypeText(AppointmentType type) {
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
} 