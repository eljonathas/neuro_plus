import 'package:flutter/material.dart';
import 'package:neuro_plus/core/main_layout.dart';
import 'package:neuro_plus/screens/protocol/edit_protocol_screen.dart';
import 'package:uuid/uuid.dart';
import 'package:neuro_plus/core/config/theme.dart';
import 'package:neuro_plus/models/protocol.dart';
import 'package:neuro_plus/services/protocol_service.dart';

class CreateProtocolScreen extends StatefulWidget {
  const CreateProtocolScreen({super.key});

  @override
  State<CreateProtocolScreen> createState() => _CreateProtocolScreenState();
}

class _CreateProtocolScreenState extends State<CreateProtocolScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoriesController = TextEditingController();
  String _selectedTemplate = 'NOVO';

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _categoriesController.dispose();
    super.dispose();
  }

  void _goToEditScreen() {
    if (_formKey.currentState!.validate()) {
      final uuid = const Uuid().v4();

      // Criar um novo protocolo
      final protocol = Protocol(
        id: uuid,
        name: _nameController.text,
        description: _descriptionController.text,
        categories:
            _categoriesController.text
                .split(',')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList(),
        template: _selectedTemplate.isEmpty ? 'NOVO' : _selectedTemplate,
        items: [],
      );

      // Salvar o protocolo
      try {
        ProtocolService.saveProtocol(protocol);

        // Navegar para a tela de edição
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => EditProtocolScreen(
                  protocolId: protocol.id,
                  name: protocol.name,
                  description: protocol.description,
                  categories: protocol.categories,
                  template: protocol.template,
                ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao criar protocolo: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: "Novo protocolo",
      navIndex: 2, // Protocolos tab
      isBackButtonVisible: true,
      onNavTap: (index) {},
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text(
              'Nome do Protocolo',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Digite o nome do protocolo',
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.primarySwatch),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nome do protocolo é obrigatório';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Descrição (Opcional)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                hintText: 'Digite uma descrição para o protocolo',
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.primarySwatch),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 24),
            const Text(
              'Categorias (Opcional)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _categoriesController,
              decoration: InputDecoration(
                hintText: 'Utilize a vírgula como separador',
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.primarySwatch),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Escolha um modelo',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildTemplateOption(
                  'CRIAR NOVO',
                  isSelected: _selectedTemplate == 'NOVO',
                ),
                const SizedBox(width: 12),
                _buildTemplateOption(
                  'PROTEA',
                  isSelected: _selectedTemplate == 'PROTEA',
                ),
                const SizedBox(width: 12),
                _buildTemplateOption(
                  'DENVER II',
                  isSelected: _selectedTemplate == 'DENVER',
                ),
              ],
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _goToEditScreen,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppColors.primarySwatch,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Ir para edição',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTemplateOption(String label, {required bool isSelected}) {
    return InkWell(
      onTap: () {
        setState(() {
          if (label == 'CRIAR NOVO') {
            _selectedTemplate = 'NOVO';
          } else if (label == 'PROTEA') {
            _selectedTemplate = 'PROTEA';
          } else if (label == 'DENVER II') {
            _selectedTemplate = 'DENVER';
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.primarySwatch.withOpacity(0.2)
                  : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primarySwatch : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.primarySwatch : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
