import 'package:flutter/material.dart';
import 'package:neuro_plus/common/config/theme.dart';
import 'package:neuro_plus/common/widgets/custom_form_field.dart';
import 'package:neuro_plus/models/patient.dart';

class PatientDevelopmentInfo extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController repetitiveBehaviorsDescriptionController;
  final TextEditingController developmentalDelayController;
  final TextEditingController firstWordAgeController;
  final TextEditingController eyeContactController;
  final TextEditingController repetitiveBehaviorsController;
  final TextEditingController routineResistanceController;
  final TextEditingController socialInteractionController;
  final TextEditingController sensoryHypersensitivityController;

  const PatientDevelopmentInfo({
    super.key,
    required this.formKey,
    required this.repetitiveBehaviorsDescriptionController,
    required this.developmentalDelayController,
    required this.firstWordAgeController,
    required this.eyeContactController,
    required this.repetitiveBehaviorsController,
    required this.routineResistanceController,
    required this.socialInteractionController,
    required this.sensoryHypersensitivityController,
  });

  @override
  State<PatientDevelopmentInfo> createState() => _PatientDevelopmentInfoState();
}

class _PatientDevelopmentInfoState extends State<PatientDevelopmentInfo> {
  @override
  void initState() {
    super.initState();
    // Adiciona listeners para rebuilds automáticos
    widget.developmentalDelayController.addListener(_onControllerChanged);
    widget.eyeContactController.addListener(_onControllerChanged);
    widget.repetitiveBehaviorsController.addListener(_onControllerChanged);
    widget.routineResistanceController.addListener(_onControllerChanged);
    widget.socialInteractionController.addListener(_onControllerChanged);
    widget.sensoryHypersensitivityController.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    // Remove os listeners
    widget.developmentalDelayController.removeListener(_onControllerChanged);
    widget.eyeContactController.removeListener(_onControllerChanged);
    widget.repetitiveBehaviorsController.removeListener(_onControllerChanged);
    widget.routineResistanceController.removeListener(_onControllerChanged);
    widget.socialInteractionController.removeListener(_onControllerChanged);
    widget.sensoryHypersensitivityController.removeListener(
      _onControllerChanged,
    );
    super.dispose();
  }

  void _onControllerChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
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
                controller: widget.developmentalDelayController,
              ),
            ),

            _buildField(
              label: 'Idade da primeira palavra (meses)',
              child: CustomFormField(
                variant: InputVariant.outlined,
                controller: widget.firstWordAgeController,
                hintText: 'Ex: 18',
                inputType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) return null;
                  final number = int.tryParse(value!);
                  if (number == null) return 'Digite um número válido';
                  if (number < 0 || number > 120)
                    return 'Digite um valor entre 0 e 120 meses';
                  return null;
                },
              ),
            ),

            _buildField(
              label: 'Contato visual presente?',
              child: _buildSingleChoiceSelector(
                options: PatientEnums.eyeContactOptions,
                controller: widget.eyeContactController,
              ),
            ),

            _buildField(
              label: 'Comportamentos repetitivos observados?',
              child: _buildBooleanSelector(
                controller: widget.repetitiveBehaviorsController,
              ),
            ),

            if (widget.repetitiveBehaviorsController.text == 'true')
              _buildField(
                label: 'Descrição dos comportamentos repetitivos',
                child: CustomFormField(
                  variant: InputVariant.outlined,
                  controller: widget.repetitiveBehaviorsDescriptionController,
                  hintText: 'Descreva os comportamentos observados',
                  minLines: 2,
                  maxLines: 4,
                ),
              ),

            _buildField(
              label: 'Apresenta resistência à mudança/rotinas?',
              child: _buildBooleanSelector(
                controller: widget.routineResistanceController,
              ),
            ),

            _buildField(
              label: 'Brinca com outras crianças?',
              child: _buildSingleChoiceSelector(
                options: PatientEnums.socialInteractionOptions,
                controller: widget.socialInteractionController,
              ),
            ),

            _buildField(
              label: 'Sensory hypersensitivity present?',
              child: _buildSingleChoiceSelector(
                options: PatientEnums.sensoryHypersensitivityOptions,
                controller: widget.sensoryHypersensitivityController,
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

  Widget _buildBooleanSelector({required TextEditingController controller}) {
    final value =
        controller.text == 'true'
            ? true
            : (controller.text == 'false' ? false : null);

    return Row(
      children: [
        _buildRadioOption(
          label: 'Sim',
          value: true,
          groupValue: value,
          onChanged: (val) => controller.text = val.toString(),
        ),
        const SizedBox(width: 24),
        _buildRadioOption(
          label: 'Não',
          value: false,
          groupValue: value,
          onChanged: (val) => controller.text = val.toString(),
        ),
      ],
    );
  }

  Widget _buildSingleChoiceSelector({
    required List<String> options,
    required TextEditingController controller,
  }) {
    final selectedValue = controller.text.isEmpty ? null : controller.text;

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children:
          options.map((option) {
            return _buildRadioOption(
              label: option,
              value: option,
              groupValue: selectedValue,
              onChanged: (val) => controller.text = val ?? '',
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
