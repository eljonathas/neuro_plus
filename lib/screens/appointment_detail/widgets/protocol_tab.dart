import 'package:flutter/material.dart';
import 'package:neuro_plus/common/config/theme.dart';
import 'package:neuro_plus/common/services/protocols/protocol_service.dart';
import 'package:neuro_plus/models/appointment.dart';
import 'package:neuro_plus/models/protocol.dart';
import 'package:neuro_plus/screens/appointment_detail/widgets/protocol_card.dart';

class ProtocolTab extends StatefulWidget {
  final Appointment appointment;
  final bool isLoading;
  final VoidCallback? onProtocolUpdated;

  const ProtocolTab({
    super.key,
    required this.appointment,
    this.isLoading = false,
    this.onProtocolUpdated,
  });

  @override
  State<ProtocolTab> createState() => _ProtocolTabState();
}

class _ProtocolTabState extends State<ProtocolTab> {
  List<Protocol> _protocols = [];
  bool _isLoadingProtocols = false;

  @override
  void initState() {
    super.initState();
    _loadProtocols();
  }

  Future<void> _loadProtocols() async {
    if (widget.appointment.protocolIds == null ||
        widget.appointment.protocolIds!.isEmpty) {
      return;
    }

    setState(() => _isLoadingProtocols = true);

    try {
      await ProtocolsService.init();
      final protocols = <Protocol>[];

      for (final protocolId in widget.appointment.protocolIds!) {
        final protocol = ProtocolsService.getProtocolById(protocolId);
        if (protocol != null) {
          protocols.add(protocol);
        }
      }

      if (mounted) {
        setState(() {
          _protocols = protocols;
          _isLoadingProtocols = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingProtocols = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar protocolos: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading || _isLoadingProtocols) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!widget.appointment.hasProtocol) {
      return _buildNoProtocolsState();
    }

    if (_protocols.isEmpty) {
      return _buildProtocolsNotFound();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ..._protocols.map(
            (protocol) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ProtocolCard(
                appointment: widget.appointment,
                protocol: protocol,
                onProtocolUpdated: widget.onProtocolUpdated,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoProtocolsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_outlined, size: 64, color: AppColors.gray[400]),
          const SizedBox(height: 16),
          Text(
            'Nenhum protocolo associado',
            style: TextStyle(fontSize: 18, color: AppColors.gray[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Esta consulta não possui protocolos para preenchimento.',
            style: TextStyle(fontSize: 14, color: AppColors.gray[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProtocolsNotFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppColors.gray[400]),
          const SizedBox(height: 16),
          Text(
            'Protocolos não encontrados',
            style: TextStyle(fontSize: 18, color: AppColors.gray[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Os protocolos associados a esta consulta não foram encontrados.',
            style: TextStyle(fontSize: 14, color: AppColors.gray[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
