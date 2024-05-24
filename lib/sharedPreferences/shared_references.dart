import 'package:shared_preferences/shared_preferences.dart';

class DataSharedPreferences {
  static late SharedPreferences _preferences;

  static Future init() async {
    print(
        "calling getInstance of sharedpref-------------------------------------------");
    _preferences = await SharedPreferences.getInstance();
  }

  static Future setBoolData(String keyValue, bool value) async {
    await _preferences.setBool(keyValue, value);
  }

  static bool getsBoolData(String keyValue) {
    bool V = _preferences.getBool(keyValue) ?? false;
    return V;
  }

  static Future setIntData(String keyValue, int value) async {
    await _preferences.setInt(keyValue, value);
  }

  static int getsIntData(String keyValue) {
    int V = _preferences.getInt(keyValue) ?? 0;
    return V;
  }
}
