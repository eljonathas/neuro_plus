import 'package:flutter/material.dart';
import 'package:neuro_plus/common/widgets/custom_button.dart';

class NavigationButtons extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final bool isLoading;
  final bool isEditing;

  const NavigationButtons({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.onPrevious,
    this.onNext,
    this.isLoading = false,
    this.isEditing = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          if (currentStep > 0)
            Expanded(
              child: CustomButton(
                text: 'Voltar',
                onPressed: onPrevious ?? () {},
                backgroundColor: Colors.grey[300],
                foregroundColor: Colors.black87,
              ),
            ),
          if (currentStep > 0) const SizedBox(width: 16),
          Expanded(
            child: CustomButton(
              text: currentStep == totalSteps - 1 
                  ? (isEditing ? 'Atualizar' : 'Agendar')
                  : 'Próximo',
              onPressed: onNext ?? () {},
              isLoading: isLoading,
            ),
          ),
        ],
      ),
    );
  }
} 