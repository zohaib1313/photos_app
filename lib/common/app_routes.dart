import 'package:get/get.dart';
import 'package:photos_app/controllers/dashboard_controller.dart';
import 'package:photos_app/controllers/friends_page_controller.dart';
import 'package:photos_app/controllers/home_page_controller.dart';
import 'package:photos_app/controllers/profile_page_controller.dart';
import 'package:photos_app/pages/dashboard_page.dart';

import '../controllers/settngs_page_controller.dart';

appRoutes() {
  return <GetPage>[
    GetPage(
      name: DashboardPage.id,
      page: () => DashboardPage(),
      binding: BindingsBuilder(
        () {
          Get.put(DashBoardController());

          ///
          Get.put(HomePageController());
          Get.put(FriendsPageController());
          Get.put(ProfilePageController());
          Get.put(SettingsPageController());
        },
      ),
    ),
  ];
}
