import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'dart:io';

class PlatformUtils {
  static Future<String> getApplicationDocumentsDirectory() async {
    if (kIsWeb) {
      // Для веба возвращаем фиктивный путь
      return 'web_documents';
    } else {
      final directory = await path_provider.getApplicationDocumentsDirectory();
      return directory.path;
    }
  }

  static bool get isWeb => kIsWeb;
  static bool get isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);
}