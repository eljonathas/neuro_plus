import 'package:flutter/material.dart';
import 'package:neuro_plus/common/config/theme.dart';
import 'package:neuro_plus/common/widgets/custom_form_field.dart';
import 'package:neuro_plus/common/widgets/keyboard_aware_scroll_view.dart';
import 'package:neuro_plus/models/patient.dart';

class PatientSchoolInfo extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController schoolObservationsController;
  final TextEditingController schoolNameController;
  final TextEditingController teacherNameController;
  final TextEditingController otherSchoolTypeController;
  final bool? attendsSchool;
  final String? schoolType;
  final String? schoolShift;
  final String? hasCompanion;
  final ValueChanged<bool?> onAttendsSchoolChanged;
  final ValueChanged<String?> onSchoolTypeChanged;
  final ValueChanged<String?> onSchoolShiftChanged;
  final ValueChanged<String?> onHasCompanionChanged;

  const PatientSchoolInfo({
    super.key,
    required this.formKey,
    required this.schoolObservationsController,
    required this.schoolNameController,
    required this.teacherNameController,
    required this.otherSchoolTypeController,
    required this.attendsSchool,
    required this.schoolType,
    required this.schoolShift,
    required this.hasCompanion,
    required this.onAttendsSchoolChanged,
    required this.onSchoolTypeChanged,
    required this.onSchoolShiftChanged,
    required this.onHasCompanionChanged,
  });

  @override
  State<PatientSchoolInfo> createState() => _PatientSchoolInfoState();
}

class _PatientSchoolInfoState extends State<PatientSchoolInfo> {
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
            _buildSectionTitle('Informações Educacionais'),
            const SizedBox(height: 16),

            _buildField(
              label: 'Está matriculado(a) em instituição de ensino?',
              child: _buildBooleanSelector(
                value: widget.attendsSchool,
                onChanged: widget.onAttendsSchoolChanged,
              ),
            ),

            if (widget.attendsSchool == true) ...[
              _buildField(
                label: 'Nome da instituição de ensino',
                child: CustomFormField(
                  variant: InputVariant.outlined,
                  controller: widget.schoolNameController,
                  hintText: 'Digite o nome da instituição de ensino',
                ),
              ),

              _buildField(
                label: 'Tipo de instituição',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSingleChoiceSelector(
                      options: PatientEnums.schoolTypeOptions,
                      selectedValue: widget.schoolType,
                      onChanged: widget.onSchoolTypeChanged,
                    ),
                    if (widget.schoolType == 'Outra')
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: CustomFormField(
                          variant: InputVariant.outlined,
                          controller: widget.otherSchoolTypeController,
                          hintText: 'Especifique o tipo de instituição',
                        ),
                      ),
                  ],
                ),
              ),

              _buildField(
                label: 'Turno de estudos',
                child: _buildSingleChoiceSelector(
                  options: PatientEnums.schoolShiftOptions,
                  selectedValue: widget.schoolShift,
                  onChanged: widget.onSchoolShiftChanged,
                ),
              ),

              _buildField(
                label: 'Nome do professor(a)',
                child: CustomFormField(
                  variant: InputVariant.outlined,
                  controller: widget.teacherNameController,
                  hintText: 'Digite o nome do(a) professor(a)',
                ),
              ),

              _buildField(
                label: 'Possui acompanhante educacional?',
                child: _buildSingleChoiceSelector(
                  options: PatientEnums.companionOptions,
                  selectedValue: widget.hasCompanion,
                  onChanged: widget.onHasCompanionChanged,
                ),
              ),

              _buildField(
                label: 'Observações educacionais',
                child: CustomFormField(
                  variant: InputVariant.outlined,
                  controller: widget.schoolObservationsController,
                  hintText:
                      'Descreva observações sobre o comportamento na instituição de ensino, dificuldades, progressos, etc.',
                  minLines: 3,
                  maxLines: 6,
                ),
              ),
            ],

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
      children:
          options.map((option) {
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
