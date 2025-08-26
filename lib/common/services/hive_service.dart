import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveService {
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;

    if (kIsWeb) {
      Hive.init('neuro_plus_web');
    } else {
      final appDocDir = await getApplicationDocumentsDirectory();
      Hive.init(appDocDir.path);
    }

    _initialized = true;
  }
}
