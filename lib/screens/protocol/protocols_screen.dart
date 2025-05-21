import 'package:flutter/material.dart';
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
  List<Protocol> _protocols = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProtocols();
  }

  Future<void> _loadProtocols() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final protocols = ProtocolService.getAllProtocols();
      setState(() {
        _protocols = protocols;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar protocolos: $e')),
      );
    }
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
        _loadProtocols();
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
    ).then((_) => _loadProtocols());
  }

  void _shareProtocol(Protocol protocol) async {
    // Compartilhar via QR Code
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
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _protocols.isEmpty
              ? _buildEmptyState()
              : _buildProtocolsList(),
    );
  }

  Widget _buildEmptyState() {
    return Column(
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
          child: Center(
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
            onPressed: () => _navigateToCreateProtocol(),
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
    );
  }

  Widget _buildProtocolsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Seus protocolos',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.qr_code_scanner, color: AppColors.primarySwatch),
                  onPressed: () => _scanQrCode(),
                  tooltip: 'Escanear QR Code',
                ),
                IconButton(
                  icon: Icon(Icons.add, color: AppColors.primarySwatch),
                  onPressed: () => _navigateToCreateProtocol(),
                  tooltip: 'Novo protocolo',
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _protocols.length,
          itemBuilder: (context, index) {
            final protocol = _protocols[index];
            return _buildProtocolCard(protocol);
          },
        ),
      ],
    );
  }

  Widget _buildProtocolCard(Protocol protocol) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: InkWell(
        onTap: () => _editProtocol(protocol),
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
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.share, color: AppColors.primarySwatch),
                        onPressed: () => _shareProtocol(protocol),
                        tooltip: 'Compartilhar',
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(8),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => _deleteProtocol(protocol),
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
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
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
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  // Mostrar categorias
                  if (protocol.categories.isNotEmpty)
                    Wrap(
                      spacing: 4,
                      children: protocol.categories.take(2).map((category) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primarySwatch.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.primarySwatch,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToCreateProtocol() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateProtocolScreen(),
      ),
    ).then((_) => _loadProtocols());
  }

  void _scanQrCode() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ScanQrScreen(),
      ),
    ).then((_) => _loadProtocols());
  }
} 