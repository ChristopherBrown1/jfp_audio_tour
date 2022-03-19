import 'dart:async' show Future;
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static late final SharedPreferences _prefsInstance;

  static const String _automaticDetectionKey = 'automaticDetection';
  static const String _ipKey = 'ipKey';



  // call this method from iniState() function of mainApp().
  static Future<SharedPreferences> init() async {
    _prefsInstance = await SharedPreferences.getInstance();
    return _prefsInstance;
  }

  static bool getAutomaticDetection() {
    return _prefsInstance.getBool(_automaticDetectionKey) ?? true;
  }

  static Future<bool> setAutomaticDetection(bool value) async {
    return _prefsInstance.setBool(_automaticDetectionKey, value);
  }

  static String getIP() {
    return _prefsInstance.getString(_ipKey) ?? "";
  }

  static Future<bool> setIP(String value) async {
    return _prefsInstance.setString(_ipKey, value);
  }

}