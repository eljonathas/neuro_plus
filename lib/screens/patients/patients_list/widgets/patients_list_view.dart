import 'package:flutter/material.dart';
import 'package:neuro_plus/models/patient.dart';
import 'package:neuro_plus/screens/patients/patients_list/widgets/patient_card.dart';
import 'package:neuro_plus/screens/patients/patients_list/widgets/patients_empty_state.dart';

class PatientsListView extends StatelessWidget {
  final List<Patient> patients;
  final bool isLoading;
  final bool hasSearch;
  final Function(Patient) onPatientTap;
  final Function(Patient) onPatientEdit;
  final Function(Patient) onPatientDelete;
  final VoidCallback onAddPatient;

  const PatientsListView({
    super.key,
    required this.patients,
    required this.isLoading,
    required this.hasSearch,
    required this.onPatientTap,
    required this.onPatientEdit,
    required this.onPatientDelete,
    required this.onAddPatient,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (patients.isEmpty) {
      return PatientsEmptyState(
        hasSearch: hasSearch,
        onAddPatient: onAddPatient,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: patients.length,
      itemBuilder: (context, index) {
        final patient = patients[index];
        return PatientCard(
          patient: patient,
          onTap: () => onPatientTap(patient),
          onEdit: () => onPatientEdit(patient),
          onDelete: () => onPatientDelete(patient),
        );
      },
    );
  }
}
