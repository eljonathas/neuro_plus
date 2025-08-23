import 'package:flutter/material.dart';
import 'package:neuro_plus/common/config/theme.dart';
import 'package:neuro_plus/common/services/protocols/protocol_service.dart';
import 'package:neuro_plus/models/protocol.dart';
import 'package:neuro_plus/screens/protocols_create/widgets/template_option.dart';

class ProtocolTemplateSelector extends StatefulWidget {
  final String? selectedTemplate;
  final ValueChanged<String?> onTemplateChanged;
  final Function(List<ProtocolItem>)? onProtocolSelected;

  const ProtocolTemplateSelector({
    super.key,
    required this.selectedTemplate,
    required this.onTemplateChanged,
    this.onProtocolSelected,
  });

  @override
  State<ProtocolTemplateSelector> createState() =>
      _ProtocolTemplateSelectorState();
}

class _ProtocolTemplateSelectorState extends State<ProtocolTemplateSelector> {
  List<Protocol> _existingProtocols = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadExistingProtocols();
  }

  Future<void> _loadExistingProtocols() async {
    setState(() => _isLoading = true);

    try {
      final protocols = ProtocolsService.getAllProtocols();
      setState(() {
        _existingProtocols = protocols;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _selectTemplate(String template) {
    widget.onTemplateChanged(template);
  }

  void _selectExistingProtocol(Protocol protocol) {
    widget.onTemplateChanged('EXISTING_${protocol.id}');
    widget.onProtocolSelected?.call(protocol.items);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text(
          'Escolha um modelo',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Crie um novo protocolo ou use um existente como base',
          style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
        ),
        const SizedBox(height: 16),

        // Opção para criar novo
        TemplateOption(
          label: 'Criar novo protocolo',
          isSelected: widget.selectedTemplate == 'NOVO',
          onTap: () => _selectTemplate('NOVO'),
        ),

        if (_existingProtocols.isNotEmpty) ...[
          const SizedBox(height: 16),
          const Text(
            'Usar protocolo existente como modelo:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 8),

          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else
            ...(_existingProtocols
                .map(
                  (protocol) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _buildProtocolOption(protocol),
                  ),
                )
                .toList()),
        ],
      ],
    );
  }

  Widget _buildProtocolOption(Protocol protocol) {
    final isSelected = widget.selectedTemplate == 'EXISTING_${protocol.id}';

    return Material(
      color:
          isSelected
              ? AppColors.primarySwatch.withValues(alpha: 0.1)
              : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? AppColors.primarySwatch : AppColors.gray[300]!,
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _selectExistingProtocol(protocol),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      protocol.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color:
                            isSelected
                                ? AppColors.primarySwatch
                                : const Color(0xFF333333),
                      ),
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle,
                      color: AppColors.primarySwatch,
                      size: 20,
                    ),
                ],
              ),
              if (protocol.description?.isNotEmpty == true) ...[
                const SizedBox(height: 4),
                Text(
                  protocol.description!,
                  style: TextStyle(fontSize: 14, color: AppColors.gray[600]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.list_alt, size: 16, color: AppColors.gray[500]),
                  const SizedBox(width: 4),
                  Text(
                    '${protocol.items.length} itens',
                    style: TextStyle(fontSize: 12, color: AppColors.gray[500]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
