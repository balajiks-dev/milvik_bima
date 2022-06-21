import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';

// SharedPreferences
class SPUtil {
  static SPUtil? _singleton;
  static SharedPreferences? _prefs;
  static final Lock _lock = Lock();

  static Future<SPUtil> getInstance() async {
    if (_singleton == null) {
      await _lock.synchronized(() async {
        if (_singleton == null) {
          // keep local instance till it is fully initialized.
          final singleton = SPUtil._();
          await singleton._init();
          _singleton = singleton;
        }
      });
    }
    return _singleton!;
  }

  SPUtil._();

  Future _init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // put object
  static Future<bool> putObject(String key, Object value) {
    return _prefs!.setString(key, json.encode(value));
  }

  // get string
  static String getString(String key, {String defValue = ''}) {
    if (_prefs == null) return defValue;
    return _prefs!.getString(key) ?? defValue;
  }

  // put string
  static Future<bool> putString(String key, String value) async {
    return _prefs!.setString(key, value);
  }

  // get bool
  static bool getBool(String key, {bool defValue = false}) {
    if (_prefs == null) return defValue;
    return _prefs!.getBool(key) ?? defValue;
  }

  // put bool
  static Future<bool> putBool(String key, {bool value = false}) {
    return _prefs!.setBool(key, value);
  }

  // get int
  static int getInt(String key, {int defValue = 0}) {
    if (_prefs == null) return defValue;
    return _prefs!.getInt(key) ?? defValue;
  }

  // put int.
  static Future<bool> putInt(String key, int value) {
    return _prefs!.setInt(key, value);
  }

  // get double
  static double getDouble(String key, {double defValue = 0.0}) {
    if (_prefs == null) return defValue;
    return _prefs!.getDouble(key) ?? defValue;
  }

  // put double
  static Future<bool> putDouble(String key, double value) {
    return _prefs!.setDouble(key, value);
  }

  // get string list
  static List<String> getStringList(String key,
      {List<String> defValue = const []}) {
    if (_prefs == null) return defValue;
    return _prefs!.getStringList(key) ?? defValue;
  }

  // put string list
  static Future<bool> putStringList(String key, List<String> value) {
    return _prefs!.setStringList(key, value);
  }

  // clear
  static Future<bool> clear() {
    return _prefs!.clear();
  }

  // clear a string
  static Future<bool> clearString(String key) {
    return _prefs!.remove(key);
  }

  //Sp is initialized
  static bool isInitialized() {
    return _prefs != null;
  }
}
