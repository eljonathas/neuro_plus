import 'package:flutter/material.dart';
import 'package:neuro_plus/common/main_layout.dart';
import 'package:neuro_plus/common/services/patients/patients_service.dart';
import 'package:neuro_plus/core/navigation/app_routes.dart';
import 'package:neuro_plus/models/patient.dart';
import 'package:neuro_plus/screens/patients/patients_list/widgets/patients_header.dart';
import 'package:neuro_plus/screens/patients/patients_list/widgets/patients_search_bar.dart';
import 'package:neuro_plus/screens/patients/patients_list/widgets/patients_list_view.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({super.key});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Patient> _filteredPatients = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPatients();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadPatients() async {
    setState(() => _isLoading = true);

    try {
      final patients = PatientsService.getAllPatients();

      if (mounted) {
        setState(() {
          _filteredPatients = patients;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar pacientes: $e')),
        );
      }
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    setState(() {
      _filteredPatients = PatientsService.searchPatients(query);
    });
  }

  Future<void> _navigateToCreatePatient() async {
    final result = await AppRoutes.navigateTo(context, '/patients/create');

    if (result == true) {
      _loadPatients();
    }
  }

  Future<void> _navigateToEditPatient(Patient patient) async {
    final result = await AppRoutes.navigateTo(
      context,
      '/patients/create',
      arguments: patient,
    );

    if (result == true) {
      _loadPatients();
    }
  }

  Future<void> _navigateToPatientDetail(Patient patient) async {
    final result = await AppRoutes.navigateTo(
      context,
      '/patients/detail',
      arguments: patient,
    );

    if (result == true) {
      _loadPatients();
    }
  }

  Future<void> _deletePatient(Patient patient) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirmar exclusão'),
            content: Text(
              'Tem certeza que deseja excluir o paciente "${patient.fullName}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Excluir'),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      try {
        await PatientsService.deletePatient(patient.id);
        _loadPatients();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Paciente excluído com sucesso!')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao excluir paciente: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Pacientes',
      navIndex: 3,
      child: Column(
        children: [
          PatientsHeader(
            patientsCount: _filteredPatients.length,
            onAddPatient: _navigateToCreatePatient,
          ),
          PatientsSearchBar(controller: _searchController),
          Expanded(
            child: PatientsListView(
              patients: _filteredPatients,
              isLoading: _isLoading,
              hasSearch: _searchController.text.isNotEmpty,
              onPatientTap: _navigateToPatientDetail,
              onPatientEdit: _navigateToEditPatient,
              onPatientDelete: _deletePatient,
              onAddPatient: _navigateToCreatePatient,
            ),
          ),
        ],
      ),
    );
  }
}
