import 'package:flutter/material.dart';
import 'package:neuro_plus/common/config/theme.dart';
import 'package:neuro_plus/common/widgets/custom_form_field.dart';
import 'package:neuro_plus/common/widgets/keyboard_aware_scroll_view.dart';
import 'package:neuro_plus/common/widgets/tri_state_selector.dart';
import 'package:neuro_plus/models/patient.dart';

class PatientDevelopmentInfo extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final String gender;
  final TextEditingController repetitiveBehaviorsDescriptionController;
  final TextEditingController guardiansObservationsController;
  final TextEditingController developmentalDelayController;
  final TextEditingController motorDelayController;
  final TextEditingController speechDelayController;
  final TextEditingController sittingAgeMonthsController;
  final TextEditingController firstStepAgeMonthsController;
  final TextEditingController languageRegressionController;
  final TextEditingController languageRegressionDescriptionController;
  final TextEditingController feedingSelectivityController;
  final TextEditingController feedingSelectivityDescriptionController;
  final TextEditingController sensoryChangesController;
  final TextEditingController sensoryChangesDescriptionController;
  final TextEditingController firstWordAgeController;
  final TextEditingController eyeContactController;
  final TextEditingController repetitiveBehaviorsController;
  final TextEditingController routineResistanceController;
  final TextEditingController socialInteractionController;
  final TextEditingController sensoryHypersensitivityController;

  const PatientDevelopmentInfo({
    super.key,
    required this.formKey,
    required this.gender,
    required this.repetitiveBehaviorsDescriptionController,
    required this.guardiansObservationsController,
    required this.developmentalDelayController,
    required this.motorDelayController,
    required this.speechDelayController,
    required this.sittingAgeMonthsController,
    required this.firstStepAgeMonthsController,
    required this.languageRegressionController,
    required this.languageRegressionDescriptionController,
    required this.feedingSelectivityController,
    required this.feedingSelectivityDescriptionController,
    required this.sensoryChangesController,
    required this.sensoryChangesDescriptionController,
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
    widget.motorDelayController.addListener(_onControllerChanged);
    widget.speechDelayController.addListener(_onControllerChanged);
    widget.languageRegressionController.addListener(_onControllerChanged);
    widget.feedingSelectivityController.addListener(_onControllerChanged);
    widget.sensoryChangesController.addListener(_onControllerChanged);
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
    widget.motorDelayController.removeListener(_onControllerChanged);
    widget.speechDelayController.removeListener(_onControllerChanged);
    widget.languageRegressionController.removeListener(_onControllerChanged);
    widget.feedingSelectivityController.removeListener(_onControllerChanged);
    widget.sensoryChangesController.removeListener(_onControllerChanged);
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
      child: KeyboardAwareScrollView(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: 32,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Desenvolvimento'),

            const SizedBox(height: 16),

            _buildField(
              label: 'Atraso motor',
              child: TriStateSelector(controller: widget.motorDelayController),
            ),

            _buildField(
              label: 'Atraso de linguagem',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TriStateSelector(controller: widget.speechDelayController),
                ],
              ),
            ),

            if (widget.speechDelayController.text == 'true')
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
                    if (number < 0 || number > 120) {
                      return 'Digite um valor entre 0 e 120 meses';
                    }
                    return null;
                  },
                ),
              ),

            _buildField(
              label: 'Quando sentou? (meses)',
              child: CustomFormField(
                variant: InputVariant.outlined,
                controller: widget.sittingAgeMonthsController,
                hintText: 'Ex: 6',
                inputType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) return null;
                  final number = int.tryParse(value!);
                  if (number == null) return 'Digite um número válido';
                  if (number < 0 || number > 24) {
                    return 'Digite um valor entre 0 e 24 meses';
                  }
                  return null;
                },
              ),
            ),

            _buildField(
              label: 'Idade do primeiro passo (meses)',
              child: CustomFormField(
                variant: InputVariant.outlined,
                controller: widget.firstStepAgeMonthsController,
                hintText: 'Ex: 12',
                inputType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) return null;
                  final number = int.tryParse(value!);
                  if (number == null) return 'Digite um número válido';
                  if (number < 0 || number > 48) {
                    return 'Digite um valor entre 0 e 48 meses';
                  }
                  return null;
                },
              ),
            ),

            _buildField(
              label: 'Mantém contato visual?',
              child: _buildSingleChoiceSelector(
                options: PatientEnums.eyeContactOptions,
                controller: widget.eyeContactController,
              ),
            ),

            _buildField(
              label: 'Comportamentos repetitivos observados?',
              child: TriStateSelector(
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
              child: TriStateSelector(
                controller: widget.routineResistanceController,
              ),
            ),

            _buildField(
              label: 'Interage com outras pessoas?',
              child: _buildSingleChoiceSelector(
                options: PatientEnums.socialInteractionOptions,
                controller: widget.socialInteractionController,
              ),
            ),

            _buildField(
              label: 'Perda de vocabulário (regressão de linguagem)?',
              child: TriStateSelector(
                controller: widget.languageRegressionController,
              ),
            ),

            if (widget.languageRegressionController.text == 'true')
              _buildField(
                label: 'Descreva a perda de vocabulário',
                child: CustomFormField(
                  variant: InputVariant.outlined,
                  controller: widget.languageRegressionDescriptionController,
                  hintText: 'Descreva brevemente',
                  minLines: 2,
                  maxLines: 4,
                ),
              ),

            _buildField(
              label: 'Seletividade alimentar presente?',
              child: TriStateSelector(
                controller: widget.feedingSelectivityController,
              ),
            ),

            if (widget.feedingSelectivityController.text == 'true')
              _buildField(
                label: 'Descreva a seletividade alimentar',
                child: CustomFormField(
                  variant: InputVariant.outlined,
                  controller: widget.feedingSelectivityDescriptionController,
                  hintText: 'Descreva brevemente',
                  minLines: 2,
                  maxLines: 4,
                ),
              ),

            _buildField(
              label: 'Alterações sensoriais presentes?',
              child: TriStateSelector(
                controller: widget.sensoryChangesController,
              ),
            ),

            if (widget.sensoryChangesController.text == 'true')
              _buildField(
                label: 'Descreva as alterações sensoriais',
                child: CustomFormField(
                  variant: InputVariant.outlined,
                  controller: widget.sensoryChangesDescriptionController,
                  hintText: 'Descreva brevemente',
                  minLines: 2,
                  maxLines: 4,
                ),
              ),

            const SizedBox(height: 24),
            _buildSectionTitle('Observações Gerais'),
            const SizedBox(height: 16),

            _buildField(
              label: 'Observações dos responsáveis/cuidadores',
              child: CustomFormField(
                variant: InputVariant.outlined,
                controller: widget.guardiansObservationsController,
                hintText:
                    'Adicione qualquer informação adicional que considere importante sobre a pessoa',
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
