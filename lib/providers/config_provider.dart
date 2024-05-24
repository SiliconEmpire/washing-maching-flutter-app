import 'package:flutter/material.dart';

class ConfigurationProvider extends ChangeNotifier {
  int countDown = 5;

  bool isWashing = true;

  Future<void> prefSetters(String key, int value) async {
    // DataSharedPreferences.setIntData(key, value);
    notifyListeners();
  }

  int prefGetter(String key) {
    // return DataSharedPreferences.getsIntData(key);
    return 0;
  }
}
