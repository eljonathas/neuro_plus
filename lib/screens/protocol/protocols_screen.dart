import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:neuro_plus/core/main_layout.dart';
import 'package:neuro_plus/core/config/theme.dart';
import 'package:neuro_plus/models/protocol.dart';
import 'package:neuro_plus/screens/protocol/create_protocol_screen.dart';
import 'package:neuro_plus/screens/protocol/edit_protocol_screen.dart';
import 'package:neuro_plus/screens/protocol/protocol_qr_screen.dart';
import 'package:neuro_plus/screens/protocol/scan_qr_screen.dart';
import 'package:neuro_plus/services/protocol_service.dart';

class ProtocolsScreen extends StatefulWidget {
  const ProtocolsScreen({super.key});

  @override
  State<ProtocolsScreen> createState() => _ProtocolsScreenState();
}

class _ProtocolsScreenState extends State<ProtocolsScreen> {
  // Future para carregar protocolos de forma assíncrona
  late Future<List<Protocol>> _protocolsFuture;

  // Memoize text styles
  static const _titleStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Color(0xFF333333),
  );

  @override
  void initState() {
    super.initState();
    _protocolsFuture = _fetchProtocols();
  }

  // Carrega os protocolos de forma assíncrona, mas sem isolate
  Future<List<Protocol>> _fetchProtocols() async {
    try {
      return ProtocolService.getAllProtocols();
    } catch (e) {
      debugPrint("Erro ao carregar protocolos: $e");
      rethrow;
    }
  }

  // Método para atualizar a lista de protocolos
  Future<void> _refreshProtocols() async {
    setState(() {
      _protocolsFuture = _fetchProtocols();
    });
  }

  void _deleteProtocol(Protocol protocol) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir protocolo'),
        content: Text('Deseja realmente excluir o protocolo "${protocol.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await ProtocolService.deleteProtocol(protocol.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Protocolo excluído com sucesso!')),
        );
        _refreshProtocols();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao excluir protocolo: $e')),
        );
      }
    }
  }

  void _editProtocol(Protocol protocol) {
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
    ).then((_) => _refreshProtocols());
  }

  void _shareProtocol(Protocol protocol) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProtocolQrScreen(protocol: protocol),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: "Protocolos",
      navIndex: 2,
      onNavTap: (index) {
        // Handle navigation
      },
      child: RefreshIndicator(
        onRefresh: _refreshProtocols,
        child: FutureBuilder<List<Protocol>>(
          future: _protocolsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            
            if (snapshot.hasError) {
              return Center(
                child: Text('Erro ao carregar protocolos: ${snapshot.error}'),
              );
            }

            final protocols = snapshot.data ?? [];
            
            if (protocols.isEmpty) {
              return _buildEmptyState();
            }
            
            return _buildProtocolsList(protocols);
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.primarySwatch.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Icon(
                  Icons.assignment_outlined,
                  size: 36,
                  color: AppColors.primarySwatch,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Crie seu primeiro protocolo',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Para começar a acompanhar pacientes, primeiro você precisa criar um protocolo. Personalize seus formulários de acordo com as necessidades da sua prática clínica.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: _navigateToCreateProtocol,
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
                  'Novo protocolo',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProtocolsList(List<Protocol> protocols) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Seus protocolos', style: _titleStyle),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.qr_code_scanner, color: AppColors.primarySwatch),
                  onPressed: _scanQrCode,
                  tooltip: 'Escanear QR Code',
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: AppColors.primarySwatch),
                  onPressed: _navigateToCreateProtocol,
                  tooltip: 'Novo protocolo',
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: protocols.length,
            itemBuilder: (context, index) {
              final protocol = protocols[index];
              return ProtocolCard(
                key: ValueKey(protocol.id),
                protocol: protocol,
                onEdit: () => _editProtocol(protocol),
                onShare: () => _shareProtocol(protocol),
                onDelete: () => _deleteProtocol(protocol),
              );
            },
          ),
        ),
      ],
    );
  }

  void _navigateToCreateProtocol() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateProtocolScreen(),
      ),
    ).then((_) => _refreshProtocols());
  }

  void _scanQrCode() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ScanQrScreen(),
      ),
    ).then((_) => _refreshProtocols());
  }
}

// Widget separado para cartão de protocolo
class ProtocolCard extends StatelessWidget {
  final Protocol protocol;
  final VoidCallback onEdit;
  final VoidCallback onShare;
  final VoidCallback onDelete;

  static const _nameStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Color(0xFF333333),
  );
  
  static const _descriptionStyle = TextStyle(
    fontSize: 14,
    color: Color(0xFF666666),
  );
  
  static const _metaTextStyle = TextStyle(
    fontSize: 14,
    color: Color(0xFF666666),
  );
  
  static const _categoryStyle = TextStyle(
    fontSize: 12,
    color: AppColors.primarySwatch,
  );

  const ProtocolCard({
    super.key,
    required this.protocol,
    required this.onEdit,
    required this.onShare,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Usar RepaintBoundary para isolar repaints
    return RepaintBoundary(
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey[200]!),
        ),
        child: InkWell(
          onTap: onEdit,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        protocol.name,
                        style: _nameStyle,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.share, color: AppColors.primarySwatch),
                          onPressed: onShare,
                          tooltip: 'Compartilhar',
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(8),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: onDelete,
                          tooltip: 'Excluir',
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(8),
                        ),
                      ],
                    ),
                  ],
                ),
                if (protocol.description != null && protocol.description!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    protocol.description!,
                    style: _descriptionStyle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${protocol.items.length} ${protocol.items.length == 1 ? 'item' : 'itens'}',
                      style: _metaTextStyle,
                    ),
                    if (protocol.categories.isNotEmpty)
                      _buildCategories(protocol.categories),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategories(List<String> categories) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: categories.take(2).map((category) {
        return Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primarySwatch.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              category,
              style: _categoryStyle,
            ),
          ),
        );
      }).toList(),
    );
  }
} 