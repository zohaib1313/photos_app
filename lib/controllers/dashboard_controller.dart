import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photos_app/common/styles.dart';
import 'package:photos_app/pages/friends_page/friends_page.dart';
import 'package:photos_app/pages/home_page/home_page.dart';
import 'package:photos_app/pages/profile_page/profile_page.dart';

import '../pages/settings_page/settings_page.dart';

class DashBoardController extends GetxController {
  RxBool isLoading = false.obs;

  RxInt selectedIndex = 0.obs;

  final Color activeColor = AppColor.primaryColor;
  final Color inActiveColor = AppColor.greyColor;

  final List<Widget> viewsList = [
    HomePage(),
    FriendsPage(),
    ProfilePage(),
    SettingsPage()
  ];
}
