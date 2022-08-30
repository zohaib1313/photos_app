import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'helpers.dart';

class UserDefaults {
  static SharedPreferences? sharedPreferences;
  static SharedPreferences? mapPreference;

  static Future<SharedPreferences?> getPref() async {
    sharedPreferences ??= await SharedPreferences.getInstance();
    sharedPreferences ??= await SharedPreferences.getInstance();
    return sharedPreferences;
  }

  static Future<bool> saveWeatherUnit(String value) async {
    return await sharedPreferences?.setString('weatherUnit', value) ?? false;
  }

  static Future<String?> getWeatherUnit() async {
    return sharedPreferences?.getString('weatherUnit');
  }

  static String? getApiToken() {
    return sharedPreferences?.getString('ApiToken');
  }

  static setApiToken(String value) async {
    return await sharedPreferences?.setString('ApiToken', "token $value");
  }

  static setCurrentUserId(String value) {
    return sharedPreferences?.setString('userId', value);
  }

  static String? getCurrentUserId() {
    return sharedPreferences?.getString('userId');
  }
}
