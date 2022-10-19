import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photos_app/common/styles.dart';
import 'package:photos_app/common/user_defaults.dart';
import 'package:photos_app/controllers/home_page_controller.dart';
import 'package:photos_app/controllers/settings_page_controller.dart';
import 'package:photos_app/pages/login_page/login_page.dart';
import '../../../../common/loading_widget.dart';
import '../../common/spaces_boxes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class SettingsPage extends GetView<SettingsPageController> {
  SettingsPage({Key? key}) : super(key: key);
  static const id = '/SettingsPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<SettingsPageController>(
        initState: (state) {},
        builder: (_) {
          return SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        vSpace,
                        vSpace,
                        _getRowItem(
                            icon: Icon(Icons.notification_important_outlined),
                            title: "Notifications",
                            onTap: () {}),
                        vSpace,
                        _getRowItem(
                            icon: Icon(Icons.color_lens_outlined),
                            title: "Themes",
                            onTap: () {}),
                        vSpace,
                        _getRowItem(
                            icon: Icon(Icons.font_download_outlined),
                            title: "Fonts",
                            onTap: () {}),
                        vSpace,
                        _getRowItem(
                            icon: Icon(Icons.card_giftcard_outlined),
                            title: "Gift App",
                            onTap: () {}),
                        vSpace,
                        _getRowItem(
                            icon: Icon(Icons.help_center_outlined),
                            title: "Help",
                            onTap: () {}),
                        vSpace,
                        _getRowItem(
                            icon: Icon(Icons.info_outline),
                            title: "About",
                            onTap: () {}),
                        vSpace,
                        _getRowItem(
                            icon: Icon(Icons.logout_outlined),
                            title: "Logout",
                            onTap: () {
                              FirebaseMessaging.instance.deleteToken();
                              UserDefaults.clearAll();
                              Get.offAndToNamed(LoginPage.id);
                            }),
                        vSpace,
                      ],
                    ),
                  ),
                ),
                if (controller.isLoading.isTrue) LoadingWidget(),
              ],
            ),
          );
        },
      ),
    );
  }

  _getRowItem(
      {required Widget icon,
      required String title,
      required Null Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            icon,
            hSpace,
            Flexible(
              child: Text(title, style: AppTextStyles.textStyleBoldBodyMedium),
            )
          ],
        ),
      ),
    );
  }
}
