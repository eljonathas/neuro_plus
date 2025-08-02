import 'dart:io';
import 'package:flutter/material.dart';
import 'package:neuro_plus/common/config/theme.dart';
import '../services/export_service.dart';

class ExportMenuWidget extends StatefulWidget {
  final String title;
  final List<ExportOption> options;
  final bool showAsBottomSheet;

  const ExportMenuWidget({
    super.key,
    required this.title,
    required this.options,
    this.showAsBottomSheet = true,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required List<ExportOption> options,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => ExportMenuWidget(title: title, options: options),
    );
  }

  @override
  State<ExportMenuWidget> createState() => _ExportMenuWidgetState();
}

class _ExportMenuWidgetState extends State<ExportMenuWidget> {
  String? loadingOption;

  @override
  Widget build(BuildContext context) {
    if (widget.showAsBottomSheet) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.4,
        maxChildSize: 0.8,
        minChildSize: 0.3,
        builder: (context, scrollController) => _buildContent(scrollController),
      );
    }

    return _buildContent(null);
  }

  Widget _buildContent(ScrollController? scrollController) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.showAsBottomSheet) _buildHandle(),
          const SizedBox(height: 16),
          Text(
            widget.title,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Flexible(
            child: ListView.separated(
              controller: scrollController,
              shrinkWrap: true,
              itemCount: widget.options.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder:
                  (context, index) => _buildExportOption(widget.options[index]),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildExportOption(ExportOption option) {
    final isLoading = loadingOption == option.id;

    return Card(
      color: Colors.grey.shade100,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade400),
      ),
      child: ListTile(
        leading: Icon(
          option.icon,
          color: option.color ?? Theme.of(context).colorScheme.primary,
        ),
        title: Text(option.title),
        subtitle: option.description != null ? Text(option.description!) : null,
        trailing:
            isLoading
                ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                : const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: isLoading ? null : () => _handleExportOption(option),
      ),
    );
  }

  Future<void> _handleExportOption(ExportOption option) async {
    setState(() {
      loadingOption = option.id;
    });

    try {
      await option.onTap();

      if (mounted && option.closeOnComplete) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          loadingOption = null;
        });
      }
    }
  }
}

class ExportOption {
  final String id;
  final String title;
  final String? description;
  final IconData icon;
  final Color? color;
  final Future<void> Function() onTap;
  final bool closeOnComplete;

  const ExportOption({
    required this.id,
    required this.title,
    this.description,
    required this.icon,
    this.color,
    required this.onTap,
    this.closeOnComplete = true,
  });
}

// Helpers para criar opções comuns de exportação
class ExportOptions {
  static ExportOption csvExport<T>({
    required String title,
    String? description,
    required List<T> data,
    required Future<File> Function(List<T>) exportFunction,
    VoidCallback? onSuccess,
  }) {
    return ExportOption(
      id: 'csv_export',
      title: title,
      description: description ?? 'Exportar dados em formato CSV (planilha)',
      icon: Icons.table_chart,
      color: AppColors.primarySwatch,
      onTap: () async {
        final file = await exportFunction(data);
        await ExportService.shareFile(file);
        onSuccess?.call();
      },
    );
  }

  static ExportOption jsonExport<T>({
    required String title,
    String? description,
    required T data,
    required Future<File> Function(T) exportFunction,
    VoidCallback? onSuccess,
  }) {
    return ExportOption(
      id: 'json_export',
      title: title,
      description: description ?? 'Exportar dados em formato JSON',
      icon: Icons.code,
      color: AppColors.primarySwatch,
      onTap: () async {
        final file = await exportFunction(data);
        await ExportService.shareFile(file);
        onSuccess?.call();
      },
    );
  }

  static ExportOption qrCodeShare({
    required String title,
    String? description,
    required VoidCallback onTap,
  }) {
    return ExportOption(
      id: 'qr_share',
      title: title,
      description: description ?? 'Compartilhar via QR Code',
      icon: Icons.qr_code,
      color: AppColors.primarySwatch,
      onTap: () async => onTap(),
      closeOnComplete: false,
    );
  }

  static ExportOption scanQrCode({
    required String title,
    String? description,
    required VoidCallback onTap,
  }) {
    return ExportOption(
      id: 'qr_scan',
      title: title,
      description: description ?? 'Importar escaneando QR Code',
      icon: Icons.qr_code_scanner,
      color: AppColors.primarySwatch,
      onTap: () async => onTap(),
      closeOnComplete: false,
    );
  }
}
