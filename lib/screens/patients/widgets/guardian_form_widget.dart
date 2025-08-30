import 'package:flutter/material.dart';
import 'package:neuro_plus/common/config/theme.dart';
import 'package:neuro_plus/common/widgets/custom_form_field.dart';
import 'package:neuro_plus/common/utils/phone_formatter.dart';
import 'package:neuro_plus/models/patient.dart';

class GuardianFormWidget extends StatefulWidget {
  final int index;
  final Guardian guardian;
  final ValueChanged<Guardian> onGuardianChanged;
  final VoidCallback onRemove;
  final bool canRemove;
  final String? Function(String?) requiredValidator;
  final String? Function(String?) emailValidator;
  final String? Function(String?) phoneValidator;

  const GuardianFormWidget({
    super.key,
    required this.index,
    required this.guardian,
    required this.onGuardianChanged,
    required this.onRemove,
    required this.canRemove,
    required this.requiredValidator,
    required this.emailValidator,
    required this.phoneValidator,
  });

  @override
  State<GuardianFormWidget> createState() => _GuardianFormWidgetState();
}

class _GuardianFormWidgetState extends State<GuardianFormWidget> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _relationshipController;
  late final TextEditingController _addressController;

  @override
  void initState() {
    super.initState();

    // Inicializar controllers com valores do guardian
    _nameController = TextEditingController(text: widget.guardian.name);
    _phoneController = TextEditingController(text: widget.guardian.phone);
    _emailController = TextEditingController(text: widget.guardian.email);
    _relationshipController = TextEditingController(
      text: widget.guardian.relationship,
    );
    _addressController = TextEditingController(text: widget.guardian.address);

    // Adicionar listeners uma única vez
    _nameController.addListener(_onFieldChanged);
    _phoneController.addListener(_onFieldChanged);
    _emailController.addListener(_onFieldChanged);
    _relationshipController.addListener(_onFieldChanged);
    _addressController.addListener(_onFieldChanged);
  }

  @override
  void didUpdateWidget(GuardianFormWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Atualizar controllers apenas se o guardian mudou externamente
    if (oldWidget.guardian != widget.guardian) {
      _updateControllersFromGuardian();
    }
  }

  @override
  void dispose() {
    // Limpar listeners e controllers para evitar memory leaks
    _nameController.removeListener(_onFieldChanged);
    _phoneController.removeListener(_onFieldChanged);
    _emailController.removeListener(_onFieldChanged);
    _relationshipController.removeListener(_onFieldChanged);
    _addressController.removeListener(_onFieldChanged);

    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _relationshipController.dispose();
    _addressController.dispose();

    super.dispose();
  }

  void _updateControllersFromGuardian() {
    if (_nameController.text != widget.guardian.name) {
      _nameController.text = widget.guardian.name;
    }
    if (_phoneController.text != widget.guardian.phone) {
      _phoneController.text = widget.guardian.phone;
    }
    if (_emailController.text != widget.guardian.email) {
      _emailController.text = widget.guardian.email;
    }
    if (_relationshipController.text != widget.guardian.relationship) {
      _relationshipController.text = widget.guardian.relationship;
    }
    if (_addressController.text != widget.guardian.address) {
      _addressController.text = widget.guardian.address;
    }
  }

  void _onFieldChanged() {
    // Criar novo Guardian com valores atuais dos controllers
    final updatedGuardian = widget.guardian.copyWith(
      name: _nameController.text,
      phone: _phoneController.text,
      email: _emailController.text,
      relationship: _relationshipController.text,
      address: _addressController.text,
    );

    // Notificar mudança apenas se houve alteração real
    if (updatedGuardian != widget.guardian) {
      widget.onGuardianChanged(updatedGuardian);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.gray[300]!),
        borderRadius: BorderRadius.circular(8),
        color: AppColors.gray[50],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildNameField(),
          _buildPhoneField(),
          _buildEmailField(),
          _buildRelationshipField(),
          _buildAddressField(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Responsável/Cuidador ${widget.index + 1}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.gray[800],
          ),
        ),
        if (widget.canRemove)
          IconButton(
            onPressed: widget.onRemove,
            icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
            tooltip: 'Remover responsável/cuidador',
          ),
      ],
    );
  }

  Widget _buildNameField() {
    return _buildField(
      label: 'Nome completo *',
      child: CustomFormField(
        variant: InputVariant.outlined,
        controller: _nameController,
        hintText: 'Digite o nome completo',
        validator: widget.requiredValidator,
      ),
    );
  }

  Widget _buildPhoneField() {
    return _buildField(
      label: 'Telefone *',
      child: CustomFormField(
        variant: InputVariant.outlined,
        controller: _phoneController,
        hintText: '(11) 99999-9999',
        inputType: TextInputType.phone,
        validator: widget.phoneValidator,
        inputFormatters: [BrazilianPhoneFormatter()],
      ),
    );
  }

  Widget _buildEmailField() {
    return _buildField(
      label: 'E-mail',
      child: CustomFormField(
        variant: InputVariant.outlined,
        controller: _emailController,
        hintText: 'email@exemplo.com',
        inputType: TextInputType.emailAddress,
        validator: widget.emailValidator,
      ),
    );
  }

  Widget _buildRelationshipField() {
    return _buildField(
      label: 'Parentesco *',
      child: CustomFormField(
        variant: InputVariant.outlined,
        controller: _relationshipController,
        hintText: 'Ex: Mãe, Pai, Avó, Tio, etc.',
        validator: widget.requiredValidator,
      ),
    );
  }

  Widget _buildAddressField() {
    return _buildField(
      label: 'Endereço *',
      child: CustomFormField(
        variant: InputVariant.outlined,
        controller: _addressController,
        hintText: 'Rua, número, bairro, cidade, CEP',
        minLines: 2,
        maxLines: 3,
        validator: widget.requiredValidator,
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
}
