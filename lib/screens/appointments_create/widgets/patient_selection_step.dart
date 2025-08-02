import 'package:flutter/material.dart';
import 'package:neuro_plus/common/config/theme.dart';
import 'package:neuro_plus/common/widgets/custom_button.dart';
import 'package:neuro_plus/common/widgets/custom_card.dart';
import 'package:neuro_plus/models/patient.dart';

class PatientSelectionStep extends StatelessWidget {
  final List<Patient> patients;
  final Patient? selectedPatient;
  final Function(Patient) onPatientSelected;

  const PatientSelectionStep({
    super.key,
    required this.patients,
    required this.selectedPatient,
    required this.onPatientSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selecionar paciente',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.gray[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Escolha o paciente para esta consulta',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.gray[600],
            ),
          ),
          const SizedBox(height: 24),
          if (patients.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person_off, size: 64, color: AppColors.gray[400]),
                    const SizedBox(height: 16),
                    Text(
                      'Nenhum paciente cadastrado',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.gray[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Cadastre um paciente primeiro',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.gray[500],
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      text: 'Cadastrar paciente',
                      onPressed: () => Navigator.pushNamed(context, '/patients/create'),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: patients.length,
                itemBuilder: (context, index) {
                  final patient = patients[index];
                  final isSelected = selectedPatient?.id == patient.id;
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: CustomCard(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isSelected 
                              ? AppColors.primarySwatch 
                              : AppColors.gray[300],
                          child: Icon(
                            Icons.person,
                            color: isSelected ? Colors.white : AppColors.gray[600],
                          ),
                        ),
                        title: Text(
                          patient.fullName,
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                        subtitle: Text('${patient.age} anos • ${patient.guardians}'),
                        trailing: isSelected
                            ? Icon(Icons.check_circle, color: AppColors.primarySwatch)
                            : null,
                        onTap: () => onPatientSelected(patient),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
} 