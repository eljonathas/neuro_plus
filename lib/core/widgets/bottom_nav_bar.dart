import 'package:flutter/material.dart';
import '../config/theme.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.only(top: 16, left: 32, right: 32),
          decoration: BoxDecoration(color: Colors.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_labels.length, (index) {
              final isActive = index == currentIndex;
              return _NavItem(
                label: _labels[index],
                icon: _icons[index].call(isActive),
                isActive: isActive,
                onTap: () => onTap(index),
              );
            }),
          ),
        ),
      ),
    );
  }

  static const List<String> _labels = [
    'Início',
    'Consultas',
    'Protocolos',
    'Pacientes',
  ];

  static final List<Icon Function(bool)> _icons = [
    (active) => Icon(active ? Icons.home : Icons.home_outlined),
    (active) => Icon(active ? Icons.event_note : Icons.event_note_outlined),
    (active) => Icon(active ? Icons.fact_check : Icons.fact_check_outlined),
    (active) => Icon(active ? Icons.person : Icons.person_outline),
  ];
}

class _NavItem extends StatelessWidget {
  final String label;
  final Icon icon;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon.icon,
            color: isActive ? AppColors.primarySwatch : AppColors.gray[500],
            size: 28,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isActive ? AppColors.primarySwatch : AppColors.gray[500],
            ),
          ),
        ],
      ),
    );
  }
}
