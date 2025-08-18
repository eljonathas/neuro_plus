import 'package:flutter/material.dart';
import 'package:neuro_plus/common/config/theme.dart';
import 'package:neuro_plus/common/main_layout.dart';
import 'package:neuro_plus/common/widgets/icon_card.dart';
import 'package:neuro_plus/common/widgets/qr_scanner_widget.dart';
import 'package:neuro_plus/screens/protocols_create/protocols_create_screen.dart';

class ProtocolsEmptyState extends StatelessWidget {
  final VoidCallback? onProtocolImported;

  const ProtocolsEmptyState({super.key, this.onProtocolImported});

  void _navigateToCreateProtocol(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProtocolsCreateScreen()),
    );
  }

  void _navigateToScanner(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => QrScannerWidget(
              onProtocolImported: (protocol) {
                onProtocolImported?.call();
              },
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Protocolos',
      isBackButtonVisible: true,
      navIndex: 2,
      child: Center(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const IconCard(icon: Icons.assignment_outlined),
              const SizedBox(height: 24),
              const Text(
                'Crie ou importe seu primeiro protocolo',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Para começar a acompanhar pacientes, você pode criar um protocolo personalizado ou importar um existente via QR Code.',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.gray[600],
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 160,
                    child: ElevatedButton.icon(
                      onPressed: () => _navigateToScanner(context),
                      icon: const Icon(Icons.qr_code_scanner, size: 20),
                      label: const Text(
                        'Importar',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 12,
                        ),
                        backgroundColor: AppColors.gray[100],
                        foregroundColor: AppColors.gray[700],
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 160,
                    child: ElevatedButton(
                      onPressed: () => _navigateToCreateProtocol(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: AppColors.primarySwatch,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Novo protocolo',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
}
