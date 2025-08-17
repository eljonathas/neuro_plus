import 'package:flutter/material.dart';
import 'package:neuro_plus/common/widgets/custom_form_field.dart';

class ProtocolBasicFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final String? Function(String?) nameValidator;

  const ProtocolBasicFields({
    super.key,
    required this.nameController,
    required this.descriptionController,
    required this.nameValidator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Nome do protocolo'),
        const SizedBox(height: 8),
        CustomFormField(
          controller: nameController,
          variant: InputVariant.outlined,
          hintText: 'Digite o nome do protocolo',
          validator: nameValidator,
        ),
        const SizedBox(height: 24),
        const Text('Descrição (opcional)'),
        const SizedBox(height: 8),
        CustomFormField(
          variant: InputVariant.outlined,
          controller: descriptionController,
          hintText: 'Digite a descrição do protocolo',
          minLines: 3,
          maxLines: 10,
        ),
      ],
    );
  }
}
