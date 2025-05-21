import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
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
  bool _isProcessing = false;

  // Memoize styles
  static const _titleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Color(0xFF333333),
  );

  static const _buttonTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _categoriesController.dispose();
    super.dispose();
  }

  // Método para criar protocolo em um isolate separado
  Future<Protocol> _createProtocolAsync({
    required String name,
    required String description,
    required List<String> categories,
    required String template,
  }) async {
    return compute(
      _createProtocolIsolate,
      {
        'id': const Uuid().v4(),
        'name': name,
        'description': description,
        'categories': categories,
        'template': template,
      },
    );
  }

  // Função estática para ser executada em um isolate
  static Protocol _createProtocolIsolate(Map<String, dynamic> params) {
    return Protocol(
      id: params['id'],
      name: params['name'],
      description: params['description'],
      categories: params['categories'],
      template: params['template'],
      items: [],
    );
  }

  Future<void> _goToEditScreen() async {
    if (_formKey.currentState?.validate() == true) {
      setState(() {
        _isProcessing = true;
      });

      try {
        final categories = _categoriesController.text
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();

        final protocol = await _createProtocolAsync(
          name: _nameController.text,
          description: _descriptionController.text,
          categories: categories,
          template: _selectedTemplate,
        );

        await ProtocolService.saveProtocol(protocol);

        if (!mounted) return;
        
        setState(() {
          _isProcessing = false;
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditProtocolScreen(
              protocolId: protocol.id,
              name: protocol.name,
              description: protocol.description,
              categories: protocol.categories,
              template: protocol.template,
            ),
          ),
        );
      } catch (e) {
        setState(() {
          _isProcessing = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao criar protocolo: $e')),
        );
      }
    }
  }

  void _selectTemplate(String label) {
    String newTemplate;
    if (label == 'CRIAR NOVO') {
      newTemplate = 'NOVO';
    } else if (label == 'PROTEA') {
      newTemplate = 'PROTEA';
    } else if (label == 'DENVER II') {
      newTemplate = 'DENVER';
    } else {
      return;
    }

    if (newTemplate != _selectedTemplate) {
      setState(() {
        _selectedTemplate = newTemplate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: "Novo protocolo",
      navIndex: 2,
      isBackButtonVisible: true,
      onNavTap: (index) {},
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text(
                'Nome do Protocolo',
                style: _titleStyle,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Digite o nome do protocolo',
                  hintStyle: TextStyle(color: Color(0xFFAAAAAA)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(color: Color(0xFFDDDDDD)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(color: Color(0xFFDDDDDD)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(color: AppColors.primarySwatch),
                  ),
                  contentPadding: EdgeInsets.symmetric(
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
                'Descrição',
                style: _titleStyle,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Digite uma descrição para o protocolo (opcional)',
                  hintStyle: TextStyle(color: Color(0xFFAAAAAA)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(color: Color(0xFFDDDDDD)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(color: Color(0xFFDDDDDD)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(color: AppColors.primarySwatch),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Categorias',
                style: _titleStyle,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _categoriesController,
                decoration: const InputDecoration(
                  hintText: 'Digite as categorias separadas por vírgula (opcional)',
                  hintStyle: TextStyle(color: Color(0xFFAAAAAA)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(color: Color(0xFFDDDDDD)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(color: Color(0xFFDDDDDD)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(color: AppColors.primarySwatch),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Template',
                style: _titleStyle,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  TemplateOption(
                    label: 'CRIAR NOVO',
                    isSelected: _selectedTemplate == 'NOVO',
                    onTap: () => _selectTemplate('CRIAR NOVO'),
                  ),
                  const SizedBox(width: 12),
                  TemplateOption(
                    label: 'PROTEA',
                    isSelected: _selectedTemplate == 'PROTEA',
                    onTap: () => _selectTemplate('PROTEA'),
                  ),
                  const SizedBox(width: 12),
                  TemplateOption(
                    label: 'DENVER II',
                    isSelected: _selectedTemplate == 'DENVER',
                    onTap: () => _selectTemplate('DENVER II'),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isProcessing ? null : _goToEditScreen,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.primarySwatch,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    disabledBackgroundColor: AppColors.primarySwatch.withOpacity(0.5),
                  ),
                  child: _isProcessing
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Ir para edição',
                          style: _buttonTextStyle,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget separado para opção de template
class TemplateOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const TemplateOption({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primarySwatch.withOpacity(0.2)
                : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppColors.primarySwatch : const Color(0xFFDDDDDD),
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
      ),
    );
  }
}
