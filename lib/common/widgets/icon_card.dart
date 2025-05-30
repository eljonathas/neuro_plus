import 'package:flutter/material.dart';
import 'package:neuro_plus/common/config/theme.dart';

class IconCard extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color color;

  const IconCard({
    super.key,
    required this.icon,
    this.size = 72,
    this.color = AppColors.primarySwatch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(child: Icon(icon, size: size / 2, color: color)),
    );
  }
}
