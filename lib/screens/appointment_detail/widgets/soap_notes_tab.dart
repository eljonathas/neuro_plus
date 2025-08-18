import 'package:flutter/material.dart';
import 'package:neuro_plus/common/config/theme.dart';
import 'package:neuro_plus/common/widgets/custom_card.dart';
import 'package:neuro_plus/models/appointment.dart';
import 'package:neuro_plus/common/services/appointments/appointments_service.dart';

class SoapNotesTab extends StatefulWidget {
  final Appointment appointment;
  final VoidCallback? onNotesUpdated;

  const SoapNotesTab({
    super.key,
    required this.appointment,
    this.onNotesUpdated,
  });

  @override
  State<SoapNotesTab> createState() => _SoapNotesTabState();
}

class _SoapNotesTabState extends State<SoapNotesTab> {
  final _subjectiveController = TextEditingController();
  final _objectiveController = TextEditingController();
  final _assessmentController = TextEditingController();
  final _planController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadExistingNotes();
  }

  @override
  void dispose() {
    _subjectiveController.dispose();
    _objectiveController.dispose();
    _assessmentController.dispose();
    _planController.dispose();
    super.dispose();
  }

  void _loadExistingNotes() {
    _subjectiveController.text = widget.appointment.soapSubjective ?? '';
    _objectiveController.text = widget.appointment.soapObjective ?? '';
    _assessmentController.text = widget.appointment.soapAssessment ?? '';
    _planController.text = widget.appointment.soapPlan ?? '';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.appointment.status == AppointmentStatus.scheduled) {
      return _buildScheduledState();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 100,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSoapField(
              'Subjetivo (S)',
              _subjectiveController,
              'Relato do paciente/responsável',
            ),
            const SizedBox(height: 16),
            _buildSoapField(
              'Objetivo (O)',
              _objectiveController,
              'Achados observáveis/medidas',
            ),
            const SizedBox(height: 16),
            _buildSoapField(
              'Avaliação (A)',
              _assessmentController,
              'Interpretação clínica',
            ),
            const SizedBox(height: 16),
            _buildSoapField(
              'Plano (P)',
              _planController,
              'Próximos passos/condutas',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduledState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.schedule, size: 64, color: AppColors.gray[400]),
          const SizedBox(height: 16),
          Text(
            'Consulta ainda não iniciada',
            style: TextStyle(fontSize: 18, color: AppColors.gray[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'As notas SOAP podem ser preenchidas quando a consulta estiver em andamento.',
            style: TextStyle(fontSize: 14, color: AppColors.gray[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSoapField(
    String title,
    TextEditingController controller,
    String hint,
  ) {
    final isCompleted =
        widget.appointment.status == AppointmentStatus.completed;

    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.gray[800],
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: controller,
              enabled: !isCompleted,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: hint,
                filled: isCompleted,
                fillColor: isCompleted ? AppColors.gray[100] : null,
              ),
              maxLines: 4,
              style: TextStyle(
                fontSize: 14,
                color: isCompleted ? AppColors.gray[600] : AppColors.gray[700],
              ),
              onChanged: isCompleted ? null : (_) => _saveNotes(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveNotes() async {
    if (_isSaving) return;

    setState(() => _isSaving = true);

    try {
      final updatedAppointment = widget.appointment.copyWith(
        soapSubjective:
            _subjectiveController.text.trim().isEmpty
                ? null
                : _subjectiveController.text.trim(),
        soapObjective:
            _objectiveController.text.trim().isEmpty
                ? null
                : _objectiveController.text.trim(),
        soapAssessment:
            _assessmentController.text.trim().isEmpty
                ? null
                : _assessmentController.text.trim(),
        soapPlan:
            _planController.text.trim().isEmpty
                ? null
                : _planController.text.trim(),
      );

      await AppointmentsService.updateAppointment(updatedAppointment);

      if (mounted) {
        widget.onNotesUpdated?.call();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar notas: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}
