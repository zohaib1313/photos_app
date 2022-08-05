import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photos_app/controllers/home_page_controller.dart';
import 'package:photos_app/controllers/settings_page_controller.dart';
import '../../../../common/loading_widget.dart';

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
                Center(child: Text("SettingsPageController")),
                if (controller.isLoading.isTrue) LoadingWidget(),
              ],
            ),
          );
        },
      ),
    );
  }
}
