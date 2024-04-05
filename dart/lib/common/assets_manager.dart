import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

@Singleton()
class AssetsManager {
  Future<String> loadString(String path) {
    return rootBundle.loadString(path);
  }
}
