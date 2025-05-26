import 'package:flutter/material.dart';
import 'package:neuro_plus/common/config/theme.dart';
import 'package:neuro_plus/common/widgets/custom_form_field.dart';
import 'package:neuro_plus/models/patient.dart';
import 'package:intl/intl.dart';

class PatientBasicInfo extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController fullNameController;
  final TextEditingController guardiansController;
  final TextEditingController contactPhoneController;
  final TextEditingController contactEmailController;
  final TextEditingController addressController;
  final DateTime birthDate;
  final String gender;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<String> onGenderChanged;
  final String? Function(String?) requiredValidator;
  final String? Function(String?) emailValidator;
  final String? Function(String?) phoneValidator;

  const PatientBasicInfo({
    super.key,
    required this.formKey,
    required this.fullNameController,
    required this.guardiansController,
    required this.contactPhoneController,
    required this.contactEmailController,
    required this.addressController,
    required this.birthDate,
    required this.gender,
    required this.onDateChanged,
    required this.onGenderChanged,
    required this.requiredValidator,
    required this.emailValidator,
    required this.phoneValidator,
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
          _buildSectionTitle('Informações Básicas'),
          const SizedBox(height: 16),
          
          _buildField(
            label: 'Nome completo da criança *',
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
          
          _buildField(
            label: 'Sexo *',
            child: _buildGenderSelector(),
          ),
          
          _buildField(
            label: 'Nome do(s) responsável(is) *',
            child: CustomFormField(
              variant: InputVariant.outlined,
              controller: guardiansController,
              hintText: 'Digite o nome dos responsáveis',
              validator: requiredValidator,
            ),
          ),
          
          _buildField(
            label: 'Telefone de contato *',
            child: CustomFormField(
              variant: InputVariant.outlined,
              controller: contactPhoneController,
              hintText: '(11) 99999-9999',
              inputType: TextInputType.phone,
              validator: phoneValidator,
            ),
          ),
          
          _buildField(
            label: 'E-mail do responsável',
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

  Widget _buildDateField(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    
    return InkWell(
      onTap: () => _selectDate(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.gray[300]!),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                dateFormat.format(birthDate),
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Icon(Icons.calendar_today, color: AppColors.gray[600]),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Wrap(
      spacing: 16,
      children: PatientEnums.genderOptions.map((option) {
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
                  color: isSelected ? AppColors.primarySwatch : Colors.black87,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
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
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      locale: const Locale('pt', 'BR'),
    );
    
    if (picked != null && picked != birthDate) {
      onDateChanged(picked);
    }
  }
} 