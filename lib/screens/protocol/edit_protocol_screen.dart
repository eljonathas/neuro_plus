import 'package:flutter/material.dart';
import 'package:neuro_plus/core/main_layout.dart';
import 'package:neuro_plus/models/protocol.dart';
import 'package:neuro_plus/core/config/theme.dart';
import 'package:neuro_plus/services/protocol_service.dart';

class EditProtocolScreen extends StatefulWidget {
  final String protocolId;
  final String name;
  final String? description;
  final List<String> categories;
  final String template;

  const EditProtocolScreen({
    super.key,
    required this.protocolId,
    required this.name,
    this.description,
    required this.categories,
    required this.template,
  });

  @override
  State<EditProtocolScreen> createState() => _EditProtocolScreenState();
}

class _EditProtocolScreenState extends State<EditProtocolScreen> {
  final List<ProtocolItem> _items = [];
  
  @override
  void initState() {
    super.initState();
    // If using templates, we would load template items here
    if (widget.template == 'PROTEA') {
      _loadProteaTemplate();
    } else if (widget.template == 'DENVER') {
      _loadDenverTemplate();
    } else {
      // Add a default empty item for new protocol
      _addNewItem();
    }
  }
  
  void _loadProteaTemplate() {
    // This would load predefined items for the PROTEA template
    setState(() {
      _items.add(
        ProtocolItem(
          id: '1',
          title: 'Contato visual',
          instruction: 'Observe se a criança mantém contato visual',
          responseType: ResponseType.checklist,
          options: ['Ausente', 'Limitado', 'Apropriado'],
        ),
      );
    });
  }
  
  void _loadDenverTemplate() {
    // This would load predefined items for the DENVER template
    setState(() {
      _items.add(
        ProtocolItem(
          id: '1',
          title: 'Desenvolvimento motor',
          instruction: 'Avalie a coordenação motora da criança',
          responseType: ResponseType.scale,
          options: [],
        ),
      );
    });
  }
  
  void _addNewItem() {
    setState(() {
      _items.add(
        ProtocolItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: '',
          instruction: '',
          responseType: ResponseType.checklist,
          options: ['Sem evidência', 'Leve', 'Moderado', 'Severo'],
        ),
      );
    });
  }
  
  void _saveProtocol() async {
    try {
      // Atualizar o modelo com os valores dos controladores de texto e salvar
      final updatedItems = _items.map((item) {
        // Na implementação completa, seria necessário capturar os valores dos controladores
        // de texto para cada item e atualizar o título, instrução, etc.
        return item;
      }).toList();
      
      final protocol = Protocol(
        id: widget.protocolId,
        name: widget.name,
        description: widget.description,
        categories: widget.categories,
        template: widget.template,
        items: updatedItems,
        createdAt: DateTime.now(), // Adicionando valores para createdAt e updatedAt
        updatedAt: DateTime.now(),
      );
      
      await ProtocolService.saveProtocol(protocol);
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Protocolo salvo com sucesso!')),
      );
      // Navigate back
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar protocolo: $e')),
      );
    }
  }

  void _updateResponseType(ProtocolItem item, ResponseType type) {
    final index = _items.indexWhere((element) => element.id == item.id);
    if (index != -1) {
      setState(() {
        final updatedItem = ProtocolItem(
          id: item.id,
          title: item.title,
          instruction: item.instruction,
          responseType: type,
          options: item.options,
        );
        _items[index] = updatedItem;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: "Editar protocolo",
      navIndex: 2, // Protocolos tab
      isBackButtonVisible: true,
      onNavTap: (index) {
        // Handle navigation
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              widget.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
          ),
          ..._items.map((item) => _buildItemEditor(item)).toList(),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 8),
            child: OutlinedButton.icon(
              onPressed: _addNewItem,
              icon: Icon(Icons.add, color: AppColors.primarySwatch, size: 20),
              label: Text(
                'Adicionar novo item',
                style: TextStyle(
                  color: AppColors.primarySwatch,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                side: BorderSide(color: AppColors.primarySwatch),
              ),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveProtocol,
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
                'Salvar e fechar',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildItemEditor(ProtocolItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Título/Habilidade',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Ex: Fala pelo menos 6 palavras reconhecíveis?',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.primarySwatch.withOpacity(0.3)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Instrução (opcional)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Ex: Pergunte aos responsáveis ou incentive a nomeação de objetos.',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.primarySwatch.withOpacity(0.3)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tipo da resposta',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 12),
                _buildResponseTypeSelector(item),
              ],
            ),
          ),
          if (item.responseType == ResponseType.checklist)
            _buildChecklistOptions(item),
          if (item.responseType == ResponseType.scale)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                'Escala de 0 a 5 selecionada',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          Divider(color: Colors.grey[200], height: 1),
        ],
      ),
    );
  }
  
  Widget _buildResponseTypeSelector(ProtocolItem item) {
    return Wrap(
      spacing: 16,
      children: [
        _buildResponseTypeOption(
          label: 'Checklist',
          isSelected: item.responseType == ResponseType.checklist,
          onTap: () => _updateResponseType(item, ResponseType.checklist),
        ),
        _buildResponseTypeOption(
          label: 'Escala de 0 a 5',
          isSelected: item.responseType == ResponseType.scale,
          onTap: () => _updateResponseType(item, ResponseType.scale),
        ),
        _buildResponseTypeOption(
          label: 'Texto livre',
          isSelected: item.responseType == ResponseType.text,
          onTap: () => _updateResponseType(item, ResponseType.text),
        ),
      ],
    );
  }
  
  Widget _buildResponseTypeOption({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio(
            value: true,
            groupValue: isSelected,
            activeColor: AppColors.primarySwatch,
            visualDensity: VisualDensity.compact,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onChanged: (_) => onTap(),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isSelected ? AppColors.primarySwatch : Colors.black87,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildChecklistOptions(ProtocolItem item) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: Colors.grey[200]),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Opção 1',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF666666),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('Sem evidência'),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Opção 2',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF666666),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('Leve'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Opção 3',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF666666),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('Moderado'),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Opção 4',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF666666),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('Severo'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: () {
              // Add new option
            },
            icon: Icon(Icons.add, size: 16, color: AppColors.primarySwatch),
            label: Text(
              'Nova opção',
              style: TextStyle(
                color: AppColors.primarySwatch,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }
} 