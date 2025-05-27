import 'package:flutter/material.dart';
import 'package:neuro_plus/common/config/theme.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int index = 0; index < totalSteps; index++) ...[
            _buildStepCircle(index),
            if (index < totalSteps - 1) _buildStepConnector(index),
          ],
        ],
      ),
    );
  }

  Widget _buildStepCircle(int index) {
    final isActive = index == currentStep;
    final isCompleted = index < currentStep;
    
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCompleted
            ? AppColors.primarySwatch
            : isActive
                ? AppColors.primarySwatch
                : AppColors.gray[300],
        border: Border.all(
          color: isActive || isCompleted 
              ? AppColors.primarySwatch 
              : AppColors.gray[300]!,
          width: 2,
        ),
      ),
      child: Center(
        child: isCompleted
            ? const Icon(Icons.check, color: Colors.white, size: 20)
            : Text(
                '${index + 1}',
                style: TextStyle(
                  color: isActive ? Colors.white : AppColors.gray[600],
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
      ),
    );
  }

  Widget _buildStepConnector(int index) {
    final isCompleted = index < currentStep;
    
    return Expanded(
      child: Container(
        height: 3,
        margin: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isCompleted
              ? AppColors.primarySwatch
              : AppColors.gray[300],
          borderRadius: BorderRadius.circular(1.5),
        ),
      ),
    );
  }
} 