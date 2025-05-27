import 'package:flutter/material.dart';
import 'package:neuro_plus/common/config/theme.dart';
import 'package:neuro_plus/common/widgets/custom_button.dart';
import 'package:neuro_plus/models/appointment.dart';
import 'package:neuro_plus/models/protocol.dart';

class ProtocolTab extends StatelessWidget {
  final Appointment appointment;
  final Protocol? protocol;
  final bool isLoading;

  const ProtocolTab({
    super.key,
    required this.appointment,
    this.protocol,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (protocol == null) {
      return _buildProtocolNotFound();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProtocolInfoCard(context),
          
          if (appointment.protocolResponses != null) ...[
            const SizedBox(height: 16),
            _buildProtocolResponsesCard(),
          ],
        ],
      ),
    );
  }

  Widget _buildProtocolNotFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppColors.gray[400]),
          const SizedBox(height: 16),
          Text(
            'Protocolo não encontrado',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.gray[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProtocolInfoCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    protocol!.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.gray[800],
                    ),
                  ),
                ),
                if (appointment.status == AppointmentStatus.inProgress &&
                    appointment.protocolResponses == null)
                  CustomButton(
                    text: 'Preencher',
                    onPressed: () {
                      // TODO: Navegar para tela de preenchimento do protocolo
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Funcionalidade em desenvolvimento')),
                      );
                    },
                    fontSize: 14,
                    padding: 8,
                  ),
              ],
            ),
            if (protocol!.description != null) ...[
              const SizedBox(height: 8),
              Text(
                protocol!.description!,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.gray[600],
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.assignment, size: 16, color: AppColors.gray[500]),
                const SizedBox(width: 8),
                Text(
                  'Itens do protocolo: ${protocol!.items.length}',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.gray[500],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProtocolResponsesCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.check_circle, size: 20, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  'Respostas do protocolo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.gray[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: Colors.green[700]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Protocolo preenchido com ${appointment.protocolResponses!.length} respostas',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.green[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // TODO: Exibir as respostas do protocolo de forma organizada
            Text(
              'Visualização detalhada das respostas será implementada em breve.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.gray[500],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 