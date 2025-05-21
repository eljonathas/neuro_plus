import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:neuro_plus/core/config/theme.dart';
import 'package:neuro_plus/services/protocol_service.dart';

class ScanQrScreen extends StatefulWidget {
  const ScanQrScreen({super.key});

  @override
  State<ScanQrScreen> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen> {
  final MobileScannerController _controller = MobileScannerController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _processQrCode(String data) async {
    if (_isProcessing) return;
    
    setState(() {
      _isProcessing = true;
    });

    try {
      final protocol = await ProtocolService.importProtocolFromQrCode(data, context);
      
      if (protocol != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Protocolo "${protocol.name}" importado com sucesso!')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao processar QR Code: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear QR Code'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: _controller.torchState,
              builder: (context, state, child) {
                switch (state as TorchState) {
                  case TorchState.on:
                    return const Icon(Icons.flash_on);
                  case TorchState.off:
                    return const Icon(Icons.flash_off);
                }
              },
            ),
            onPressed: () => _controller.toggleTorch(),
          ),
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: _controller.cameraFacingState,
              builder: (context, state, child) {
                switch (state as CameraFacing) {
                  case CameraFacing.front:
                    return const Icon(Icons.camera_front);
                  case CameraFacing.back:
                    return const Icon(Icons.camera_rear);
                }
              },
            ),
            onPressed: () => _controller.switchCamera(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              controller: _controller,
              onDetect: (BarcodeCapture capture) {
                if (_isProcessing) return;
                
                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  if (barcode.rawValue != null) {
                    _processQrCode(barcode.rawValue!);
                    break;
                  }
                }
              },
              overlay: QRScannerOverlay(
                overlayColour: Colors.black.withOpacity(0.5),
                borderColour: AppColors.primarySwatch,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 250,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Text(
                  'Aponte a câmera para o QR Code de um protocolo para importá-lo',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF666666),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                if (_isProcessing)
                  const CircularProgressIndicator(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class QRScannerOverlay extends StatelessWidget {
  const QRScannerOverlay({
    super.key,
    required this.overlayColour,
    required this.borderColour,
    required this.borderRadius,
    required this.borderLength,
    required this.borderWidth,
    required this.cutOutSize,
  });

  final Color overlayColour;
  final Color borderColour;
  final double borderRadius;
  final double borderLength;
  final double borderWidth;
  final double cutOutSize;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            overlayColour,
            BlendMode.srcOut,
          ),
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.red,
                  backgroundBlendMode: BlendMode.dstOut,
                ),
              ),
              Center(
                child: Container(
                  height: cutOutSize,
                  width: cutOutSize,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                ),
              ),
            ],
          ),
        ),
        Center(
          child: Container(
            width: cutOutSize,
            height: cutOutSize,
            decoration: BoxDecoration(
              border: Border.all(
                color: borderColour,
                width: borderWidth,
              ),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Stack(
              children: [
                // Top left corner
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    width: borderLength,
                    height: borderWidth,
                    color: borderColour,
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    width: borderWidth,
                    height: borderLength,
                    color: borderColour,
                  ),
                ),
                
                // Top right corner
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: borderLength,
                    height: borderWidth,
                    color: borderColour,
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: borderWidth,
                    height: borderLength,
                    color: borderColour,
                  ),
                ),
                
                // Bottom left corner
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    width: borderLength,
                    height: borderWidth,
                    color: borderColour,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    width: borderWidth,
                    height: borderLength,
                    color: borderColour,
                  ),
                ),
                
                // Bottom right corner
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: borderLength,
                    height: borderWidth,
                    color: borderColour,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: borderWidth,
                    height: borderLength,
                    color: borderColour,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
} 