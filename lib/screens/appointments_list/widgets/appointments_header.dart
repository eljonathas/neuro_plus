import 'package:flutter/material.dart';
import 'package:neuro_plus/common/config/theme.dart';

class AppointmentsHeader extends StatelessWidget {
  final Map<String, int> stats;
  final VoidCallback onAddPressed;

  const AppointmentsHeader({
    super.key,
    required this.stats,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Text(
                  'Gerenciar consultas',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.gray[800],
                  ),
                ),
                Text(
                  '${stats['total'] ?? 0} consulta${(stats['total'] ?? 0) != 1 ? 's' : ''} • ${stats['today'] ?? 0} hoje',
                  style: TextStyle(fontSize: 14, color: AppColors.gray[600]),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.primarySwatch),
            onPressed: onAddPressed,
            tooltip: 'Nova consulta',
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
