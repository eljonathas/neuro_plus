import 'package:flutter/material.dart';
import 'package:neuro_plus/common/config/theme.dart';

class AppointmentTabs extends StatelessWidget {
  final int currentTabIndex;
  final bool hasProtocol;
  final Function(int) onTabChanged;

  const AppointmentTabs({
    super.key,
    required this.currentTabIndex,
    required this.hasProtocol,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.gray[200]!, width: 1),
        ),
      ),
      child: Row(
        children: [
          _buildTabItem('Detalhes', 0),
          _buildTabItem('Notas SOAP', 1),
          if (hasProtocol) _buildTabItem('Protocolos', 2),
        ],
      ),
    );
  }

  Widget _buildTabItem(String label, int index) {
    final isSelected = currentTabIndex == index;
    return InkWell(
      onTap: () => onTabChanged(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? AppColors.primarySwatch : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.primarySwatch : AppColors.gray[500],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
