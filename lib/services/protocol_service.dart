import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:neuro_plus/models/protocol.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

class ProtocolService {
  static const String _boxName = 'protocols';
  static bool _initialized = false;

  /// Inicializa o Hive e registra os adaptadores
  static Future<void> init() async {
    if (_initialized) return;

    // Inicializa o Hive
    final appDocDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocDir.path);
    
    // Registra os adaptadores
    Hive.registerAdapter(ProtocolAdapter());
    Hive.registerAdapter(ProtocolItemAdapter());
    Hive.registerAdapter(ResponseTypeAdapter());

    // Abre a box
    await Hive.openBox<Protocol>(_boxName);
    
    _initialized = true;
  }

  /// Obtém todos os protocolos
  static List<Protocol> getAllProtocols() {
    final box = Hive.box<Protocol>(_boxName);
    return box.values.toList();
  }

  /// Obtém um protocolo pelo ID
  static Protocol? getProtocolById(String id) {
    final box = Hive.box<Protocol>(_boxName);
    return box.values.firstWhere((protocol) => protocol.id == id, orElse: () => null as Protocol);
  }

  /// Salva um protocolo
  static Future<void> saveProtocol(Protocol protocol) async {
    final box = Hive.box<Protocol>(_boxName);
    await box.put(protocol.id, protocol);
  }

  /// Atualiza um protocolo
  static Future<void> updateProtocol(Protocol protocol) async {
    await saveProtocol(protocol);
  }

  /// Exclui um protocolo
  static Future<void> deleteProtocol(String id) async {
    final box = Hive.box<Protocol>(_boxName);
    await box.delete(id);
  }

  /// Compartilha um protocolo como JSON via share
  static Future<void> shareProtocolAsJson(Protocol protocol, BuildContext context) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/protocol_${protocol.id}.json');
      
      // Converte para JSON e salva no arquivo
      final jsonData = jsonEncode(protocol.toJson());
      await file.writeAsString(jsonData);
      
      // Compartilha o arquivo
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Protocolo: ${protocol.name}',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao compartilhar: $e')),
      );
    }
  }

  /// Importa um protocolo a partir de um arquivo JSON
  static Future<Protocol?> importProtocolFromJson(String jsonString) async {
    try {
      final Map<String, dynamic> data = jsonDecode(jsonString);
      final protocol = Protocol.fromJson(data);
      await saveProtocol(protocol);
      return protocol;
    } catch (e) {
      debugPrint('Erro ao importar protocolo: $e');
      return null;
    }
  }

  /// Exporta todos os protocolos como JSON
  static Future<String> exportAllProtocolsAsJson() async {
    final protocols = getAllProtocols();
    final List<Map<String, dynamic>> jsonList = protocols.map((p) => p.toJson()).toList();
    return jsonEncode(jsonList);
  }

  /// Gera uma string para o QR Code
  static String generateQrCodeData(Protocol protocol) {
    final jsonData = jsonEncode(protocol.toJson());
    return jsonData;
  }

  /// Importa um protocolo a partir de dados de QR Code
  static Future<Protocol?> importProtocolFromQrCode(String qrData, BuildContext context) async {
    try {
      return await importProtocolFromJson(qrData);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao importar protocolo do QR Code: $e')),
      );
      return null;
    }
  }
}

// Estes adaptadores são necessários para o Hive, mas serão gerados pelo build_runner
class ProtocolAdapter extends TypeAdapter<Protocol> {
  @override
  final int typeId = 0;

  @override
  Protocol read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Protocol(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String?,
      categories: (fields[3] as List).cast<String>(),
      items: (fields[4] as List).cast<ProtocolItem>(),
      template: fields[5] as String,
      createdAt: fields[6] as DateTime,
      updatedAt: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Protocol obj) {
    writer.writeByte(8);
    writer.writeByte(0);
    writer.write(obj.id);
    writer.writeByte(1);
    writer.write(obj.name);
    writer.writeByte(2);
    writer.write(obj.description);
    writer.writeByte(3);
    writer.write(obj.categories);
    writer.writeByte(4);
    writer.write(obj.items);
    writer.writeByte(5);
    writer.write(obj.template);
    writer.writeByte(6);
    writer.write(obj.createdAt);
    writer.writeByte(7);
    writer.write(obj.updatedAt);
  }
}

class ProtocolItemAdapter extends TypeAdapter<ProtocolItem> {
  @override
  final int typeId = 1;

  @override
  ProtocolItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProtocolItem(
      id: fields[0] as String,
      title: fields[1] as String,
      instruction: fields[2] as String?,
      responseType: fields[3] as ResponseType,
      options: (fields[4] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ProtocolItem obj) {
    writer.writeByte(5);
    writer.writeByte(0);
    writer.write(obj.id);
    writer.writeByte(1);
    writer.write(obj.title);
    writer.writeByte(2);
    writer.write(obj.instruction);
    writer.writeByte(3);
    writer.write(obj.responseType);
    writer.writeByte(4);
    writer.write(obj.options);
  }
}

class ResponseTypeAdapter extends TypeAdapter<ResponseType> {
  @override
  final int typeId = 2;

  @override
  ResponseType read(BinaryReader reader) {
    return ResponseType.values[reader.readByte()];
  }

  @override
  void write(BinaryWriter writer, ResponseType obj) {
    writer.writeByte(obj.index);
  }
} 