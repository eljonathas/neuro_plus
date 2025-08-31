import 'package:flutter/material.dart';
import 'package:neuro_plus/common/config/theme.dart';
import 'package:neuro_plus/common/widgets/custom_form_field.dart';
import 'package:neuro_plus/common/widgets/keyboard_aware_scroll_view.dart';
import 'package:neuro_plus/models/patient.dart';

class PatientClinicalInfo extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController referralReasonController;
  final TextEditingController referredByController;
  final TextEditingController previousDiagnosisController;
  final TextEditingController cidCodeController;
  final TextEditingController otherComorbiditiesController;
  final TextEditingController otherScreeningsController;
  final bool? previouslyEvaluated;
  final List<String> comorbidities;
  final List<String> screeningsPerformed;
  final ValueChanged<bool?> onPreviouslyEvaluatedChanged;
  final ValueChanged<List<String>> onComorbiditiesChanged;
  final ValueChanged<List<String>> onScreeningsChanged;

  const PatientClinicalInfo({
    super.key,
    required this.formKey,
    required this.referralReasonController,
    required this.referredByController,
    required this.previousDiagnosisController,
    required this.cidCodeController,
    required this.otherComorbiditiesController,
    required this.otherScreeningsController,
    required this.previouslyEvaluated,
    required this.comorbidities,
    required this.screeningsPerformed,
    required this.onPreviouslyEvaluatedChanged,
    required this.onComorbiditiesChanged,
    required this.onScreeningsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
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
            _buildSectionTitle('Informações Clínicas'),

            const SizedBox(height: 16),

            _buildField(
              label: 'Motivo do encaminhamento',
              child: CustomFormField(
                variant: InputVariant.outlined,
                controller: referralReasonController,
                hintText: 'Descreva o motivo do encaminhamento',
                minLines: 2,
                maxLines: 4,
              ),
            ),

            _buildField(
              label: 'Profissional ou entidade que encaminhou',
              child: CustomFormField(
                variant: InputVariant.outlined,
                controller: referredByController,
                hintText:
                    'Ex: Dr. João Silva - Neurologista/Psiquiatra/Clínico Geral',
              ),
            ),

            _buildField(
              label: 'Possui diagnóstico?',
              child: _buildBooleanSelector(
                value: previouslyEvaluated,
                onChanged: onPreviouslyEvaluatedChanged,
              ),
            ),

            if (previouslyEvaluated == true) ...[
              _buildField(
                label: 'Diagnóstico anterior (se houver)',
                child: CustomFormField(
                  variant: InputVariant.outlined,
                  controller: previousDiagnosisController,
                  hintText: 'Descreva o diagnóstico anterior',
                  minLines: 2,
                  maxLines: 3,
                ),
              ),

              _buildField(
                label: 'Código CID (se houver)',
                child: CustomFormField(
                  variant: InputVariant.outlined,
                  controller: cidCodeController,
                  hintText: 'Ex: F84.0, F90.0, Z03.3',
                ),
              ),
            ],

            _buildField(
              label: 'Comorbidades conhecidas',
              child: _buildMultipleChoiceSelector(
                options: PatientEnums.comorbiditiesOptions,
                selectedValues: comorbidities,
                onChanged: onComorbiditiesChanged,
              ),
            ),

            if (comorbidities.contains('Outros'))
              _buildField(
                label: 'Especifique outras comorbidades',
                child: CustomFormField(
                  variant: InputVariant.outlined,
                  controller: otherComorbiditiesController,
                  hintText: 'Descreva outras comorbidades',
                  validator: (value) {
                    if (comorbidities.contains('Outros') &&
                        (value?.trim().isEmpty ?? true)) {
                      return 'Este campo é obrigatório quando "Outros" é selecionado';
                    }
                    return null;
                  },
                ),
              ),

            _buildField(
              label: 'Avaliações já aplicadas',
              child: _buildMultipleChoiceSelector(
                options: PatientEnums.screeningsOptions,
                selectedValues: screeningsPerformed,
                onChanged: onScreeningsChanged,
              ),
            ),

            if (screeningsPerformed.contains('Outros'))
              _buildField(
                label: 'Especifique outras triagens',
                child: CustomFormField(
                  variant: InputVariant.outlined,
                  controller: otherScreeningsController,
                  hintText: 'Descreva outras triagens aplicadas',
                  validator: (value) {
                    if (screeningsPerformed.contains('Outros') &&
                        (value?.trim().isEmpty ?? true)) {
                      return 'Este campo é obrigatório quando "Outros" é selecionado';
                    }
                    return null;
                  },
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

  Widget _buildMultipleChoiceSelector({
    required List<String> options,
    required List<String> selectedValues,
    required ValueChanged<List<String>> onChanged,
  }) {
    return Column(
      children:
          options.map((option) {
            final isSelected = selectedValues.contains(option);
            return CheckboxListTile(
              title: Text(option, style: const TextStyle(fontSize: 14)),
              value: isSelected,
              activeColor: AppColors.primarySwatch,
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              onChanged: (bool? value) {
                final newSelection = List<String>.from(selectedValues);
                if (value == true) {
                  if (!newSelection.contains(option)) {
                    newSelection.add(option);
                  }
                } else {
                  newSelection.remove(option);
                }
                onChanged(newSelection);
              },
            );
          }).toList(),
    );
  }
}
