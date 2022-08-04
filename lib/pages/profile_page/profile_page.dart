import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photos_app/controllers/home_page_controller.dart';
import 'package:photos_app/controllers/profile_page_controller.dart';
import '../../../../common/loading_widget.dart';

class ProfilePage extends GetView<ProfilePageController> {
  ProfilePage({Key? key}) : super(key: key);
  static const id = '/ProfilePage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<ProfilePageController>(
        initState: (state) {},
        builder: (_) {
          return SafeArea(
            child: Stack(
              children: [
                Center(child: Text("profile")),
                if (controller.isLoading.isTrue) LoadingWidget(),
              ],
            ),
          );
        },
      ),
    );
  }
}
