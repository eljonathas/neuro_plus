import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

/// Centraliza a inicialização do Hive para evitar múltiplas chamadas de init()
class HiveService {
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;

    final appDocDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocDir.path);

    _initialized = true;
  }
}
