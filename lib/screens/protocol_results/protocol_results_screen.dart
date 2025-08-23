import 'package:flutter/material.dart';
import 'package:neuro_plus/common/config/theme.dart';
import 'package:neuro_plus/common/main_layout.dart';
import 'package:neuro_plus/common/widgets/custom_card.dart';
import 'package:neuro_plus/models/appointment.dart';
import 'package:neuro_plus/models/protocol.dart';

class ProtocolResultsScreen extends StatelessWidget {
  final Appointment appointment;
  final Protocol protocol;
  final Map<String, dynamic> responses;

  const ProtocolResultsScreen({
    super.key,
    required this.appointment,
    required this.protocol,
    required this.responses,
  });

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Resultados do Protocolo',
      navIndex: 1,
      isBackButtonVisible: true,
      child: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: 32),
              _buildResultsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primarySwatch.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.assignment_turned_in,
                color: AppColors.primarySwatch,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    protocol.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Protocolo de Avaliação',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.gray[500],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.gray[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.gray[200]!),
          ),
          child: Column(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 600) {
                    return Column(
                      children: [
                        _buildInfoItem(
                          icon: Icons.person,
                          label: 'Paciente',
                          value: appointment.patientName,
                          isFullWidth: true,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoItem(
                                icon: Icons.calendar_today,
                                label: 'Data',
                                value: appointment.formattedDate,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildInfoItem(
                                icon: Icons.access_time,
                                label: 'Horário',
                                value: appointment.time,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }

                  return IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 2,
                          child: _buildInfoItem(
                            icon: Icons.person,
                            label: 'Paciente',
                            value: appointment.patientName,
                          ),
                        ),
                        Container(
                          width: 1,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: AppColors.gray[300],
                            borderRadius: BorderRadius.circular(0.5),
                          ),
                        ),
                        Expanded(
                          child: _buildInfoItem(
                            icon: Icons.calendar_today,
                            label: 'Data',
                            value: appointment.formattedDate,
                          ),
                        ),
                        Container(
                          width: 1,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: AppColors.gray[300],
                            borderRadius: BorderRadius.circular(0.5),
                          ),
                        ),
                        Expanded(
                          child: _buildInfoItem(
                            icon: Icons.access_time,
                            label: 'Horário',
                            value: appointment.time,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              if (protocol.description != null) ...[
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.gray[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.description,
                            size: 16,
                            color: AppColors.gray[600],
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Descrição do Protocolo',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.gray[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        protocol.description!,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.gray[600],
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    bool isFullWidth = false,
  }) {
    return Container(
      width: isFullWidth ? double.infinity : null,
      padding: isFullWidth ? const EdgeInsets.all(12) : null,
      decoration:
          isFullWidth
              ? BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.gray[200]!),
              )
              : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: AppColors.gray[500]),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.gray[500],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: isFullWidth ? 18 : 16,
              fontWeight: FontWeight.w600,
              color: AppColors.gray[800],
            ),
            maxLines: isFullWidth ? 2 : 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildResultsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.analytics, color: AppColors.primarySwatch, size: 24),
            const SizedBox(width: 12),
            Text(
              'Resultados da Avaliação',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.gray[800],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Respostas coletadas durante a aplicação do protocolo',
          style: TextStyle(fontSize: 14, color: AppColors.gray[600]),
        ),
        const SizedBox(height: 24),
        _buildResultsList(),
      ],
    );
  }

  Widget _buildResultsList() {
    return Column(
      children:
          protocol.items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final response = responses[item.id];
            if (response == null) return const SizedBox.shrink();

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildResultItem(item, response, index + 1),
            );
          }).toList(),
    );
  }

  Widget _buildResultItem(ProtocolItem item, dynamic response, int index) {
    return CustomCard(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primarySwatch,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '$index',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.gray[800],
                          height: 1.3,
                        ),
                      ),
                      if (item.instruction != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          item.instruction!,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.gray[500],
                            fontStyle: FontStyle.italic,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                _buildResponseTypeIndicator(item.responseType),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: _buildResponseDisplay(item, response),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResponseTypeIndicator(ResponseType responseType) {
    IconData icon;
    String label;
    Color color;

    switch (responseType) {
      case ResponseType.text:
        icon = Icons.text_fields;
        label = 'Texto';
        color = Colors.blue;
        break;
      case ResponseType.scale:
        icon = Icons.linear_scale;
        label = 'Escala';
        color = Colors.orange;
        break;
      case ResponseType.checklist:
        icon = Icons.checklist;
        label = 'Lista';
        color = Colors.green;
        break;
      case ResponseType.multipleChoice:
        icon = Icons.check_box;
        label = 'Múltipla escolha';
        color = Colors.purple;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponseDisplay(ProtocolItem item, dynamic response) {
    switch (item.responseType) {
      case ResponseType.text:
        return _buildTextResponse(response);
      case ResponseType.scale:
        return _buildScaleResponse(response);
      case ResponseType.checklist:
      case ResponseType.multipleChoice:
        return _buildChecklistResponse(response);
    }
  }

  Widget _buildTextResponse(dynamic response) {
    final hasResponse = response.toString().isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: hasResponse ? Colors.white : AppColors.gray[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasResponse ? AppColors.gray[300]! : AppColors.gray[200]!,
          width: hasResponse ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                hasResponse ? Icons.chat_bubble : Icons.chat_bubble_outline,
                size: 16,
                color:
                    hasResponse ? AppColors.primarySwatch : AppColors.gray[400],
              ),
              const SizedBox(width: 8),
              Text(
                'Resposta',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color:
                      hasResponse ? AppColors.gray[700] : AppColors.gray[400],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            hasResponse ? response.toString() : 'Não respondido',
            style: TextStyle(
              fontSize: 15,
              color: hasResponse ? AppColors.gray[800] : AppColors.gray[400],
              fontStyle: hasResponse ? FontStyle.normal : FontStyle.italic,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScaleResponse(dynamic response) {
    final value = response is int ? response : 1;
    final percentage = (value / 5) * 100;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray[300]!, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.analytics, size: 16, color: AppColors.primarySwatch),
              const SizedBox(width: 8),
              Text(
                'Pontuação',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.gray[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$value de 5',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primarySwatch,
                          ),
                        ),
                        Text(
                          '${percentage.toStringAsFixed(0)}%',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.gray[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.gray[200],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: value / 5,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primarySwatch,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistResponse(dynamic response) {
    final selectedOptions =
        response is List ? List<String>.from(response) : <String>[];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray[300]!, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.checklist, size: 16, color: AppColors.primarySwatch),
              const SizedBox(width: 8),
              Text(
                'Opções Selecionadas',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.gray[700],
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color:
                      selectedOptions.isEmpty
                          ? AppColors.gray[100]
                          : Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${selectedOptions.length} ${selectedOptions.length == 1 ? 'item' : 'itens'}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color:
                        selectedOptions.isEmpty
                            ? AppColors.gray[500]
                            : Colors.green[700],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (selectedOptions.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.gray[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Nenhuma opção foi selecionada',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.gray[400],
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            )
          else
            Column(
              children:
                  selectedOptions.map((option) {
                    return Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.green.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 18,
                            color: Colors.green[600],
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              option,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.gray[800],
                                height: 1.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
            ),
        ],
      ),
    );
  }
}
