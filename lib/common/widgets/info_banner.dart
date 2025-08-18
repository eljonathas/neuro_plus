import 'package:flutter/material.dart';
import 'package:neuro_plus/common/config/theme.dart';

class InfoBanner extends StatelessWidget {
  final String message;
  final IconData icon;

  const InfoBanner({
    super.key,
    required this.message,
    this.icon = Icons.info_outline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primarySwatch.withValues(alpha: 0.06),
        border: Border.all(
          color: AppColors.primarySwatch.withValues(alpha: 0.2),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primarySwatch),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(fontSize: 13.5, color: AppColors.gray[800]),
            ),
          ),
        ],
      ),
    );
  }
}
