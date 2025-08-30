import 'package:flutter/material.dart';
import 'package:neuro_plus/common/main_layout.dart';
import 'package:neuro_plus/common/services/patients/patients_service.dart';
import 'package:neuro_plus/common/config/theme.dart';
import 'package:neuro_plus/common/widgets/custom_button.dart';
import 'package:neuro_plus/common/widgets/custom_card.dart';
import 'package:neuro_plus/core/navigation/app_routes.dart';
import 'package:neuro_plus/models/patient.dart';
import 'package:intl/intl.dart';

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
          _buildHeader(),
          _buildSearchBar(),
          Expanded(child: _buildPatientsList()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gerenciar pacientes',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.gray[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_filteredPatients.length} paciente${_filteredPatients.length != 1 ? 's' : ''} cadastrado${_filteredPatients.length != 1 ? 's' : ''}',
                  style: TextStyle(fontSize: 14, color: AppColors.gray[600]),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.primarySwatch),
            onPressed: _navigateToCreatePatient,
            tooltip: 'Novo paciente',
            style: IconButton.styleFrom(
              backgroundColor: AppColors.primarySwatch.withValues(alpha: 0.1),
              padding: const EdgeInsets.all(12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Buscar por nome, responsável ou telefone...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.gray[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.gray[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primarySwatch),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildPatientsList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_filteredPatients.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredPatients.length,
      itemBuilder: (context, index) {
        final patient = _filteredPatients[index];
        return _buildPatientCard(patient);
      },
    );
  }

  Widget _buildEmptyState() {
    final hasSearch = _searchController.text.isNotEmpty;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            hasSearch ? Icons.search_off : Icons.person_add,
            size: 64,
            color: AppColors.gray[400],
          ),
          const SizedBox(height: 16),
          Text(
            hasSearch
                ? 'Nenhum paciente encontrado'
                : 'Nenhum paciente cadastrado',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.gray[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hasSearch
                ? 'Tente buscar com outros termos'
                : 'Comece cadastrando seu primeiro paciente',
            style: TextStyle(fontSize: 14, color: AppColors.gray[500]),
          ),
          if (!hasSearch) ...[
            const SizedBox(height: 24),
            CustomButton(
              text: 'Cadastrar paciente',
              onPressed: _navigateToCreatePatient,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPatientCard(Patient patient) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: CustomCard(
        child: InkWell(
          onTap: () => _navigateToPatientDetail(patient),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            patient.fullName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${patient.age} anos • ${patient.gender}',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.gray[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      color: Colors.white,
                      onSelected: (value) {
                        switch (value) {
                          case 'edit':
                            _navigateToEditPatient(patient);
                            break;
                          case 'delete':
                            _deletePatient(patient);
                            break;
                        }
                      },
                      itemBuilder:
                          (context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit, size: 20),
                                  SizedBox(width: 8),
                                  Text('Editar'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.delete,
                                    size: 20,
                                    color: Colors.red,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Excluir',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildPatientInfo(
                  'Responsáveis/Cuidadores',
                  patient.guardians.map((g) => g.name).join(', '),
                ),
                _buildPatientInfo('Telefone', patient.contactPhone),
                _buildPatientInfo(
                  'Data de nascimento',
                  dateFormat.format(patient.birthDate),
                ),
                if (patient.contactEmail?.isNotEmpty == true)
                  _buildPatientInfo('E-mail', patient.contactEmail!),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPatientInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.gray[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
