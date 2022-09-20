import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photos_app/common/styles.dart';
import 'package:photos_app/common/user_defaults.dart';

class ThemeService {
  static Future<bool> getIsDarkThemeSet() async =>
      await UserDefaults.getTheme() ?? false;

  static Future<bool> saveTheme({required bool isDark}) async =>
      await UserDefaults.setTheme(isDark) ?? false;

  static void switchTheme() async {
    var res = await getIsDarkThemeSet();
    Get.changeThemeMode(!res ? ThemeMode.light : ThemeMode.dark);
    saveTheme(isDark: !res);
  }
}

class MyThemes {
  static final light = ThemeData.light().copyWith(
      /* backgroundColor: Colors.white,
    bottomAppBarColor: Colors.cyan,
    */ /* primaryColor: AppColor.primaryColor,
    primaryColorDark: context.theme.primaryColor,
    hintColor: context.theme.hintColor,*/ /*
    cardColor: Colors.white,
    shadowColor: Colors.green,
    buttonTheme: const ButtonThemeData(
      buttonColor: Colors.cyan,
      textTheme: ButtonTextTheme.primary,
    ),*/
      );
  static final dark = ThemeData.dark().copyWith(
      /*  buttonTheme: const ButtonThemeData(
      buttonColor: Colors.deepPurple,
      textTheme: ButtonTextTheme.primary,
    ),*/
      );
}
