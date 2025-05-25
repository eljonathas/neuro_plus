import 'package:flutter/material.dart';
import 'package:neuro_plus/common/config/theme.dart';

class AppointmentsEmptyState extends StatelessWidget {
  const AppointmentsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy, size: 64, color: AppColors.gray[400]),
          const SizedBox(height: 16),
          Text(
            'Não há consultas para esta data',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.gray[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Selecione outra data ou agende uma nova consulta',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: AppColors.gray[500]),
          ),
        ],
      ),
    );
  }
}
