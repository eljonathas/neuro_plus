import 'package:flutter/material.dart';
import 'package:neuro_plus/models/protocol.dart';
import 'package:neuro_plus/screens/protocols/protocols_empty_state.dart';

class ProtocolsScreen extends StatefulWidget {
  const ProtocolsScreen({super.key});

  @override
  State<ProtocolsScreen> createState() => _ProtocolsScreenState();
}

class _ProtocolsScreenState extends State<ProtocolsScreen> {
  List<Protocol> protocols = [];

  @override
  void initState() {
    super.initState();
    // TODO: load protocols from local storage
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: ProtocolsEmptyState()));
  }
}
