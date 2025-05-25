import 'package:flutter/material.dart';
import 'package:neuro_plus/common/main_layout.dart';
import 'package:neuro_plus/common/services/protocols/protocol_service.dart';
import 'package:neuro_plus/common/widgets/custom_button.dart';
import 'package:neuro_plus/common/widgets/custom_form_field.dart';
import 'package:neuro_plus/common/widgets/custom_tags_field.dart';
import 'package:neuro_plus/models/protocol.dart';
import 'package:neuro_plus/screens/protocols/protocols_screen.dart';
import 'package:neuro_plus/screens/protocols_create/widgets/template_option.dart';
import 'package:uuid/uuid.dart';

class ProtocolsCreateScreen extends StatefulWidget {
  const ProtocolsCreateScreen({super.key});

  @override
  State<ProtocolsCreateScreen> createState() => _ProtocolsCreateScreenState();
}

class _ProtocolsCreateScreenState extends State<ProtocolsCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  List<String> _categories = [];
  String _selectedTemplate = 'NOVO';
  bool _isProcessing = false;

  void _selectTemplate(String template) {
    setState(() {
      _selectedTemplate = template;
    });
  }

  void _onCategoriesChanged(List<String> categories) {
    setState(() {
      _categories = categories;
    });
  }

  String? _textFieldValidator(String? text) {
    if (text == null || text.isEmpty) {
      return 'Este campo é obrigatório';
    }

    return null;
  }

  String? _categoriesValidator(List<String>? categories) {
    print(categories);

    if (categories == null || categories.isEmpty) {
      return 'Este campo é obrigatório';
    }

    return null;
  }

  Future<void> _createProtocol() async {
    setState(() {
      _isProcessing = true;
    });

    print(_categories);

    final protocol = Protocol(
      id: Uuid().v4(),
      name: _nameController.text,
      description: _descriptionController.text,
      categories: _categories,
      items: [],
      template: _selectedTemplate,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    try {
      await ProtocolsService.addProtocol(protocol);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProtocolsScreen()),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: "Novo protocolo",
      isBackButtonVisible: true,
      navIndex: 2,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text('Nome do protocolo'),
              const SizedBox(height: 8),
              CustomFormField(
                controller: _nameController,
                variant: InputVariant.outlined,
                hintText: 'Digite o nome do protocolo',
                validator: _textFieldValidator,
              ),
              const SizedBox(height: 24),
              const Text('Descrição (opcional)'),
              const SizedBox(height: 8),
              CustomFormField(
                variant: InputVariant.outlined,
                controller: _descriptionController,
                hintText: 'Digite a descrição do protocolo',
                minLines: 3,
                maxLines: 10,
              ),
              const SizedBox(height: 24),
              const Text('Categorias'),
              const SizedBox(height: 8),
              CustomTagsField(
                onChanged: _onCategoriesChanged,
                initialTags: _categories,
                hintText: 'Digite as categorias separadas por vírgula',
                validator: _categoriesValidator,
              ),
              const SizedBox(height: 24),
              const Text('Escolha um modelo'),
              const SizedBox(height: 8),
              Row(
                children: [
                  TemplateOption(
                    label: 'CRIAR NOVO',
                    isSelected: _selectedTemplate == 'NOVO',
                    onTap: () => _selectTemplate('NOVO'),
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
                    onTap: () => _selectTemplate('DENVER'),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Criar protocolo',
                onPressed: () {
                  if (!_isProcessing) {
                    _createProtocol();
                  }
                },
                isLoading: _isProcessing,
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
