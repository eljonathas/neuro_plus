import 'package:flutter/material.dart';
import 'package:neuro_plus/common/config/theme.dart';
import 'package:neuro_plus/common/main_layout.dart';
import 'package:neuro_plus/screens/protocols_create/protocols_create_screen.dart';

class ProtocolsEmptyState extends StatelessWidget {
  const ProtocolsEmptyState({super.key});

  void _navigateToCreateProtocol(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProtocolsCreateScreen()),
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
              const SizedBox(height: 40),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.primarySwatch.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Icon(
                    Icons.assignment_outlined,
                    size: 36,
                    color: AppColors.primarySwatch,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Crie seu primeiro protocolo',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Para começar a acompanhar pacientes, primeiro você precisa criar um protocolo. Personalize seus formulários de acordo com as necessidades da sua prática clínica.',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.gray[600],
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 200,
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
