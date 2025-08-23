import 'dart:async';
import 'package:flutter/material.dart';
import 'package:neuro_plus/common/config/theme.dart';
import 'package:neuro_plus/common/widgets/custom_form_field.dart';
import 'package:neuro_plus/common/widgets/custom_card.dart';
import 'package:neuro_plus/models/protocol.dart';

class ProtocolItemCard extends StatefulWidget {
  final ProtocolItem item;
  final int index;
  final TextEditingController titleController;
  final TextEditingController instructionController;
  final VoidCallback onRemove;
  final ValueChanged<ResponseType> onResponseTypeChanged;
  final ValueChanged<List<String>> onOptionsChanged;

  const ProtocolItemCard({
    super.key,
    required this.item,
    required this.index,
    required this.titleController,
    required this.instructionController,
    required this.onRemove,
    required this.onResponseTypeChanged,
    required this.onOptionsChanged,
  });

  @override
  State<ProtocolItemCard> createState() => _ProtocolItemCardState();
}

class _ProtocolItemCardState extends State<ProtocolItemCard> {
  late List<TextEditingController> _optionControllers;
  Timer? _debounceTimer;

  // Cache para response type options
  static const _responseTypeOptions = [
    ('Checklist', ResponseType.checklist),
    ('Múltipla escolha', ResponseType.multipleChoice),
    ('Escala 0-5', ResponseType.scale),
    ('Texto livre', ResponseType.text),
  ];

  @override
  void initState() {
    super.initState();
    _initializeOptionControllers();
  }

  @override
  void didUpdateWidget(ProtocolItemCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Só reinicializa se as opções mudaram
    if (oldWidget.item.options != widget.item.options) {
      _disposeControllers();
      _initializeOptionControllers();
    }
  }

  void _initializeOptionControllers() {
    _optionControllers =
        widget.item.options
            .map((option) => TextEditingController(text: option))
            .toList();

    // Adiciona listeners com debounce
    for (final controller in _optionControllers) {
      controller.addListener(_onOptionChanged);
    }
  }

  void _disposeControllers() {
    for (final controller in _optionControllers) {
      controller.removeListener(_onOptionChanged);
      controller.dispose();
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _disposeControllers();
    super.dispose();
  }

  // Debounced update para evitar muitas chamadas
  void _onOptionChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        final updatedOptions =
            _optionControllers.map((controller) => controller.text).toList();
        widget.onOptionsChanged(updatedOptions);
      }
    });
  }

  void _addOption() {
    final newController = TextEditingController();
    newController.addListener(_onOptionChanged);

    setState(() {
      _optionControllers.add(newController);
    });

    // Atualiza imediatamente para adicionar opção vazia
    _updateOptionsImmediate();
  }

  void _removeOption(int index) {
    if (index < _optionControllers.length) {
      _optionControllers[index].removeListener(_onOptionChanged);
      _optionControllers[index].dispose();

      setState(() {
        _optionControllers.removeAt(index);
      });

      _updateOptionsImmediate();
    }
  }

  void _updateOptionsImmediate() {
    final updatedOptions =
        _optionControllers.map((controller) => controller.text).toList();
    widget.onOptionsChanged(updatedOptions);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: CustomCard(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              _buildItemField(
                label: 'Título/Habilidade',
                controller: widget.titleController,
                hintText: 'Ex: Fala pelo menos 6 palavras reconhecíveis?',
              ),
              const SizedBox(height: 16),
              _buildItemField(
                label: 'Instrução (opcional)',
                controller: widget.instructionController,
                hintText:
                    'Ex: Pergunte aos responsáveis ou incentive a nomeação de objetos.',
                minLines: 2,
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              const Text('Tipo de resposta'),
              const SizedBox(height: 8),
              _buildResponseTypeSelector(),
              if (widget.item.responseType == ResponseType.checklist ||
                  widget.item.responseType == ResponseType.multipleChoice) ...[
                const SizedBox(height: 16),
                _buildChecklistOptions(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Item ${widget.index + 1}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        IconButton(
          onPressed: widget.onRemove,
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          constraints: const BoxConstraints(),
          padding: const EdgeInsets.all(8),
        ),
      ],
    );
  }

  Widget _buildItemField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    int minLines = 1,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        CustomFormField(
          variant: InputVariant.outlined,
          controller: controller,
          hintText: hintText,
          minLines: minLines,
          maxLines: maxLines,
          validator:
              label.contains('Título')
                  ? (value) {
                    if (value?.isEmpty ?? true) {
                      return 'O título é obrigatório';
                    }
                    return null;
                  }
                  : null,
        ),
      ],
    );
  }

  Widget _buildResponseTypeSelector() {
    return Wrap(
      spacing: 16,
      children:
          _responseTypeOptions
              .map(
                (option) => _ResponseTypeOption(
                  label: option.$1,
                  isSelected: widget.item.responseType == option.$2,
                  onTap: () => widget.onResponseTypeChanged(option.$2),
                ),
              )
              .toList(),
    );
  }

  Widget _buildChecklistOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: AppColors.gray[200]),
        const SizedBox(height: 12),
        _buildOptionsHeader(),
        const SizedBox(height: 8),
        if (_optionControllers.isEmpty)
          _buildEmptyOptionsState()
        else
          ..._buildOptionFields(),
      ],
    );
  }

  Widget _buildOptionsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Opções de resposta',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        TextButton.icon(
          onPressed: _addOption,
          icon: const Icon(Icons.add, size: 16),
          label: const Text('Adicionar opção'),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primarySwatch,
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyOptionsState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.gray[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.gray[200]!),
      ),
      child: Text(
        'Nenhuma opção adicionada',
        style: TextStyle(color: AppColors.gray[500]),
        textAlign: TextAlign.center,
      ),
    );
  }

  List<Widget> _buildOptionFields() {
    return _optionControllers.asMap().entries.map((entry) {
      final index = entry.key;
      final controller = entry.value;
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Expanded(
              child: CustomFormField(
                variant: InputVariant.outlined,
                controller: controller,
                hintText: 'Ex: Sem evidência, Leve, Moderado...',
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () => _removeOption(index),
              icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.all(4),
            ),
          ],
        ),
      );
    }).toList();
  }
}

// Widget separado para response type option (evita rebuilds)
class _ResponseTypeOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ResponseTypeOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<bool>(
            value: true,
            groupValue: isSelected,
            activeColor: AppColors.primarySwatch,
            visualDensity: VisualDensity.compact,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onChanged: (_) => onTap(),
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
