import 'package:flutter/material.dart';
import 'package:neuro_plus/common/config/theme.dart';
import 'package:neuro_plus/common/widgets/custom_form_field.dart';
import 'package:neuro_plus/common/widgets/custom_button.dart';
import 'package:neuro_plus/common/utils/phone_formatter.dart';
import 'package:neuro_plus/common/utils/date_formatter.dart';
import 'package:neuro_plus/models/patient.dart';
import 'package:neuro_plus/screens/patients/widgets/guardian_form_widget.dart';
import 'package:neuro_plus/common/widgets/keyboard_aware_scroll_view.dart';

class PatientBasicInfo extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController fullNameController;
  final TextEditingController contactPhoneController;
  final TextEditingController contactEmailController;
  final TextEditingController addressController;
  final TextEditingController birthDateController;
  final List<Guardian> guardians;
  final DateTime birthDate;
  final String gender;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<String> onGenderChanged;
  final ValueChanged<List<Guardian>> onGuardiansChanged;
  final String? Function(String?) requiredValidator;
  final String? Function(String?) emailValidator;
  final String? Function(String?) phoneValidator;

  const PatientBasicInfo({
    super.key,
    required this.formKey,
    required this.fullNameController,
    required this.contactPhoneController,
    required this.contactEmailController,
    required this.addressController,
    required this.birthDateController,
    required this.guardians,
    required this.birthDate,
    required this.gender,
    required this.onDateChanged,
    required this.onGenderChanged,
    required this.onGuardiansChanged,
    required this.requiredValidator,
    required this.emailValidator,
    required this.phoneValidator,
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
            _buildSectionTitle('Informações Básicas'),
            const SizedBox(height: 16),

            _buildField(
              label: 'Nome completo *',
              child: CustomFormField(
                variant: InputVariant.outlined,
                controller: fullNameController,
                hintText: 'Digite o nome completo',
                validator: requiredValidator,
              ),
            ),

            _buildField(
              label: 'Data de nascimento *',
              child: _buildDateField(context),
            ),

            _buildField(label: 'Sexo *', child: _buildGenderSelector()),

            _buildField(
              label: 'Telefone de contato *',
              child: CustomFormField(
                variant: InputVariant.outlined,
                controller: contactPhoneController,
                hintText: '(11) 99999-9999',
                inputType: TextInputType.phone,
                validator: phoneValidator,
                inputFormatters: [BrazilianPhoneFormatter()],
              ),
            ),

            _buildField(
              label: 'E-mail de contato',
              child: CustomFormField(
                variant: InputVariant.outlined,
                controller: contactEmailController,
                hintText: 'email@exemplo.com',
                inputType: TextInputType.emailAddress,
                validator: emailValidator,
              ),
            ),

            _buildField(
              label: 'Endereço completo *',
              child: CustomFormField(
                variant: InputVariant.outlined,
                controller: addressController,
                hintText: 'Rua, número, bairro, cidade, CEP',
                minLines: 2,
                maxLines: 3,
                validator: requiredValidator,
              ),
            ),

            const SizedBox(height: 32),
            _buildGuardiansSection(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildGuardiansSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionTitle('Responsáveis'),
            CustomButton(
              text: '+ Adicionar Responsável',
              onPressed: _addGuardian,
              backgroundColor: Colors.grey[200],
              foregroundColor: AppColors.primarySwatch,
              fontSize: 14,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...guardians.asMap().entries.map((entry) {
          final index = entry.key;
          final guardian = entry.value;
          return GuardianFormWidget(
            key: ValueKey(guardian.id),
            index: index,
            guardian: guardian,
            onGuardianChanged:
                (updatedGuardian) => _updateGuardian(index, updatedGuardian),
            onRemove: () => _removeGuardian(index),
            canRemove: guardians.length > 1,
            requiredValidator: requiredValidator,
            emailValidator: emailValidator,
            phoneValidator: phoneValidator,
          );
        }),
      ],
    );
  }

  void _addGuardian() {
    final newGuardians = List<Guardian>.from(guardians);
    newGuardians.add(
      Guardian(name: '', phone: '', email: '', relationship: '', address: ''),
    );
    onGuardiansChanged(newGuardians);
  }

  void _removeGuardian(int index) {
    if (guardians.length > 1) {
      final newGuardians = List<Guardian>.from(guardians);
      newGuardians.removeAt(index);
      onGuardiansChanged(newGuardians);
    }
  }

  void _updateGuardian(int index, Guardian guardian) {
    final newGuardians = List<Guardian>.from(guardians);
    newGuardians[index] = guardian;
    onGuardiansChanged(newGuardians);
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

  Widget _buildDateField(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomFormField(
            variant: InputVariant.outlined,
            controller: birthDateController,
            hintText: 'DD/MM/AAAA',
            inputType: TextInputType.number,
            inputFormatters: [BrazilianDateFormatter()],
            validator: (value) {
              final dateError = BrazilianDateValidator.validate(value);
              if (dateError != null) return dateError;

              // Atualizar a data se válida
              final parsedDate = BrazilianDateValidator.parseDate(value);
              if (parsedDate != null && parsedDate != birthDate) {
                // Usar Future.microtask para evitar setState durante build
                Future.microtask(() => onDateChanged(parsedDate));
              }

              return null;
            },
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () => _selectDate(context),
          icon: Icon(Icons.calendar_today, color: AppColors.gray[600]),
          tooltip: 'Selecionar data',
        ),
      ],
    );
  }

  Widget _buildGenderSelector() {
    return Wrap(
      spacing: 16,
      children:
          PatientEnums.genderOptions.map((option) {
            final isSelected = gender == option;
            return GestureDetector(
              onTap: () => onGenderChanged(option),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio<String>(
                    value: option,
                    groupValue: gender,
                    activeColor: AppColors.primarySwatch,
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onChanged: (value) => onGenderChanged(value!),
                  ),
                  Text(
                    option,
                    style: TextStyle(
                      fontSize: 14,
                      color:
                          isSelected ? AppColors.primarySwatch : Colors.black87,
                      fontWeight:
                          isSelected ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: birthDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('pt', 'BR'),
    );

    if (picked != null && picked != birthDate) {
      // Atualizar o controller com a data formatada
      birthDateController.text = BrazilianDateValidator.formatDate(picked);
      onDateChanged(picked);
    }
  }
}
