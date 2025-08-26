import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../models/protocol.dart';
import '../services/export_service.dart';
import '../services/protocols/protocol_service.dart';

class QrScannerWidget extends StatefulWidget {
  final Function(Protocol)? onProtocolImported;

  const QrScannerWidget({super.key, this.onProtocolImported});

  @override
  State<QrScannerWidget> createState() => _QrScannerWidgetState();
}

class _QrScannerWidgetState extends State<QrScannerWidget> {
  MobileScannerController controller = MobileScannerController();
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear QR Code'),
        actions: [
          if (!kIsWeb) ...[
            IconButton(
              onPressed: () => controller.toggleTorch(),
              icon: const Icon(Icons.flash_on),
            ),
            IconButton(
              onPressed: () => controller.switchCamera(),
              icon: const Icon(Icons.flip_camera_ios),
            ),
          ],
        ],
      ),
      body: Stack(
        children: [
          if (kIsWeb)
            _buildWebFallback()
          else
            MobileScanner(controller: controller, onDetect: _onDetect),
          if (!kIsWeb) _buildOverlay(),
          if (isProcessing) _buildLoadingOverlay(),
        ],
      ),
    );
  }

  Widget _buildWebFallback() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.qr_code_scanner, size: 80, color: Colors.grey),
            const SizedBox(height: 24),
            const Text(
              'Scanner QR na Web',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'O scanner de QR Code tem funcionalidade limitada na versão web.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            MobileScanner(controller: controller, onDetect: _onDetect),
          ],
        ),
      ),
    );
  }

  Widget _buildOverlay() {
    return CustomPaint(painter: ScannerOverlay(), child: Container());
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black54,
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 16),
            Text(
              'Processando QR Code...',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  void _onDetect(BarcodeCapture capture) async {
    if (isProcessing) return;

    final barcode = capture.barcodes.first;
    if (barcode.rawValue == null) return;

    setState(() {
      isProcessing = true;
    });

    try {
      final protocol = ExportService.importProtocolFromQrData(
        barcode.rawValue!,
      );

      if (protocol == null) {
        _showError('QR Code não contém um protocolo válido');
        return;
      }

      // Verifica se já existe um protocolo com o mesmo ID
      final existingProtocol = ProtocolsService.getProtocolById(protocol.id);
      if (existingProtocol != null) {
        _showImportDialog(protocol, isUpdate: true);
      } else {
        await _importProtocol(protocol);
      }
    } catch (e) {
      _showError('Erro ao processar QR Code: ${e.toString()}');
    } finally {
      setState(() {
        isProcessing = false;
      });
    }
  }

  void _showImportDialog(Protocol protocol, {bool isUpdate = false}) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              isUpdate ? 'Protocolo já existe' : 'Importar Protocolo',
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isUpdate
                      ? 'Já existe um protocolo com o mesmo ID. Deseja substituí-lo?'
                      : 'Deseja importar o protocolo "${protocol.name}"?',
                ),
                const SizedBox(height: 16),
                Text('Nome: ${protocol.name}'),
                if (protocol.description?.isNotEmpty == true)
                  Text('Descrição: ${protocol.description}'),
                Text('Itens: ${protocol.items.length}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _importProtocol(protocol);
                },
                child: Text(isUpdate ? 'Substituir' : 'Importar'),
              ),
            ],
          ),
    );
  }

  Future<void> _importProtocol(Protocol protocol) async {
    try {
      await ProtocolsService.addProtocol(protocol);

      if (mounted) {
        widget.onProtocolImported?.call(protocol);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Protocolo "${protocol.name}" importado com sucesso!',
            ),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.of(context).pop();
      }
    } catch (e) {
      _showError('Erro ao importar protocolo: ${e.toString()}');
    }
  }

  void _showError(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class ScannerOverlay extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double scanArea = 250.0;
    final double left = (size.width - scanArea) / 2;
    final double top = (size.height - scanArea) / 2;

    final backgroundPaint =
        Paint()
          ..color = Colors.black54
          ..style = PaintingStyle.fill;

    final scanAreaPaint =
        Paint()
          ..color = Colors.transparent
          ..style = PaintingStyle.fill
          ..blendMode = BlendMode.clear;

    final borderPaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0;

    // Desenha o fundo escuro
    canvas.drawRect(Offset.zero & size, backgroundPaint);

    // Desenha a área transparente de scan
    canvas.drawRect(
      Rect.fromLTWH(left, top, scanArea, scanArea),
      scanAreaPaint,
    );

    // Desenha a borda da área de scan
    canvas.drawRect(Rect.fromLTWH(left, top, scanArea, scanArea), borderPaint);

    // Desenha os cantos
    const double cornerLength = 20.0;
    const double cornerWidth = 3.0;

    final cornerPaint =
        Paint()
          ..color = const Color(0xFF6750A4) // Cor primária padrão
          ..style = PaintingStyle.stroke
          ..strokeWidth = cornerWidth;

    // Canto superior esquerdo
    canvas.drawLine(
      Offset(left, top + cornerLength),
      Offset(left, top),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left, top),
      Offset(left + cornerLength, top),
      cornerPaint,
    );

    // Canto superior direito
    canvas.drawLine(
      Offset(left + scanArea - cornerLength, top),
      Offset(left + scanArea, top),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left + scanArea, top),
      Offset(left + scanArea, top + cornerLength),
      cornerPaint,
    );

    // Canto inferior esquerdo
    canvas.drawLine(
      Offset(left, top + scanArea - cornerLength),
      Offset(left, top + scanArea),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left, top + scanArea),
      Offset(left + cornerLength, top + scanArea),
      cornerPaint,
    );

    // Canto inferior direito
    canvas.drawLine(
      Offset(left + scanArea - cornerLength, top + scanArea),
      Offset(left + scanArea, top + scanArea),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left + scanArea, top + scanArea),
      Offset(left + scanArea, top + scanArea - cornerLength),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
