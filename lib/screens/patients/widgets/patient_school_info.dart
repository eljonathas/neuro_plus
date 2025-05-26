import 'package:flutter/material.dart';
import 'package:neuro_plus/common/config/theme.dart';
import 'package:neuro_plus/common/widgets/custom_form_field.dart';
import 'package:neuro_plus/models/patient.dart';

class PatientSchoolInfo extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController schoolObservationsController;
  final TextEditingController guardiansObservationsController;
  final bool? attendsSchool;
  final String? schoolType;
  final String? schoolShift;
  final String? hasMediator;
  final ValueChanged<bool?> onAttendsSchoolChanged;
  final ValueChanged<String?> onSchoolTypeChanged;
  final ValueChanged<String?> onSchoolShiftChanged;
  final ValueChanged<String?> onHasMediatorChanged;

  const PatientSchoolInfo({
    super.key,
    required this.formKey,
    required this.schoolObservationsController,
    required this.guardiansObservationsController,
    required this.attendsSchool,
    required this.schoolType,
    required this.schoolShift,
    required this.hasMediator,
    required this.onAttendsSchoolChanged,
    required this.onSchoolTypeChanged,
    required this.onSchoolShiftChanged,
    required this.onHasMediatorChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          _buildSectionTitle('Informações Escolares'),
          const SizedBox(height: 16),
          
          _buildField(
            label: 'Está matriculada na escola?',
            child: _buildBooleanSelector(
              value: attendsSchool,
              onChanged: onAttendsSchoolChanged,
            ),
          ),
          
          if (attendsSchool == true) ...[
            _buildField(
              label: 'Tipo de escola',
              child: _buildSingleChoiceSelector(
                options: PatientEnums.schoolTypeOptions,
                selectedValue: schoolType,
                onChanged: onSchoolTypeChanged,
              ),
            ),
            
            _buildField(
              label: 'Turno escolar',
              child: _buildSingleChoiceSelector(
                options: PatientEnums.schoolShiftOptions,
                selectedValue: schoolShift,
                onChanged: onSchoolShiftChanged,
              ),
            ),
            
            _buildField(
              label: 'Possui mediador escolar?',
              child: _buildSingleChoiceSelector(
                options: PatientEnums.mediatorOptions,
                selectedValue: hasMediator,
                onChanged: onHasMediatorChanged,
              ),
            ),
            
            _buildField(
              label: 'Observações escolares',
              child: CustomFormField(
                variant: InputVariant.outlined,
                controller: schoolObservationsController,
                hintText: 'Descreva observações sobre o comportamento na escola, dificuldades, progressos, etc.',
                minLines: 3,
                maxLines: 6,
              ),
            ),
          ],
          
          const SizedBox(height: 24),
          _buildSectionTitle('Observações Gerais'),
          const SizedBox(height: 16),
          
          _buildField(
            label: 'Observações dos responsáveis',
            child: CustomFormField(
              variant: InputVariant.outlined,
              controller: guardiansObservationsController,
              hintText: 'Adicione qualquer informação adicional que considere importante sobre a criança',
              minLines: 3,
              maxLines: 6,
            ),
          ),
          
          const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.gray[800],
      ),
    );
  }

  Widget _buildField({required String label, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Widget _buildBooleanSelector({
    required bool? value,
    required ValueChanged<bool?> onChanged,
  }) {
    return Row(
      children: [
        _buildRadioOption(
          label: 'Sim',
          value: true,
          groupValue: value,
          onChanged: onChanged,
        ),
        const SizedBox(width: 24),
        _buildRadioOption(
          label: 'Não',
          value: false,
          groupValue: value,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildSingleChoiceSelector({
    required List<String> options,
    required String? selectedValue,
    required ValueChanged<String?> onChanged,
  }) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: options.map((option) {
        return _buildRadioOption(
          label: option,
          value: option,
          groupValue: selectedValue,
          onChanged: onChanged,
        );
      }).toList(),
    );
  }

  Widget _buildRadioOption<T>({
    required String label,
    required T value,
    required T? groupValue,
    required ValueChanged<T?> onChanged,
  }) {
    final isSelected = value == groupValue;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<T>(
            value: value,
            groupValue: groupValue,
            activeColor: AppColors.primarySwatch,
            visualDensity: VisualDensity.compact,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onChanged: onChanged,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isSelected ? AppColors.primarySwatch : Colors.black87,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
} 