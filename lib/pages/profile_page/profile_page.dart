import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photos_app/common/helpers.dart';
import 'package:photos_app/controllers/profile_page_controller.dart';

import '../../../../common/loading_widget.dart';
import '../../common/spaces_boxes.dart';
import '../sign_up/sign_up_widgets.dart';

class ProfilePage extends GetView<ProfilePageController>
    with SignupWidgetsMixin {
  ProfilePage({Key? key}) : super(key: key);
  static const id = '/ProfilePage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: 'Profile', goBack: false),
      body: GetX<ProfilePageController>(
        initState: (state) {
          controller.setValuesFromSharedPref();
        },
        builder: (_) {
          return SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Center(
                    child: Column(
                      children: [
                        vSpace,
                        /*NetworkCircularImage(
                          url:
                              "${ApiConstants.baseUrl}${UserDefaults.getUserSession()?.photo}",
                          radius: 60,
                        ),*/
                        vSpace,
                        vSpace,
                        getTextField(
                            validate: true,
                            enabled: controller.isUpdateModeOn.value,
                            hintText: 'User name',
                            controller: controller.usernameController),
                        vSpace,
                        getTextField(
                            validate: true,
                            enabled: controller.isUpdateModeOn.value,
                            hintText: 'First name',
                            controller: controller.firstNameController),
                        vSpace,
                        getTextField(
                            hintText: 'Email',
                            enabled: controller.isUpdateModeOn.value,
                            controller: controller.emailController,
                            validate: true),
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
