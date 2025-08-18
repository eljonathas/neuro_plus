import 'package:hive/hive.dart';
import 'package:neuro_plus/common/services/hive_service.dart';
import 'package:neuro_plus/models/protocol.dart';

class ProtocolsService {
  static bool initialized = false;
  static const String _boxName = 'protocols';

  static Future<void> init() async {
    if (initialized) return;

    await HiveService.init();

    Hive.registerAdapter(ProtocolAdapter());
    Hive.registerAdapter(ProtocolItemAdapter());
    Hive.registerAdapter(ResponseTypeAdapter());

    if (Hive.isBoxOpen(_boxName)) {
      await Hive.box(_boxName).close();
    }

    await Hive.openBox<Protocol>(_boxName);

    initialized = true;
  }

  static Future<void> close() async {
    await Hive.close();

    initialized = false;
  }

  static List<Protocol> getAllProtocols() {
    final box = Hive.box<Protocol>(_boxName);
    return box.values.toList();
  }

  static Protocol? getProtocolById(String id) {
    final box = Hive.box<Protocol>(_boxName);
    return box.get(id);
  }

  static Future<void> addProtocol(Protocol protocol) async {
    final box = Hive.box<Protocol>(_boxName);
    await box.put(protocol.id, protocol);
  }

  static Future<void> updateProtocol(Protocol protocol) async {
    final box = Hive.box<Protocol>(_boxName);
    await box.put(protocol.id, protocol);
  }

  static Future<void> deleteProtocol(String id) async {
    final box = Hive.box<Protocol>(_boxName);
    await box.delete(id);
  }
}
