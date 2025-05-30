import 'package:flutter/material.dart';
import 'package:neuro_plus/common/main_layout.dart';
import 'package:neuro_plus/core/navigation/app_routes.dart';
import 'package:neuro_plus/models/patient.dart';
import 'package:neuro_plus/screens/patients/patients_detail/widgets/patient_header.dart';
import 'package:neuro_plus/screens/patients/patients_detail/widgets/patient_contact_section.dart';
import 'package:neuro_plus/screens/patients/patients_detail/widgets/patient_clinical_section.dart';
import 'package:neuro_plus/screens/patients/patients_detail/widgets/patient_development_section.dart';
import 'package:neuro_plus/screens/patients/patients_detail/widgets/patient_school_section.dart';

class PatientDetailScreen extends StatelessWidget {
  final Patient patient;

  const PatientDetailScreen({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Detalhes do Paciente',
      isBackButtonVisible: true,
      navIndex: 3,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: Column(
          spacing: 8,
          children: [
            PatientHeader(
              patient: patient,
              onEdit: () => _navigateToEdit(context),
            ),
            PatientContactSection(patient: patient),
            PatientClinicalSection(patient: patient),
            PatientDevelopmentSection(patient: patient),
            PatientSchoolSection(patient: patient),
          ],
        ),
      ),
    );
  }

  Future<void> _navigateToEdit(BuildContext context) async {
    final result = await AppRoutes.navigateTo(
      context,
      '/patients/create',
      arguments: patient,
    );

    if (result == true && context.mounted) {
      Navigator.pop(context, true);
    }
  }
}
