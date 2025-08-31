import 'package:flutter/material.dart';
import 'package:neuro_plus/common/config/theme.dart';
import 'package:neuro_plus/common/widgets/custom_button.dart';

class PatientFormNavigation extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final bool isProcessing;
  final bool isEditing;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onSave;

  const PatientFormNavigation({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.isProcessing,
    required this.isEditing,
    required this.onPrevious,
    required this.onNext,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          if (currentPage > 0)
            Expanded(
              child: CustomButton(
                text: 'Anterior',
                onPressed: onPrevious,
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primarySwatch,
              ),
            ),
          if (currentPage > 0) const SizedBox(width: 16),
          Expanded(
            child: CustomButton(
              text: _getButtonText(),
              onPressed: _isLastPage() ? onSave : onNext,
              isLoading: isProcessing,
            ),
          ),
        ],
      ),
    );
  }

  String _getButtonText() {
    if (_isLastPage()) {
      return isEditing ? 'Salvar' : 'Cadastrar';
    }
    return 'Próximo';
  }

  bool _isLastPage() => currentPage == totalPages - 1;
}
