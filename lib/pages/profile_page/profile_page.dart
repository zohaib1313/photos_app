import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photos_app/common/common_widgets.dart';
import 'package:photos_app/common/helpers.dart';
import 'package:photos_app/controllers/profile_page_controller.dart';

import '../../../../common/loading_widget.dart';
import '../../common/spaces_boxes.dart';

class ProfilePage extends GetView<ProfilePageController> {
  ProfilePage({Key? key}) : super(key: key);
  static const id = '/ProfilePage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: 'Profile', goBack: false),
      body: GetX<ProfilePageController>(
        initState: (state) {},
        builder: (_) {
          return SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
                        vSpace,
                        NetworkCircularImage(
                          url: 'url',
                          radius: 50,
                        ),
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
}
