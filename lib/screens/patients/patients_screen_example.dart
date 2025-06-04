import 'package:flutter/material.dart';
import 'package:neuro_plus/common/main_layout.dart';
import 'package:neuro_plus/common/widgets/export_menu_widget.dart';
import 'package:neuro_plus/common/services/export_service.dart';
import 'package:neuro_plus/models/patient.dart';

/// Exemplo de como integrar funcionalidades de exportação na tela de pacientes
/// Este arquivo demonstra como adicionar botões de exportação e menu de opções
class PatientsScreenWithExport extends StatefulWidget {
  const PatientsScreenWithExport({super.key});

  @override
  State<PatientsScreenWithExport> createState() =>
      _PatientsScreenWithExportState();
}

class _PatientsScreenWithExportState extends State<PatientsScreenWithExport> {
  List<Patient> patients = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  Future<void> _loadPatients() async {
    setState(() => isLoading = true);

    try {
      // Aqui você carregaria os pacientes do seu serviço
      // final loadedPatients = PatientsService.getAllPatients();
      final loadedPatients = <Patient>[]; // Exemplo vazio

      setState(() {
        patients = loadedPatients;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar pacientes: $e')),
        );
      }
    }
  }

  void _showExportMenu() {
    if (patients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nenhum paciente disponível para exportar'),
        ),
      );
      return;
    }

    ExportMenuWidget.show(
      context,
      title: 'Exportar Pacientes',
      options: [
        ExportOptions.csvExport(
          title: 'Exportar Lista (CSV)',
          description: 'Exportar todos os pacientes em formato planilha',
          data: patients,
          exportFunction: ExportService.exportPatientsToCsv,
          onSuccess: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Lista de pacientes exportada com sucesso!'),
                backgroundColor: Colors.green,
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const MainLayout(
        title: "Pacientes",
        navIndex: 0,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return MainLayout(
      title: "Pacientes",
      navIndex: 0,
      child: Column(
        children: [
          // Header com botões de ação
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Seus pacientes (${patients.length})',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    // Botão de exportação
                    IconButton(
                      icon: const Icon(Icons.file_download),
                      onPressed: _showExportMenu,
                      tooltip: 'Exportar pacientes',
                    ),
                    // Botão de novo paciente
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        // Navegar para criar paciente
                      },
                      tooltip: 'Novo paciente',
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Lista de pacientes
          Expanded(
            child:
                patients.isEmpty
                    ? const Center(child: Text('Nenhum paciente encontrado'))
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: patients.length,
                      itemBuilder: (context, index) {
                        final patient = patients[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            title: Text(patient.fullName),
                            subtitle: Text(
                              'Idade: ${patient.age} anos\n'
                              'Responsáveis: ${patient.guardians}',
                            ),
                            trailing: PopupMenuButton(
                              itemBuilder:
                                  (context) => [
                                    PopupMenuItem(
                                      child: const Text('Ver detalhes'),
                                      onTap: () {
                                        // Navegar para detalhes
                                      },
                                    ),
                                    PopupMenuItem(
                                      child: const Text('Editar'),
                                      onTap: () {
                                        // Navegar para editar
                                      },
                                    ),
                                  ],
                            ),
                            onTap: () {
                              // Navegar para detalhes
                            },
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
