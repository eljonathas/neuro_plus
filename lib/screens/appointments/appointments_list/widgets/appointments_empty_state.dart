import 'package:flutter/material.dart';
import 'package:neuro_plus/common/config/theme.dart';

class AppointmentsEmptyState extends StatelessWidget {
  final bool hasSearchQuery;
  final bool hasStatusFilter;

  const AppointmentsEmptyState({
    super.key,
    required this.hasSearchQuery,
    required this.hasStatusFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 64,
            color: AppColors.gray[400],
          ),
          const SizedBox(height: 16),
          Text(
            hasSearchQuery || hasStatusFilter
                ? 'Nenhuma consulta encontrada'
                : 'Nenhuma consulta cadastrada',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.gray[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hasSearchQuery || hasStatusFilter
                ? 'Tente ajustar os filtros de busca'
                : 'Comece criando sua primeira consulta',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.gray[500],
            ),
          ),
        ],
      ),
    );
  }
} 