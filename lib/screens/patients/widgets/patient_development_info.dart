import 'package:flutter/material.dart';
import 'package:neuro_plus/common/config/theme.dart';
import 'package:neuro_plus/common/widgets/custom_form_field.dart';
import 'package:neuro_plus/models/patient.dart';

class PatientDevelopmentInfo extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController repetitiveBehaviorsDescriptionController;
  final bool? developmentalDelay;
  final int? firstWordAge;
  final String? eyeContact;
  final bool? repetitiveBehaviors;
  final bool? routineResistance;
  final String? socialInteractionWithChildren;
  final String? sensoryHypersensitivity;
  final ValueChanged<bool?> onDevelopmentalDelayChanged;
  final ValueChanged<int?> onFirstWordAgeChanged;
  final ValueChanged<String?> onEyeContactChanged;
  final ValueChanged<bool?> onRepetitiveBehaviorsChanged;
  final ValueChanged<bool?> onRoutineResistanceChanged;
  final ValueChanged<String?> onSocialInteractionChanged;
  final ValueChanged<String?> onSensoryHypersensitivityChanged;

  const PatientDevelopmentInfo({
    super.key,
    required this.formKey,
    required this.repetitiveBehaviorsDescriptionController,
    required this.developmentalDelay,
    required this.firstWordAge,
    required this.eyeContact,
    required this.repetitiveBehaviors,
    required this.routineResistance,
    required this.socialInteractionWithChildren,
    required this.sensoryHypersensitivity,
    required this.onDevelopmentalDelayChanged,
    required this.onFirstWordAgeChanged,
    required this.onEyeContactChanged,
    required this.onRepetitiveBehaviorsChanged,
    required this.onRoutineResistanceChanged,
    required this.onSocialInteractionChanged,
    required this.onSensoryHypersensitivityChanged,
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
          _buildSectionTitle('Desenvolvimento'),
          const SizedBox(height: 16),
          
          _buildField(
            label: 'Apresentou atraso motor ou de fala?',
            child: _buildBooleanSelector(
              value: developmentalDelay,
              onChanged: onDevelopmentalDelayChanged,
            ),
          ),
          
          _buildField(
            label: 'Idade da primeira palavra (meses)',
            child: _buildNumberField(
              value: firstWordAge,
              onChanged: onFirstWordAgeChanged,
              hintText: 'Ex: 18',
            ),
          ),
          
          _buildField(
            label: 'Contato visual presente?',
            child: _buildSingleChoiceSelector(
              options: PatientEnums.eyeContactOptions,
              selectedValue: eyeContact,
              onChanged: onEyeContactChanged,
            ),
          ),
          
          _buildField(
            label: 'Comportamentos repetitivos observados?',
            child: _buildBooleanSelector(
              value: repetitiveBehaviors,
              onChanged: onRepetitiveBehaviorsChanged,
            ),
          ),
          
          if (repetitiveBehaviors == true)
            _buildField(
              label: 'Descrição dos comportamentos repetitivos',
              child: CustomFormField(
                variant: InputVariant.outlined,
                controller: repetitiveBehaviorsDescriptionController,
                hintText: 'Descreva os comportamentos observados',
                minLines: 2,
                maxLines: 4,
              ),
            ),
          
          _buildField(
            label: 'Apresenta resistência à mudança/rotinas?',
            child: _buildBooleanSelector(
              value: routineResistance,
              onChanged: onRoutineResistanceChanged,
            ),
          ),
          
          _buildField(
            label: 'Brinca com outras crianças?',
            child: _buildSingleChoiceSelector(
              options: PatientEnums.socialInteractionOptions,
              selectedValue: socialInteractionWithChildren,
              onChanged: onSocialInteractionChanged,
            ),
          ),
          
          _buildField(
            label: 'Sensory hypersensitivity present?',
            child: _buildSingleChoiceSelector(
              options: PatientEnums.sensoryHypersensitivityOptions,
              selectedValue: sensoryHypersensitivity,
              onChanged: onSensoryHypersensitivityChanged,
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

  Widget _buildNumberField({
    required int? value,
    required ValueChanged<int?> onChanged,
    required String hintText,
  }) {
    final controller = TextEditingController(
      text: value?.toString() ?? '',
    );

    return CustomFormField(
      variant: InputVariant.outlined,
      controller: controller,
      hintText: hintText,
      inputType: TextInputType.number,
      validator: (value) {
        if (value?.isEmpty ?? true) return null;
        final number = int.tryParse(value!);
        if (number == null) return 'Digite um número válido';
        if (number < 0 || number > 120) return 'Digite um valor entre 0 e 120 meses';
        return null;
      },
    );
  }
} 