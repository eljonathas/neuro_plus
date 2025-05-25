import 'package:flutter/material.dart';
import 'package:neuro_plus/common/widgets/custom_form_field.dart';
import 'package:neuro_plus/common/widgets/custom_tags_field.dart';

class ProtocolBasicFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final List<String> categories;
  final ValueChanged<List<String>> onCategoriesChanged;
  final String? Function(String?) nameValidator;
  final String? Function(List<String>?) categoriesValidator;

  const ProtocolBasicFields({
    super.key,
    required this.nameController,
    required this.descriptionController,
    required this.categories,
    required this.onCategoriesChanged,
    required this.nameValidator,
    required this.categoriesValidator,
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
        const SizedBox(height: 24),
        const Text('Categorias'),
        const SizedBox(height: 8),
        CustomTagsField(
          initialTags: categories,
          onChanged: onCategoriesChanged,
          validator: categoriesValidator,
        ),
      ],
    );
  }
} 