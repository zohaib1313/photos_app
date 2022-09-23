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

  final List<Widget> viewsList = [
    HomePage(),
    const FriendsPage(),
    ProfilePage(),
    SettingsPage()
  ];
}
