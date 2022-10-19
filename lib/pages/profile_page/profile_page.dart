import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:photos_app/common/helpers.dart';
import 'package:photos_app/common/styles.dart';
import 'package:photos_app/controllers/profile_page_controller.dart';

import '../../../../common/loading_widget.dart';
import '../../common/common_widgets.dart';
import '../../common/spaces_boxes.dart';
import '../../common/user_defaults.dart';
import '../../my_application.dart';
import '../sign_up/sign_up_widgets.dart';

class ProfilePage extends GetView<ProfilePageController>
    with SignupWidgetsMixin {
  ProfilePage({Key? key}) : super(key: key);
  static const id = '/ProfilePage';
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetX<ProfilePageController>(
      initState: (_) {
        controller.setValuesFromSharedPref();
      },
      builder: (logic) {
        return Scaffold(
            appBar: myAppBar(
                backGroundColor: AppColor.primaryColor,
                title: 'Profile',
                goBack: false,
                actions: [
                  Row(
                    children: [
                      Text(
                        'Edit',
                        style: AppTextStyles.textStyleBoldBodyMedium,
                      ),
                      hSpace,
                      CupertinoSwitch(
                          value: controller.isUpdateModeOn.value,
                          onChanged: (v) {
                            controller.isUpdateModeOn.toggle();
                            FocusScope.of(context).requestFocus();
                          }),
                    ],
                  )
                ]),
            body: SafeArea(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Center(
                      child: Form(
                        key: _globalKey,
                        child: Column(
                          children: [
                            vSpace,
                            NetworkCircularImage(
                              url: UserDefaults.getUserSession()?.photo ?? '',
                              radius: 60,
                            ),
                            vSpace,
                            vSpace,
                            vSpace,
                            vSpace,
                            vSpace,
                            vSpace,
                            vSpace,
                            getTextField(
                                validate: true,
                                enabled: false,
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
                                validate: true,
                                enabled: controller.isUpdateModeOn.value,
                                hintText: 'Age',
                                inputType: TextInputType.number,
                                controller: controller.userAgeController),
                            vSpace,
                            /* getTextField(
                                validate: true,
                                enabled: controller.isUpdateModeOn.value,
                                hintText: 'Country',
                                controller: controller.userCountryController),
                            vSpace,
                            getTextField(
                                validate: true,
                                enabled: controller.isUpdateModeOn.value,
                                hintText: 'City',
                                controller: controller.userCityController),
                            vSpace,
                         */
                            getTextField(
                                validate: true,
                                enabled: controller.isUpdateModeOn.value,
                                hintText: 'Phone',
                                controller:
                                    controller.userPhoneNumberController),
                            vSpace,
                            getTextField(
                                hintText: 'Email',
                                enabled: false,
                                controller: controller.emailController,
                                validate: true),
                            vSpace,
                            vSpace,
                            vSpace,
                            if (controller.isUpdateModeOn.value)
                              Button(
                                leftPadding: 200.w,
                                rightPading: 200.w,
                                buttonText: 'Update',
                                onTap: () {
                                  if (_globalKey.currentState?.validate() ??
                                      false) {
                                    controller.updateProfile();
                                  }
                                },
                              ),
                            vSpace,
                            vSpace,
                            vSpace,
                            vSpace,
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (controller.isLoading.isTrue) LoadingWidget(),
                ],
              ),
            ));
      },
    );
  }
}
