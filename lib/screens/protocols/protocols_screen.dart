import 'package:flutter/material.dart';
import 'package:neuro_plus/common/config/theme.dart';
import 'package:neuro_plus/common/main_layout.dart';
import 'package:neuro_plus/common/services/protocols/protocol_service.dart';
import 'package:neuro_plus/common/widgets/export_menu_widget.dart';
import 'package:neuro_plus/common/widgets/qr_scanner_widget.dart';
import 'package:neuro_plus/common/services/export_service.dart';
import 'package:neuro_plus/core/navigation/app_routes.dart';
import 'package:neuro_plus/models/protocol.dart';
import 'package:neuro_plus/screens/protocols/protocols_empty_state.dart';
import 'package:neuro_plus/screens/protocols/widgets/protocol_card.dart';

class ProtocolsScreen extends StatefulWidget {
  const ProtocolsScreen({super.key});

  @override
  State<ProtocolsScreen> createState() => _ProtocolsScreenState();
}

class _ProtocolsScreenState extends State<ProtocolsScreen> {
  List<Protocol> protocols = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProtocols();
  }

  Future<void> _loadProtocols() async {
    setState(() {
      isLoading = true;
    });

    try {
      final loadedProtocols = ProtocolsService.getAllProtocols();
      setState(() {
        protocols = loadedProtocols;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar protocolos: $e')),
        );
      }
    }
  }

  Future<void> _deleteProtocol(Protocol protocol) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Excluir protocolo'),
            content: Text(
              'Deseja realmente excluir o protocolo "${protocol.name}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Excluir'),
              ),
            ],
          ),
    );

    if (confirm == true) {
      try {
        await ProtocolsService.deleteProtocol(protocol.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Protocolo excluído com sucesso!')),
          );
        }
        _loadProtocols();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao excluir protocolo: $e')),
          );
        }
      }
    }
  }

  void _editProtocol(Protocol protocol) async {
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.protocolsCreate,
      arguments: protocol,
    );

    if (result == true) {
      _loadProtocols();
    }
  }

  void _navigateToCreateProtocol() async {
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.protocolsCreate,
    );

    if (result == true) {
      _loadProtocols();
    }
  }

  void _showExportMenu() {
    final List<ExportOption> options = [
      ExportOptions.scanQrCode(
        title: 'Importar Protocolo',
        description: 'Escanear QR Code para importar protocolo',
        onTap: _navigateToScanner,
      ),
    ];

    // Adicionar opções de exportação apenas se há protocolos
    if (protocols.isNotEmpty) {
      options.add(
        ExportOptions.csvExport(
          title: 'Exportar Lista (CSV)',
          data: protocols,
          exportFunction: ExportService.exportProtocolsToCsv,
        ),
      );
    }

    ExportMenuWidget.show(
      context,
      title:
          protocols.isNotEmpty
              ? 'Importar e Exportar Protocolos'
              : 'Importar Protocolo',
      options: options,
    );
  }

  void _navigateToScanner() {
    Navigator.of(context).pop(); // Fecha o menu
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => QrScannerWidget(
              onProtocolImported: (protocol) {
                _loadProtocols(); // Recarrega a lista após importação
              },
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const MainLayout(
        title: "Protocolos",
        navIndex: 2,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (protocols.isEmpty) {
      return ProtocolsEmptyState(onProtocolImported: _loadProtocols);
    }

    return MainLayout(
      title: "Protocolos",
      navIndex: 2,
      child: RefreshIndicator(
        onRefresh: _loadProtocols,
        color: AppColors.primarySwatch,
        backgroundColor: Colors.white,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Seus protocolos (${protocols.length})',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.import_export,
                            color: AppColors.primarySwatch,
                          ),
                          onPressed: _showExportMenu,
                          tooltip: 'Importar e Exportar Protocolos',
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.primarySwatch.withValues(
                              alpha: 0.1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(
                            Icons.add,
                            color: AppColors.primarySwatch,
                          ),
                          onPressed: _navigateToCreateProtocol,
                          tooltip: 'Novo protocolo',
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.primarySwatch.withValues(
                              alpha: 0.1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList.separated(
                itemCount: protocols.length,
                separatorBuilder:
                    (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final protocol = protocols[index];
                  return ProtocolCard(
                    key: ValueKey(protocol.id),
                    protocol: protocol,
                    onEdit: () => _editProtocol(protocol),
                    onDelete: () => _deleteProtocol(protocol),
                  );
                },
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
          ],
        ),
      ),
    );
  }
}
