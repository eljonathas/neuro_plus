import 'package:flutter/material.dart';
import 'package:neuro_plus/common/main_layout.dart';
import 'package:neuro_plus/common/services/appointments/appointments_service.dart';
import 'package:neuro_plus/common/widgets/export_menu_widget.dart';
import 'package:neuro_plus/common/services/export_service.dart';
import 'package:neuro_plus/models/appointment.dart';

/// Exemplo de como integrar funcionalidades de exportação na tela de consultas
/// Este arquivo demonstra como adicionar botões de exportação e menu de opções
class AppointmentsScreenWithExport extends StatefulWidget {
  const AppointmentsScreenWithExport({super.key});

  @override
  State<AppointmentsScreenWithExport> createState() =>
      _AppointmentsScreenWithExportState();
}

class _AppointmentsScreenWithExportState
    extends State<AppointmentsScreenWithExport> {
  List<Appointment> appointments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    setState(() => isLoading = true);

    try {
      final loadedAppointments = AppointmentsService.getAllAppointments();
      setState(() {
        appointments = loadedAppointments;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar consultas: $e')),
        );
      }
    }
  }

  void _showExportMenu() {
    if (appointments.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nenhuma consulta disponível para exportar'),
        ),
      );
      return;
    }

    ExportMenuWidget.show(
      context,
      title: 'Exportar Consultas',
      options: [
        ExportOptions.csvExport(
          title: 'Exportar Lista (CSV)',
          description: 'Exportar todas as consultas em formato planilha',
          data: appointments,
          exportFunction: ExportService.exportAppointmentsToCsv,
          onSuccess: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Lista de consultas exportada com sucesso!'),
                backgroundColor: Colors.green,
              ),
            );
          },
        ),
        // Exemplo de exportação de consulta individual
        if (appointments.isNotEmpty)
          ExportOptions.jsonExport(
            title: 'Exportar Consulta Individual (JSON)',
            description: 'Exportar dados detalhados de uma consulta específica',
            data: appointments.first, // Exemplo com primeira consulta
            exportFunction: ExportService.exportAppointmentToJson,
            onSuccess: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Consulta exportada com sucesso!'),
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
        title: "Consultas",
        navIndex: 1,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return MainLayout(
      title: "Consultas",
      navIndex: 1,
      child: Column(
        children: [
          // Header com botões de ação
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Suas consultas (${appointments.length})',
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
                      tooltip: 'Exportar consultas',
                    ),
                    // Botão de nova consulta
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        // Navegar para criar consulta
                      },
                      tooltip: 'Nova consulta',
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Lista de consultas
          Expanded(
            child:
                appointments.isEmpty
                    ? const Center(child: Text('Nenhuma consulta encontrada'))
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: appointments.length,
                      itemBuilder: (context, index) {
                        final appointment = appointments[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            title: Text(appointment.patientName),
                            subtitle: Text(
                              '${appointment.formattedDate} - ${appointment.time}\n'
                              'Status: ${appointment.statusText}',
                            ),
                            trailing: PopupMenuButton(
                              itemBuilder:
                                  (context) => [
                                    PopupMenuItem(
                                      child: const Text(
                                        'Exportar esta consulta',
                                      ),
                                      onTap:
                                          () => _exportSingleAppointment(
                                            appointment,
                                          ),
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

  Future<void> _exportSingleAppointment(Appointment appointment) async {
    try {
      final file = await ExportService.exportAppointmentToJson(appointment);
      await ExportService.shareFile(
        file,
        subject: 'Consulta - ${appointment.patientName}',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Consulta exportada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao exportar consulta: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
