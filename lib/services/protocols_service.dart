
import 'package:hive/hive.dart';
import 'package:neuro_plus/models/protocol.dart';
import 'package:path_provider/path_provider.dart';

class ProtocolService {
  static const String _boxName = 'protocols';
  static bool _initialized = false;
  
  static Future<void> init() async {
    if (_initialized) return;

    final appDocDir = await getApplicationDocumentsDirectory();

    Hive.init(appDocDir.path);
    
    Hive.registerAdapter(ProtocolAdapter());
    Hive.registerAdapter(ProtocolItemAdapter());
    Hive.registerAdapter(ResponseTypeAdapter());

    await Hive.openBox<Protocol>(_boxName);
    
    _initialized = true;
  }

  static Future<void> saveProtocol(Protocol protocol) async {
    final box = await Hive.openBox<Protocol>(_boxName);
    await box.put(protocol.id, protocol);
  }

  static Future<void> deleteProtocol(String id) async {
    final box = await Hive.openBox<Protocol>(_boxName);
    await box.delete(id);
  }

  static Future<List<Protocol>> getProtocols() async {
    final box = await Hive.openBox<Protocol>(_boxName); 
    return box.values.toList();
  }

  static Future<Protocol?> getProtocol(String id) async {
    final box = await Hive.openBox<Protocol>(_boxName);
    return box.get(id);
  }

  static Future<void> updateProtocol(Protocol protocol) async {
    final box = await Hive.openBox<Protocol>(_boxName);
    await box.put(protocol.id, protocol);
  }

  static Future<void> clearProtocols() async {
    final box = await Hive.openBox<Protocol>(_boxName);
    await box.clear();
  }

  static Future<void> close() async {
    final box = await Hive.openBox<Protocol>(_boxName);
    await box.close();
  }
}
