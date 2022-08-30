import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photos_app/common/common_widgets.dart';
import 'package:photos_app/common/helpers.dart';
import 'package:photos_app/common/user_defaults.dart';
import 'package:photos_app/controllers/profile_page_controller.dart';
import 'package:photos_app/dio_networking/app_apis.dart';

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
                        NetworkCircularImage(
                          url:
                              "${ApiConstants.baseUrl}${UserDefaults.getUserSession()?.photo}",
                          radius: 60,
                        ),
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
                            hintText: 'Last name',
                            validate: true,
                            enabled: controller.isUpdateModeOn.value,
                            controller: controller.lastNameController),
                        vSpace,
                        getTextField(
                            hintText: 'Email',
                            enabled: controller.isUpdateModeOn.value,
                            controller: controller.emailController,
                            validate: true),
                        vSpace,
                        getTextField(
                            hintText: 'City',
                            enabled: controller.isUpdateModeOn.value,
                            controller: controller.cityController,
                            validate: true),
                        vSpace,
                        getTextField(
                            hintText: 'Address',
                            enabled: controller.isUpdateModeOn.value,
                            controller: controller.addressController,
                            validate: true),
                        vSpace,
                        getTextField(
                            inputType: TextInputType.phone,
                            hintText: 'Phone(xxx) xxxxxxx',
                            enabled: controller.isUpdateModeOn.value,
                            inputFormatters: [
                              /*MaskTextInputFormatter(
                                    mask: '+## (###) #######',
                                    filter: {"#": RegExp(r'[0-9]')},
                                    type: MaskAutoCompletionType.lazy)*/
                            ],
                            controller: controller.phoneController),
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
