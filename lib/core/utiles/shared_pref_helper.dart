import 'dart:developer';

import 'package:my_app/core/utiles/shared_pref_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  static late SharedPreferences? prefs;
  Future getInit() async {
    prefs = await SharedPreferences.getInstance();
  }

  //get keys
  getKeys() {
    return prefs?.getKeys();
  }

  //remove
  remove(key) {
    prefs?.remove(key);
  }

  writeData(String key, String value) async {
    await prefs!.setString(key, value);
    log('pref writeData $value');
  }

  //bool
  writeBoolData(String key, bool value) async {
    await prefs!.setBool(key, value);
  }

  readBoolData(String key) {
    bool? value = prefs!.getBool(key);
    log('$value');
    return value ?? false;
  }

  readData(String key) {
    String? value = prefs!.getString(key);
    log('$value');
    return value;
  }

  deleteData(String key) async {
    await prefs!.remove(key);
  }

  bool getIsLoggedIn() {
    bool? value = prefs!.getBool(SharedPreferencesKeys.isLoggedIn);
    if (value != null) {
      return value;
    } else {
      return false;
    }
  }

  //clear all data
  clearAll() async {
    await prefs!.clear();
    log('cleared all data');
  }
}
