import 'package:flutter/material.dart';
import 'package:neuro_plus/common/config/theme.dart';

class PatientsHeader extends StatelessWidget {
  final int patientsCount;
  final VoidCallback onAddPatient;

  const PatientsHeader({
    super.key,
    required this.patientsCount,
    required this.onAddPatient,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gerenciar pacientes',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.gray[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$patientsCount paciente${patientsCount != 1 ? 's' : ''} cadastrado${patientsCount != 1 ? 's' : ''}',
                  style: TextStyle(fontSize: 14, color: AppColors.gray[600]),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.primarySwatch),
            onPressed: onAddPatient,
            tooltip: 'Novo paciente',
            style: IconButton.styleFrom(
              backgroundColor: AppColors.primarySwatch.withValues(alpha: 0.1),
              padding: const EdgeInsets.all(12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
