import 'package:flutter/material.dart';
import 'package:neuro_plus/common/main_layout.dart';
import 'package:neuro_plus/common/services/protocols/protocol_service.dart';
import 'package:neuro_plus/common/widgets/custom_button.dart';
import 'package:neuro_plus/core/navigation/app_routes.dart';
import 'package:neuro_plus/models/protocol.dart';
import 'package:neuro_plus/screens/protocols_create/widgets/protocol_basic_fields.dart';
import 'package:neuro_plus/screens/protocols_create/widgets/protocol_template_selector.dart';
import 'package:neuro_plus/screens/protocols_create/widgets/protocol_items_section.dart';
import 'package:uuid/uuid.dart';

class ProtocolsCreateScreen extends StatefulWidget {
  final Protocol? protocol;

  const ProtocolsCreateScreen({super.key, this.protocol});

  @override
  State<ProtocolsCreateScreen> createState() => _ProtocolsCreateScreenState();
}

class _ProtocolsCreateScreenState extends State<ProtocolsCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late List<String> _categories;
  late String _selectedTemplate;
  late List<ProtocolItem> _items;
  final Map<String, TextEditingController> _itemControllers = {};
  bool _isProcessing = false;

  bool get _isEditing => widget.protocol != null;

  // Cache para validadores
  late final String? Function(String?) _requiredValidator;
  late final String? Function(List<String>?) _categoriesValidator;

  @override
  void initState() {
    super.initState();
    _initializeValidators();
    _initializeData();
  }

  void _initializeValidators() {
    _requiredValidator =
        (String? value) =>
            (value?.isEmpty ?? true) ? 'Este campo é obrigatório' : null;
    _categoriesValidator =
        (List<String>? categories) =>
            (categories?.isEmpty ?? true) ? 'Este campo é obrigatório' : null;
  }

  void _initializeData() {
    final protocol = widget.protocol;
    _nameController = TextEditingController(text: protocol?.name ?? '');
    _descriptionController = TextEditingController(
      text: protocol?.description ?? '',
    );
    _categories = List.from(protocol?.categories ?? []);
    _selectedTemplate = protocol?.template ?? 'NOVO';
    _items = List.from(protocol?.items ?? []);

    _initializeItemControllers();
  }

  void _initializeItemControllers() {
    for (final item in _items) {
      _itemControllers['${item.id}_title'] = TextEditingController(
        text: item.title,
      );
      _itemControllers['${item.id}_instruction'] = TextEditingController(
        text: item.instruction ?? '',
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    for (final controller in _itemControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onCategoriesChanged(List<String> categories) {
    _categories = categories;
  }

  void _onTemplateChanged(String template) {
    setState(() {
      _selectedTemplate = template;
    });
  }

  void _addNewItem() {
    final newItem = ProtocolItem(
      id: const Uuid().v4(),
      title: '',
      instruction: '',
      responseType: ResponseType.checklist,
      options: const [],
    );

    setState(() {
      _items.add(newItem);
      _itemControllers['${newItem.id}_title'] = TextEditingController();
      _itemControllers['${newItem.id}_instruction'] = TextEditingController();
    });
  }

  void _removeItem(String itemId) {
    setState(() {
      _items.removeWhere((item) => item.id == itemId);
      _itemControllers['${itemId}_title']?.dispose();
      _itemControllers['${itemId}_instruction']?.dispose();
      _itemControllers.remove('${itemId}_title');
      _itemControllers.remove('${itemId}_instruction');
    });
  }

  void _updateItemResponseType(ProtocolItem item, ResponseType responseType) {
    setState(() {
      final index = _items.indexWhere((i) => i.id == item.id);
      if (index != -1) {
        _items[index] = item.copyWith(responseType: responseType);
      }
    });
  }

  void _updateItemOptions(ProtocolItem item, List<String> options) {
    final index = _items.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      _items[index] = item.copyWith(options: options);
    }
  }

  List<ProtocolItem> _buildUpdatedItems() {
    return _items.map((item) {
      final titleController = _itemControllers['${item.id}_title'];
      final instructionController = _itemControllers['${item.id}_instruction'];

      return item.copyWith(
        title: titleController?.text ?? item.title,
        instruction:
            instructionController?.text.isEmpty == true
                ? null
                : instructionController?.text,
      );
    }).toList();
  }

  Future<void> _saveProtocol() async {
    if (!_formKey.currentState!.validate()) return;

    final updatedItems = _buildUpdatedItems();

    // Validar se todos os itens têm título
    for (int i = 0; i < updatedItems.length; i++) {
      final item = updatedItems[i];
      if (item.title.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('O item ${i + 1} precisa ter um título.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    // Validar opções de checklist
    for (final item in updatedItems) {
      if (item.responseType == ResponseType.checklist && item.options.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'O item "${item.title}" do tipo Checklist precisa ter pelo menos uma opção de resposta.',
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    setState(() => _isProcessing = true);

    try {
      final protocol =
          _isEditing
              ? widget.protocol!.copyWith(
                name: _nameController.text,
                description:
                    _descriptionController.text.isEmpty
                        ? null
                        : _descriptionController.text,
                categories: _categories,
                items: updatedItems,
              )
              : Protocol(
                name: _nameController.text,
                description:
                    _descriptionController.text.isEmpty
                        ? null
                        : _descriptionController.text,
                categories: _categories,
                items: updatedItems,
                template: _selectedTemplate,
              );

      await (_isEditing
          ? ProtocolsService.updateProtocol(protocol)
          : ProtocolsService.addProtocol(protocol));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Protocolo ${_isEditing ? 'atualizado' : 'criado'} com sucesso!',
            ),
          ),
        );
        AppRoutes.navigateTo(context, AppRoutes.protocols);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Erro ao ${_isEditing ? 'atualizar' : 'criar'} protocolo: $e',
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: "${_isEditing ? 'Editar' : 'Novo'} protocolo",
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
              ProtocolBasicFields(
                nameController: _nameController,
                descriptionController: _descriptionController,
                categories: _categories,
                onCategoriesChanged: _onCategoriesChanged,
                nameValidator: _requiredValidator,
                categoriesValidator: _categoriesValidator,
              ),
              if (!_isEditing)
                ProtocolTemplateSelector(
                  selectedTemplate: _selectedTemplate,
                  onTemplateChanged: _onTemplateChanged,
                ),
              const SizedBox(height: 24),
              ProtocolItemsSection(
                items: _items,
                itemControllers: _itemControllers,
                onAddItem: _addNewItem,
                onRemoveItem: _removeItem,
                onUpdateItemResponseType: _updateItemResponseType,
                onUpdateItemOptions: _updateItemOptions,
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: _isEditing ? 'Salvar alterações' : 'Criar protocolo',
                onPressed: _saveProtocol,
                isLoading: _isProcessing,
                width: double.infinity,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
