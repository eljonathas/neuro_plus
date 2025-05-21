import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:neuro_plus/models/protocol.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ProtocolService {
  static const String _boxName = 'protocols';
  static bool _initialized = false;
  
  // Cache de protocolos para evitar leituras repetidas
  static List<Protocol>? _protocolsCache;
  static final Map<String, Protocol> _protocolsByIdCache = {};

  static Future<void> init() async {
    if (_initialized) return;

    final appDocDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocDir.path);
    
    Hive.registerAdapter(ProtocolAdapter());
    Hive.registerAdapter(ProtocolItemAdapter());
    Hive.registerAdapter(ResponseTypeAdapter());

    await Hive.openBox<Protocol>(_boxName);
    
    _initialized = true;
  }

  // Limpar cache quando os dados mudarem
  static void _clearCache() {
    _protocolsCache = null;
    _protocolsByIdCache.clear();
  }

  static List<Protocol> getAllProtocols() {
    // Verificar cache primeiro
    if (_protocolsCache != null) {
      return List.from(_protocolsCache!);
    }
    
    // Garantir que o Hive esteja inicializado
    if (!_initialized) {
      throw Exception('ProtocolService não foi inicializado. Chame ProtocolService.init() primeiro.');
    }
    
    final box = Hive.box<Protocol>(_boxName);
    final protocols = box.values.toList();
    
    // Atualizar cache
    _protocolsCache = protocols;
    
    // Atualizar cache por ID
    for (final protocol in protocols) {
      _protocolsByIdCache[protocol.id] = protocol;
    }
    
    return List.from(protocols);
  }

  static Protocol? getProtocolById(String id) {
    // Verificar cache primeiro
    if (_protocolsByIdCache.containsKey(id)) {
      return _protocolsByIdCache[id];
    }
    
    // Garantir que o Hive esteja inicializado
    if (!_initialized) {
      throw Exception('ProtocolService não foi inicializado. Chame ProtocolService.init() primeiro.');
    }
    
    final box = Hive.box<Protocol>(_boxName);
    final protocol = box.values.cast<Protocol?>().firstWhere(
      (protocol) => protocol?.id == id,
      orElse: () => null,
    );
    
    // Atualizar cache se encontrado
    if (protocol != null) {
      _protocolsByIdCache[id] = protocol;
    }
    
    return protocol;
  }

  static Future<void> saveProtocol(Protocol protocol) async {
    // Garantir que o Hive esteja inicializado
    if (!_initialized) {
      throw Exception('ProtocolService não foi inicializado. Chame ProtocolService.init() primeiro.');
    }
    
    final box = Hive.box<Protocol>(_boxName);
    await box.put(protocol.id, protocol);
    
    // Atualizar cache
    _clearCache();
  }

  static Future<void> updateProtocol(Protocol protocol) async {
    await saveProtocol(protocol);
  }

  static Future<void> deleteProtocol(String id) async {
    // Garantir que o Hive esteja inicializado
    if (!_initialized) {
      throw Exception('ProtocolService não foi inicializado. Chame ProtocolService.init() primeiro.');
    }
    
    final box = Hive.box<Protocol>(_boxName);
    await box.delete(id);
    
    // Atualizar cache
    _clearCache();
  }

  // Método assíncrono para compartilhar protocolo como JSON
  static Future<void> shareProtocolAsJson(Protocol protocol, BuildContext context) async {
    try {
      // Executar a serialização em um isolate
      final jsonData = await compute(_protocolToJson, protocol);
      
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/protocol_${protocol.id}.json');
      
      await file.writeAsString(jsonData);
      
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

  // Função estática para ser executada em um isolate
  static String _protocolToJson(Protocol protocol) {
    return jsonEncode(protocol.toJson());
  }

  // Método assíncrono para importar protocolo de JSON
  static Future<Protocol?> importProtocolFromJson(String jsonString) async {
    try {
      // Executar o parsing e a conversão em um isolate
      final protocol = await compute(_jsonToProtocol, jsonString);
      await saveProtocol(protocol);
      return protocol;
    } catch (e) {
      debugPrint('Erro ao importar protocolo: $e');
      return null;
    }
  }

  // Função estática para ser executada em um isolate
  static Protocol _jsonToProtocol(String jsonString) {
    final Map<String, dynamic> data = jsonDecode(jsonString);
    return Protocol.fromJson(data);
  }

  // Método assíncrono para exportar todos os protocolos como JSON
  static Future<String> exportAllProtocolsAsJson() async {
    final protocols = getAllProtocols();
    // Executar a serialização em um isolate
    return compute(_protocolsListToJson, protocols);
  }

  // Função estática para ser executada em um isolate
  static String _protocolsListToJson(List<Protocol> protocols) {
    final List<Map<String, dynamic>> jsonList = protocols.map((p) => p.toJson()).toList();
    return jsonEncode(jsonList);
  }

  static String generateQrCodeData(Protocol protocol) {
    final jsonData = jsonEncode(protocol.toJson());
    return jsonData;
  }

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