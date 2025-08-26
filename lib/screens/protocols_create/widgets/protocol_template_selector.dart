import 'package:flutter/material.dart';
import 'package:neuro_plus/common/config/theme.dart';
import 'package:neuro_plus/common/services/protocols/protocol_service.dart';
import 'package:neuro_plus/models/protocol.dart';
import 'package:neuro_plus/screens/protocols_create/widgets/template_option.dart';

class ProtocolTemplateSelector extends StatefulWidget {
  final String? selectedTemplate;
  final ValueChanged<String?> onTemplateChanged;
  final Function(List<ProtocolItem>)? onProtocolSelected;

  const ProtocolTemplateSelector({
    super.key,
    required this.selectedTemplate,
    required this.onTemplateChanged,
    this.onProtocolSelected,
  });

  @override
  State<ProtocolTemplateSelector> createState() =>
      _ProtocolTemplateSelectorState();
}

class _ProtocolTemplateSelectorState extends State<ProtocolTemplateSelector> {
  List<Protocol> _existingProtocols = [];
  List<Protocol> _filteredProtocols = [];
  bool _isLoading = false;
  bool _showAllProtocols = false;
  final _searchController = TextEditingController();
  static const int _initialDisplayCount = 3;

  @override
  void initState() {
    super.initState();
    _loadExistingProtocols();
    _searchController.addListener(_filterProtocols);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterProtocols);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadExistingProtocols() async {
    setState(() => _isLoading = true);

    try {
      final protocols = ProtocolsService.getAllProtocols();
      setState(() {
        _existingProtocols = protocols;
        _filteredProtocols = protocols;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _filterProtocols() {
    final query = _searchController.text.toLowerCase().trim();

    setState(() {
      if (query.isEmpty) {
        _filteredProtocols = _existingProtocols;
      } else {
        _filteredProtocols =
            _existingProtocols.where((protocol) {
              final nameMatch = protocol.name.toLowerCase().contains(query);
              final descriptionMatch =
                  protocol.description?.toLowerCase().contains(query) ?? false;
              return nameMatch || descriptionMatch;
            }).toList();
      }
      // Reset "show all" when searching
      _showAllProtocols = false;
    });
  }

  void _selectTemplate(String template) {
    widget.onTemplateChanged(template);
  }

  void _selectExistingProtocol(Protocol protocol) {
    widget.onTemplateChanged('EXISTING_${protocol.id}');
    widget.onProtocolSelected?.call(protocol.items);
  }

  List<Protocol> get _displayedProtocols {
    if (_showAllProtocols ||
        _filteredProtocols.length <= _initialDisplayCount) {
      return _filteredProtocols;
    }
    return _filteredProtocols.take(_initialDisplayCount).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text(
          'Escolha um modelo',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Crie um novo protocolo ou use um existente como base',
          style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
        ),
        const SizedBox(height: 16),

        // Opção para criar novo
        TemplateOption(
          label: 'Criar novo protocolo',
          isSelected: widget.selectedTemplate == 'NOVO',
          onTap: () => _selectTemplate('NOVO'),
        ),

        if (_existingProtocols.isNotEmpty) ...[
          const SizedBox(height: 24),

          // Campo de pesquisa
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar protocolo...',
                    hintStyle: TextStyle(color: AppColors.gray[400]),
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon:
                        _searchController.text.isNotEmpty
                            ? IconButton(
                              icon: const Icon(Icons.clear, size: 20),
                              onPressed: () {
                                _searchController.clear();
                              },
                            )
                            : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.gray[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.gray[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.primarySwatch),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Cabeçalho com contador
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Usar protocolo existente como modelo:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.gray[800],
                ),
              ),
              if (_filteredProtocols.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primarySwatch.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_filteredProtocols.length} protocolo${_filteredProtocols.length != 1 ? 's' : ''}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primarySwatch,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 12),

          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(),
              ),
            )
          else if (_filteredProtocols.isEmpty)
            _buildEmptyState()
          else ...[
            // Lista de protocolos
            ..._displayedProtocols.map(
              (protocol) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildProtocolOption(protocol),
              ),
            ),

            // Botão "Ver mais/Ver menos"
            if (_filteredProtocols.length > _initialDisplayCount)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Center(
                  child: TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _showAllProtocols = !_showAllProtocols;
                      });
                    },
                    icon: Icon(
                      _showAllProtocols ? Icons.expand_less : Icons.expand_more,
                      size: 18,
                    ),
                    label: Text(
                      _showAllProtocols
                          ? 'Ver menos'
                          : 'Ver mais (${_filteredProtocols.length - _initialDisplayCount})',
                      style: const TextStyle(fontSize: 14),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primarySwatch,
                    ),
                  ),
                ),
              ),
          ],
        ],
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(Icons.search_off, size: 48, color: AppColors.gray[400]),
          const SizedBox(height: 16),
          Text(
            'Nenhum protocolo encontrado',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.gray[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tente ajustar os termos da busca',
            style: TextStyle(fontSize: 14, color: AppColors.gray[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildProtocolOption(Protocol protocol) {
    final isSelected = widget.selectedTemplate == 'EXISTING_${protocol.id}';

    return Material(
      color:
          isSelected ? AppColors.primarySwatch.withOpacity(0.1) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? AppColors.primarySwatch : AppColors.gray[300]!,
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _selectExistingProtocol(protocol),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      protocol.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color:
                            isSelected
                                ? AppColors.primarySwatch
                                : const Color(0xFF333333),
                      ),
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle,
                      color: AppColors.primarySwatch,
                      size: 20,
                    ),
                ],
              ),
              if (protocol.description?.isNotEmpty == true) ...[
                const SizedBox(height: 4),
                Text(
                  protocol.description!,
                  style: TextStyle(fontSize: 14, color: AppColors.gray[600]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.list_alt, size: 16, color: AppColors.gray[500]),
                  const SizedBox(width: 4),
                  Text(
                    '${protocol.items.length} itens',
                    style: TextStyle(fontSize: 12, color: AppColors.gray[500]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
