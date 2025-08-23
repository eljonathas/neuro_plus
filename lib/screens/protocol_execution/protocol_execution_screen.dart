import 'package:flutter/material.dart';
import 'package:neuro_plus/common/config/theme.dart';
import 'package:neuro_plus/common/main_layout.dart';
import 'package:neuro_plus/common/services/appointments/appointments_service.dart';
import 'package:neuro_plus/common/widgets/custom_button.dart';
import 'package:neuro_plus/common/widgets/custom_card.dart';
import 'package:neuro_plus/common/widgets/custom_form_field.dart';
import 'package:neuro_plus/models/appointment.dart';
import 'package:neuro_plus/models/protocol.dart';

class ProtocolExecutionScreen extends StatefulWidget {
  final Appointment appointment;
  final Protocol protocol;

  const ProtocolExecutionScreen({
    super.key,
    required this.appointment,
    required this.protocol,
  });

  @override
  State<ProtocolExecutionScreen> createState() =>
      _ProtocolExecutionScreenState();
}

class _ProtocolExecutionScreenState extends State<ProtocolExecutionScreen> {
  final Map<String, dynamic> _responses = {};
  final Map<String, TextEditingController> _controllers = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    for (final item in widget.protocol.items) {
      // Inicializar valores padrão primeiro
      switch (item.responseType) {
        case ResponseType.text:
          _responses[item.id] = '';
          break;
        case ResponseType.scale:
          _responses[item.id] = 1;
          break;
        case ResponseType.checklist:
        case ResponseType.multipleChoice:
          _responses[item.id] = <String>[];
          break;
      }

      // Se já existem respostas salvas, sobrescrever com os valores salvos
      if (widget.appointment.protocolResponses != null) {
        final protocolResponses =
            widget.appointment.protocolResponses![widget.protocol.id];
        if (protocolResponses != null) {
          final existingResponse = protocolResponses[item.id];
          if (existingResponse != null) {
            switch (item.responseType) {
              case ResponseType.text:
                _responses[item.id] = existingResponse.toString();
                break;
              case ResponseType.scale:
                _responses[item.id] =
                    existingResponse is int ? existingResponse : 1;
                break;
              case ResponseType.checklist:
              case ResponseType.multipleChoice:
                _responses[item.id] =
                    existingResponse is List
                        ? List<String>.from(existingResponse)
                        : <String>[];
                break;
            }
          }
        }
      }

      // Criar controladores para campos de texto
      if (item.responseType == ResponseType.text) {
        _controllers[item.id] = TextEditingController(
          text: _responses[item.id]?.toString() ?? '',
        );

        // Adicionar listener para atualizar as respostas em tempo real
        _controllers[item.id]!.addListener(() {
          _responses[item.id] = _controllers[item.id]!.text;
        });
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _saveResponses() async {
    setState(() => _isLoading = true);

    try {
      // Coletar todas as respostas atuais
      final finalResponses = <String, dynamic>{};

      for (final item in widget.protocol.items) {
        switch (item.responseType) {
          case ResponseType.text:
            final controller = _controllers[item.id];
            finalResponses[item.id] = controller?.text ?? '';
            break;
          case ResponseType.scale:
            finalResponses[item.id] = _responses[item.id] ?? 1;
            break;
          case ResponseType.checklist:
          case ResponseType.multipleChoice:
            finalResponses[item.id] = _responses[item.id] ?? <String>[];
            break;
        }
      }

      await AppointmentsService.updateAppointmentProtocolResponses(
        widget.appointment.id,
        widget.protocol.id,
        finalResponses,
      );

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Protocolo salvo com sucesso!')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao salvar protocolo: $e')));
      }
    }
  }

  Widget _buildProtocolItem(ProtocolItem item) {
    switch (item.responseType) {
      case ResponseType.text:
        return _buildTextResponse(item);
      case ResponseType.scale:
        return _buildScaleResponse(item);
      case ResponseType.checklist:
        return _buildChecklistResponse(item);
      case ResponseType.multipleChoice:
        return _buildMultipleChoiceResponse(item);
    }
  }

  Widget _buildTextResponse(ProtocolItem item) {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            if (item.instruction != null) ...[
              const SizedBox(height: 8),
              Text(
                item.instruction!,
                style: TextStyle(fontSize: 14, color: AppColors.gray[600]),
              ),
            ],
            const SizedBox(height: 16),
            CustomFormField(
              controller: _controllers[item.id]!,
              hintText: 'Digite sua resposta...',
              maxLines: 3,
              variant: InputVariant.outlined,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScaleResponse(ProtocolItem item) {
    final currentValue = _responses[item.id] as int? ?? 1;

    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            if (item.instruction != null) ...[
              const SizedBox(height: 8),
              Text(
                item.instruction!,
                style: TextStyle(fontSize: 14, color: AppColors.gray[600]),
              ),
            ],
            const SizedBox(height: 16),
            Text(
              'Selecione uma opção:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.gray[700],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (index) {
                final value = index + 1;
                return Column(
                  children: [
                    Radio<int>(
                      value: value,
                      groupValue: currentValue,
                      onChanged: (newValue) {
                        setState(() {
                          _responses[item.id] = newValue;
                        });
                      },
                    ),
                    Text(
                      value.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.gray[700],
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChecklistResponse(ProtocolItem item) {
    final selectedOptions = _responses[item.id] as List<String>? ?? [];

    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            if (item.instruction != null) ...[
              const SizedBox(height: 8),
              Text(
                item.instruction!,
                style: TextStyle(fontSize: 14, color: AppColors.gray[600]),
              ),
            ],
            const SizedBox(height: 16),
            ...item.options.map((option) {
              final isSelected = selectedOptions.contains(option);
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: CheckboxListTile(
                  title: Text(option, style: const TextStyle(fontSize: 14)),
                  value: isSelected,
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        selectedOptions.add(option);
                      } else {
                        selectedOptions.remove(option);
                      }
                      _responses[item.id] = List<String>.from(selectedOptions);
                    });
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildMultipleChoiceResponse(ProtocolItem item) {
    final selectedOptions = _responses[item.id] as List<String>? ?? [];

    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            if (item.instruction != null) ...[
              const SizedBox(height: 8),
              Text(
                item.instruction!,
                style: TextStyle(fontSize: 14, color: AppColors.gray[600]),
              ),
            ],
            const SizedBox(height: 16),
            ...item.options.map((option) {
              final isSelected = selectedOptions.contains(option);
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: CheckboxListTile(
                  title: Text(option, style: const TextStyle(fontSize: 14)),
                  value: isSelected,
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        selectedOptions.add(option);
                      } else {
                        selectedOptions.remove(option);
                      }
                      _responses[item.id] = List<String>.from(selectedOptions);
                    });
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Preencher Protocolo',
      navIndex: 1,
      isBackButtonVisible: true,
      child: Column(
        children: [
          // Header do protocolo
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.protocol.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Paciente: ${widget.appointment.patientName}',
                  style: TextStyle(fontSize: 16, color: AppColors.gray[600]),
                ),
              ],
            ),
          ),

          // Lista de itens do protocolo
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: widget.protocol.items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final item = widget.protocol.items[index];
                return _buildProtocolItem(item);
              },
            ),
          ),

          // Botões de ação
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Cancelar',
                    onPressed: () => Navigator.pop(context),
                    backgroundColor: AppColors.gray[300],
                    foregroundColor: AppColors.gray[800],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomButton(
                    text: 'Salvar',
                    onPressed: _saveResponses,
                    isLoading: _isLoading,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
