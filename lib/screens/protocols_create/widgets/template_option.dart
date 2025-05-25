import 'package:flutter/material.dart';
import 'package:neuro_plus/common/config/theme.dart';

class TemplateOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const TemplateOption({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(8);

    return Material(
      color:
          isSelected
              ? AppColors.primarySwatch.withValues(alpha: 0.2)
              : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(
          color: isSelected ? AppColors.primarySwatch : AppColors.gray[300]!,
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        splashColor: AppColors.primarySwatch.withValues(alpha: 0.3),
        highlightColor: AppColors.primarySwatch.withValues(alpha: 0.15),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.primarySwatch : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
