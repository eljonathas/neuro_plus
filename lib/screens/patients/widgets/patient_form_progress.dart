import 'package:flutter/material.dart';
import 'package:neuro_plus/common/config/theme.dart';

class PatientFormProgress extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const PatientFormProgress({
    super.key,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: List.generate(totalPages, (index) {
          final isActive = index <= currentPage;
          return Expanded(
            child: Container(
              height: 4,
              margin: EdgeInsets.only(right: index < totalPages - 1 ? 8 : 0),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primarySwatch : AppColors.gray[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }
}
