import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/protocol.dart';
import '../services/export_service.dart';

class ProtocolQrWidget extends StatelessWidget {
  final Protocol protocol;
  final double size;

  const ProtocolQrWidget({super.key, required this.protocol, this.size = 200});

  @override
  Widget build(BuildContext context) {
    final qrData = ExportService.generateProtocolQrData(protocol);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          protocol.name,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: QrImageView(
            data: qrData,
            version: QrVersions.auto,
            size: size,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Outros usuários podem escanear este QR Code para importar o protocolo',
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: () => _copyToClipboard(context, qrData),
              icon: const Icon(Icons.copy),
              label: const Text('Copiar'),
            ),
            TextButton.icon(
              onPressed: () => _shareQrCode(qrData),
              icon: const Icon(Icons.share),
              label: const Text('Compartilhar'),
            ),
          ],
        ),
      ],
    );
  }

  void _copyToClipboard(BuildContext context, String data) {
    Clipboard.setData(ClipboardData(text: data));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Dados copiados para a área de transferência'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _shareQrCode(String data) {
    Share.share(data, subject: 'Protocolo - ${protocol.name}');
  }
}

class ProtocolQrDialog extends StatelessWidget {
  final Protocol protocol;

  const ProtocolQrDialog({super.key, required this.protocol});

  static Future<void> show(BuildContext context, Protocol protocol) {
    return showDialog(
      context: context,
      builder: (context) => ProtocolQrDialog(protocol: protocol),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Compartilhar',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ProtocolQrWidget(protocol: protocol),
          ],
        ),
      ),
    );
  }
}
