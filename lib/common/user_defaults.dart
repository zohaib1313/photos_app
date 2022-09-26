import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/user_model.dart';
import 'helpers.dart';

class UserDefaults {
  static SharedPreferences? sharedPreferences;
  static SharedPreferences? mapPreference;

  static Future<bool?> clearAll() async {
    return await sharedPreferences?.clear();
  }

  static Future<SharedPreferences?> getPref() async {
    sharedPreferences ??= await SharedPreferences.getInstance();
    return sharedPreferences;
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

  static Future<bool?> saveUserSession(UserModel userModel) async {
    String user = json.encode(userModel.toJson());
    setCurrentUserId(userModel.id!.toString());
    if ((userModel.token ?? '').isNotEmpty) {
      setApiToken(userModel.token ?? '');
    }
    return await getPref().then((value) => value?.setString('userData', user));
  }

  static UserModel? getUserSession() {
    UserModel? user;
    if (sharedPreferences!.getString('userData') != null) {
      Map<String, dynamic> json =
          jsonDecode(sharedPreferences!.getString('userData')!);
      user = UserModel.fromJson(json);
      printWrapped(user.toString());
    }
    return user;
  }

  static Future<bool?> getTheme() async {
    return getPref().then((value) => value?.getBool('themeMode'));
  }

  static Future<bool?> setTheme(bool isDarkTheme) async {
    return getPref().then((value) => value?.setBool('themeMode', isDarkTheme));
  }
}
