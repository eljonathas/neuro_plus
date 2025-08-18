import 'package:flutter/material.dart';
import 'package:neuro_plus/common/widgets/custom_button.dart';

class AppointmentNavigationButtons extends StatelessWidget {
  final int currentStep;
  final bool canGoBack;
  final bool canGoNext;
  final bool isLastStep;
  final bool isLoading;
  final bool hasPatients;
  final bool isEditing;
  final bool canProceed;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onSave;

  const AppointmentNavigationButtons({
    super.key,
    required this.currentStep,
    required this.canGoBack,
    required this.canGoNext,
    required this.isLastStep,
    required this.isLoading,
    required this.hasPatients,
    required this.isEditing,
    required this.onPrevious,
    required this.onNext,
    required this.onSave,
    required this.canProceed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          if (canGoBack)
            Expanded(
              child: CustomButton(
                text: 'Voltar',
                onPressed: onPrevious,
                backgroundColor: Colors.grey[300],
                foregroundColor: Colors.black87,
              ),
            ),
          if (canGoBack) const SizedBox(width: 16),
          if (hasPatients)
            Expanded(
              child: CustomButton(
                text: _getButtonText(),
                onPressed: isLastStep ? onSave : onNext,
                isLoading: isLoading,
                isDisabled: !canProceed,
              ),
            ),
        ],
      ),
    );
  }

  String _getButtonText() {
    if (isLastStep) {
      return isEditing ? 'Atualizar' : 'Agendar';
    }
    return 'Próximo';
  }
}
