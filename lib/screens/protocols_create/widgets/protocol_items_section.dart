import 'package:flutter/material.dart';
import 'package:neuro_plus/common/config/theme.dart';
import 'package:neuro_plus/models/protocol.dart';
import 'package:neuro_plus/screens/protocols_create/widgets/protocol_item_card.dart';

class ProtocolItemsSection extends StatelessWidget {
  final List<ProtocolItem> items;
  final Map<String, TextEditingController> itemControllers;
  final VoidCallback onAddItem;
  final ValueChanged<String> onRemoveItem;
  final Function(ProtocolItem, ResponseType) onUpdateItemResponseType;
  final Function(ProtocolItem, List<String>) onUpdateItemOptions;

  const ProtocolItemsSection({
    super.key,
    required this.items,
    required this.itemControllers,
    required this.onAddItem,
    required this.onRemoveItem,
    required this.onUpdateItemResponseType,
    required this.onUpdateItemOptions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Itens do questionário',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        if (items.isEmpty) _buildEmptyState(),
        ...items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return ProtocolItemCard(
            item: item,
            index: index,
            titleController: itemControllers['${item.id}_title']!,
            instructionController: itemControllers['${item.id}_instruction']!,
            onRemove: () => onRemoveItem(item.id),
            onResponseTypeChanged:
                (responseType) => onUpdateItemResponseType(item, responseType),
            onOptionsChanged: (options) => onUpdateItemOptions(item, options),
          );
        }),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: TextButton.icon(
            onPressed: onAddItem,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Adicionar item'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primarySwatch.shade700,
              backgroundColor: AppColors.primarySwatch.shade100,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.gray[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray[200]!),
      ),
      child: Column(
        children: [
          Icon(Icons.quiz_outlined, size: 48, color: AppColors.gray[400]),
          const SizedBox(height: 16),
          Text(
            'Nenhum item adicionado',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.gray[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Adicione itens para criar seu questionário',
            style: TextStyle(fontSize: 14, color: AppColors.gray[500]),
          ),
        ],
      ),
    );
  }
}
