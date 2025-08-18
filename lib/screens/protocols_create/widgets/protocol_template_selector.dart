import 'package:flutter/material.dart';
import 'package:neuro_plus/screens/protocols_create/widgets/template_option.dart';

class ProtocolTemplateSelector extends StatelessWidget {
  final String selectedTemplate;
  final ValueChanged<String> onTemplateChanged;

  const ProtocolTemplateSelector({
    super.key,
    required this.selectedTemplate,
    required this.onTemplateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text('Escolha um modelo'),
        const SizedBox(height: 8),
        Row(
          children: [
            TemplateOption(
              label: 'CRIAR NOVO',
              isSelected: selectedTemplate == 'NOVO',
              onTap: () => onTemplateChanged('NOVO'),
            ),
            const SizedBox(width: 12),
            TemplateOption(
              label: 'PROTEA',
              isSelected: selectedTemplate == 'PROTEA',
              onTap: () => onTemplateChanged('PROTEA'),
            ),
          ],
        ),
      ],
    );
  }
}
