import 'package:get/get.dart';
import 'package:photos_app/controllers/dashboard_controller.dart';
import 'package:photos_app/controllers/friends_page_controller.dart';
import 'package:photos_app/controllers/history_controller.dart';
import 'package:photos_app/controllers/home_page_controller.dart';
import 'package:photos_app/controllers/login_controller.dart';
import 'package:photos_app/controllers/notes_controller.dart';
import 'package:photos_app/controllers/notification_controller.dart';
import 'package:photos_app/controllers/private_folder_controller.dart';
import 'package:photos_app/controllers/profile_page_controller.dart';
import 'package:photos_app/controllers/reminder_controller.dart';
import 'package:photos_app/controllers/signup_controller.dart';
import 'package:photos_app/pages/dashboard_page.dart';
import 'package:photos_app/pages/home_page/history_page/history_page.dart';
import 'package:photos_app/pages/home_page/notes/notes_page.dart';
import 'package:photos_app/pages/home_page/private_folder/private_folder_view_page.dart';
import 'package:photos_app/pages/home_page/reminders/reminders_page.dart';
import 'package:photos_app/pages/login_page/login_page.dart';
import 'package:photos_app/pages/notifications/notifications_page.dart';
import 'package:photos_app/pages/sign_up/sign_up_page.dart';

import '../controllers/settings_page_controller.dart';

appRoutes() {
  return <GetPage>[
    GetPage(
        name: LoginPage.id,
        page: () => LoginPage(),
        binding: BindingsBuilder(() {
          Get.lazyPut<LoginController>(() => LoginController());
        })),

    GetPage(
        name: SignupPage.id,
        page: () => SignupPage(),
        binding: BindingsBuilder(() {
          Get.lazyPut<SignupController>(() => SignupController());
        })),

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

    ///NOTES
    GetPage(
        name: NotesPage.id,
        page: () => NotesPage(),
        binding: BindingsBuilder(() {
          Get.lazyPut<NotesController>(() => NotesController());
        })),
    GetPage(
        name: PrivateFolderViewPage.id,
        page: () => PrivateFolderViewPage(),
        binding: BindingsBuilder(() {
          Get.lazyPut<PrivateFolderController>(() => PrivateFolderController());
        })),
  ];
}
