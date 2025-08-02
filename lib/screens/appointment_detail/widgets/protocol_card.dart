import 'package:flutter/material.dart';
import 'package:neuro_plus/common/config/theme.dart';
import 'package:neuro_plus/common/widgets/custom_button.dart';
import 'package:neuro_plus/common/widgets/custom_card.dart';
import 'package:neuro_plus/models/appointment.dart';
import 'package:neuro_plus/models/protocol.dart';
import 'package:neuro_plus/screens/protocol_execution/protocol_execution_screen.dart';
import 'package:neuro_plus/screens/protocol_results/protocol_results_screen.dart';

class ProtocolCard extends StatelessWidget {
  final Appointment appointment;
  final Protocol protocol;
  final VoidCallback? onProtocolUpdated;

  const ProtocolCard({
    super.key,
    required this.appointment,
    required this.protocol,
    this.onProtocolUpdated,
  });

  bool get _isProtocolFilled {
    return appointment.protocolResponses != null &&
        appointment.protocolResponses!.containsKey(protocol.id) &&
        appointment.protocolResponses![protocol.id]!.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            if (protocol.description != null) ...[
              const SizedBox(height: 8),
              _buildDescription(),
            ],
            const SizedBox(height: 16),
            _buildInfo(),
            if (_isProtocolFilled) ...[
              const SizedBox(height: 12),
              _buildFilledIndicator(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            protocol.name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.gray[800],
            ),
          ),
        ),
        _buildActionButtons(context),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      protocol.description!,
      style: TextStyle(fontSize: 14, color: AppColors.gray[600]),
    );
  }

  Widget _buildInfo() {
    return Row(
      children: [
        Icon(Icons.assignment, size: 16, color: AppColors.gray[500]),
        const SizedBox(width: 8),
        Text(
          'Itens do protocolo: ${protocol.items.length}',
          style: TextStyle(fontSize: 14, color: AppColors.gray[500]),
        ),
      ],
    );
  }

  Widget _buildFilledIndicator() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, size: 16, color: Colors.green[700]),
          const SizedBox(width: 8),
          Text(
            'Protocolo preenchido',
            style: TextStyle(
              fontSize: 12,
              color: Colors.green[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_isProtocolFilled) ...[
          CustomButton(
            text: 'Ver Resultados',
            onPressed: () => _navigateToResults(context),
            fontSize: 12,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            backgroundColor: Colors.blue[600],
          ),
          const SizedBox(width: 8),
        ],
        if (appointment.status == AppointmentStatus.inProgress)
          CustomButton(
            text: _isProtocolFilled ? 'Editar' : 'Preencher',
            onPressed: () => _navigateToExecution(context),
            fontSize: 12,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            backgroundColor: _isProtocolFilled ? AppColors.primarySwatch : null,
          ),
      ],
    );
  }

  void _navigateToExecution(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => ProtocolExecutionScreen(
              appointment: appointment,
              protocol: protocol,
            ),
      ),
    ).then((result) {
      if (result == true) {
        onProtocolUpdated?.call();

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Protocolo salvo com sucesso!')),
          );
        }
      }
    });
  }

  void _navigateToResults(BuildContext context) {
    final responses = appointment.protocolResponses?[protocol.id];
    if (responses != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => ProtocolResultsScreen(
                appointment: appointment,
                protocol: protocol,
                responses: responses,
              ),
        ),
      );
    }
  }
}
