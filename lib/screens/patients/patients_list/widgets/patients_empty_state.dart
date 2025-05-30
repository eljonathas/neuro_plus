import 'package:flutter/material.dart';
import 'package:neuro_plus/common/config/theme.dart';
import 'package:neuro_plus/common/widgets/custom_button.dart';
import 'package:neuro_plus/common/widgets/icon_card.dart';

class PatientsEmptyState extends StatelessWidget {
  final bool hasSearch;
  final VoidCallback onAddPatient;

  const PatientsEmptyState({
    super.key,
    required this.hasSearch,
    required this.onAddPatient,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconCard(icon: Icons.person_add_alt_1_outlined),
          const SizedBox(height: 16),
          Text(
            hasSearch
                ? 'Nenhum paciente encontrado'
                : 'Nenhum paciente cadastrado',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            hasSearch
                ? 'Tente buscar com outros termos'
                : 'Comece cadastrando seu primeiro paciente',
            style: TextStyle(fontSize: 16, color: AppColors.gray[600]),
          ),
          if (!hasSearch) ...[
            const SizedBox(height: 24),
            CustomButton(text: 'Cadastrar paciente', onPressed: onAddPatient),
          ],
        ],
      ),
    );
  }
}
