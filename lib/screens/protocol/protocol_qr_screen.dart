import 'package:flutter/material.dart';
import 'package:neuro_plus/core/config/theme.dart';
import 'package:neuro_plus/models/protocol.dart';
import 'package:neuro_plus/services/protocol_service.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ProtocolQrScreen extends StatefulWidget {
  final Protocol protocol;

  const ProtocolQrScreen({super.key, required this.protocol});

  @override
  State<ProtocolQrScreen> createState() => _ProtocolQrScreenState();
}

class _ProtocolQrScreenState extends State<ProtocolQrScreen> {
  String _qrData = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _generateQrData();
  }

  Future<void> _generateQrData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Gerar dados para o QR Code
      final qrData = ProtocolService.generateQrCodeData(widget.protocol);

      setState(() {
        _qrData = qrData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao gerar QR Code: $e')),
        );
      }
    }
  }

  void _shareAsFile() async {
    try {
      await ProtocolService.shareProtocolAsJson(widget.protocol, context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao compartilhar: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compartilhar Protocolo'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.protocol.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.protocol.description ?? '',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    // QR Code
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: QrImageView(
                        data: _qrData,
                        version: QrVersions.auto,
                        size: 250,
                        backgroundColor: Colors.white,
                        eyeStyle: QrEyeStyle(
                          eyeShape: QrEyeShape.square,
                          color: AppColors.primarySwatch,
                        ),
                        dataModuleStyle: QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.square,
                          color: AppColors.primarySwatch,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      'Escaneie este QR code em outro dispositivo para importar este protocolo',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF666666),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    OutlinedButton.icon(
                      onPressed: _shareAsFile,
                      icon: const Icon(Icons.share),
                      label: const Text('Compartilhar como arquivo'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
} 