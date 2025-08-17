import 'package:flutter/material.dart';
import 'package:neuro_plus/common/config/theme.dart';
import 'package:neuro_plus/common/widgets/custom_card.dart';
import 'package:neuro_plus/common/widgets/protocol_qr_widget.dart';
import 'package:neuro_plus/models/protocol.dart';

class ProtocolCard extends StatelessWidget {
  final Protocol protocol;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProtocolCard({
    super.key,
    required this.protocol,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      protocol.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.qr_code, color: Colors.purple),
                        onPressed: () => _showQrCode(context),
                        tooltip: 'Compartilhar via QR Code',
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(8),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.edit_outlined,
                          color: AppColors.primarySwatch,
                        ),
                        onPressed: onEdit,
                        tooltip: 'Editar',
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(8),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        onPressed: onDelete,
                        tooltip: 'Excluir',
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(8),
                      ),
                    ],
                  ),
                ],
              ),
              if (protocol.description != null &&
                  protocol.description!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  protocol.description!,
                  style: TextStyle(fontSize: 14, color: AppColors.gray[600]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
              ],
              Row(
                children: [
                  Flexible(
                    child: Text(
                      '${protocol.items.length} ${protocol.items.length == 1 ? 'item' : 'itens'}',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.gray[600],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Template: ${protocol.template}',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.gray[500],
                      ),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showQrCode(BuildContext context) {
    ProtocolQrDialog.show(context, protocol);
  }
}
