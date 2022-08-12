import 'package:get/get.dart';
import 'package:photos_app/controllers/dashboard_controller.dart';
import 'package:photos_app/controllers/friends_page_controller.dart';
import 'package:photos_app/controllers/history_controller.dart';
import 'package:photos_app/controllers/home_page_controller.dart';
import 'package:photos_app/controllers/notification_controller.dart';
import 'package:photos_app/controllers/profile_page_controller.dart';
import 'package:photos_app/controllers/reminder_controller.dart';
import 'package:photos_app/pages/dashboard_page.dart';
import 'package:photos_app/pages/home_page/history_page/history_page.dart';
import 'package:photos_app/pages/home_page/reminders/reminders_page.dart';
import 'package:photos_app/pages/notifications/notifications_page.dart';

import '../controllers/settings_page_controller.dart';

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

    ///notifications///
    GetPage(
        name: NotificationsPage.id,
        page: () => const NotificationsPage(),
        binding: BindingsBuilder(() {
          Get.lazyPut<NotificationsController>(() => NotificationsController());
        })),

    ///history///
    GetPage(
        name: HistoryPage.id,
        page: () => HistoryPage(),
        binding: BindingsBuilder(() {
          Get.lazyPut<HistoryController>(() => HistoryController());
        })),

    ///reminder///
    GetPage(
        name: ReminderPage.id,
        page: () => ReminderPage(),
        binding: BindingsBuilder(() {
          Get.lazyPut<ReminderController>(() => ReminderController());
        })),
  ];
}
