import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:photos_app/common/extension.dart';
import 'package:photos_app/models/user_model.dart';
import 'package:photos_app/pages/dashboard_page.dart';

import '../../../../common/loading_widget.dart';
import '../../../../common/spaces_boxes.dart';
import '../../common/app_pop_ups.dart';
import '../../common/app_utils.dart';
import '../../common/common_widgets.dart';
import '../../common/styles.dart';
import '../../controllers/signup_controller.dart';
import '../../my_application.dart';
import '../login_page/login_page.dart';
import 'sign_up_widgets.dart';

class SignupPage extends GetView<SignupController> with SignupWidgetsMixin {
  SignupPage({Key? key}) : super(key: key);
  static const id = '/SignupPage';

  @override
  Widget build(BuildContext context) {
//    controller.isLoading.value = false;
    return Scaffold(
      body: GetX<SignupController>(
          initState: (state) {},
          builder: (_) {
            return SafeArea(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Center(
                        child: Form(
                          key: controller.formKeyUserInfo,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              vSpace,
                              vSpace,
                              GestureDetector(
                                onTap: () async {
                                  AppUtils.showPicker(
                                    onBottomSheetClosed: () {
                                      //  controller.isLoading.value = false;
                                    },
                                    context: context,
                                    onComplete: (File? file) {
                                      if (file != null) {
                                        controller.profileImage.value = file;
                                      }
                                    },
                                  );
                                },
                                child: getImageWidget(controller.profileImage),
                              ),
                              vSpace,
                              vSpace,
                              Text(
                                'SIGN UP',
                                style: AppTextStyles.textStyleBoldSubTitleLarge
                                    .copyWith(fontSize: 50),
                              ),
                              vSpace,
                              vSpace,
                              getTextField(
                                  validate: true,
                                  hintText: 'User name',
                                  controller: controller.usernameController),
                              vSpace,
                              getTextField(
                                  validate: true,
                                  hintText: 'First name',
                                  controller: controller.firstNameController),
                              vSpace,
                              getTextField(
                                  hintText: 'Last name',
                                  validate: true,
                                  controller: controller.lastNameController),
                              vSpace,
                              getTextField(
                                  hintText: 'Age',
                                  validate: true,
                                  controller: controller.ageController),
                              vSpace,
                              getTextField(
                                  hintText: 'Email',
                                  onChanged: (String? value) {
                                    if (value?.toValidEmail() == null) {
                                      print('valid mail');
                                    }
                                  },
                                  controller: controller.emailController,
                                  validator: (String? value) {
                                    return value?.toValidEmail();
                                  }),
                              vSpace,
                              getTextField(
                                  hintText: 'City',
                                  controller: controller.cityController,
                                  validate: true),
                              vSpace,
                              getTextField(
                                  hintText: 'Country',
                                  controller: controller.countryController,
                                  validate: true),
                              vSpace,
                              getTextField(
                                  inputType: TextInputType.phone,
                                  hintText: 'Phone(xxx) xxxxxxx',
                                  inputFormatters: [
                                    /*MaskTextInputFormatter(
                                    mask: '+## (###) #######',
                                    filter: {"#": RegExp(r'[0-9]')},
                                    type: MaskAutoCompletionType.lazy)*/
                                  ],
                                  controller: controller.phoneController),
                              vSpace,
                              Obx(
                                () => MyTextField(
                                  controller: controller.passwordController,
                                  contentPadding: 20,
                                  suffixIconWidet: GestureDetector(
                                      onTap: () {
                                        controller.isObscure.value =
                                            !controller.isObscure.value;
                                      },
                                      child: Icon(controller.isObscure.value
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined)),
                                  hintText: "Password",
                                  focusBorderColor: AppColor.primaryColor,
                                  textColor: AppColor.whiteColor,
                                  hintColor: AppColor.whiteColor,
                                  fillColor: AppColor.alphaGrey,
                                  obsecureText: controller.isObscure.value,
                                  validator: (String? value) =>
                                      value!.toValidPassword(),
                                ),
                              ),
                              vSpace,
                              Obx(
                                () => MyTextField(
                                    controller:
                                        controller.confirmPasswordController,
                                    contentPadding: 20,
                                    suffixIconWidet: GestureDetector(
                                        onTap: () {
                                          controller.isObscure2.value =
                                              !controller.isObscure2.value;
                                        },
                                        child: Icon(controller.isObscure2.value
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined)),
                                    hintText: "Confirm Password",
                                    focusBorderColor: AppColor.primaryColor,
                                    textColor: AppColor.whiteColor,
                                    hintColor: AppColor.whiteColor,
                                    fillColor: AppColor.alphaGrey,
                                    obsecureText: controller.isObscure2.value,
                                    validator: (String? value) {
                                      if ((value ?? '') !=
                                          controller.passwordController.text) {
                                        return 'Password do not match';
                                      }
                                      return null;
                                    }),
                              ),
                              vSpace,
                              vSpace,
                              vSpace,
                              Button(
                                buttonText: "Register",
                                padding: 16,
                                textColor: AppColor.alphaGrey,
                                color: AppColor.primaryColor,
                                onTap: () {
                                  if (controller.profileImage.value != null) {
                                    if (controller.formKeyUserInfo.currentState
                                            ?.validate() ??
                                        false) {
                                      controller.registerAction(
                                          completion: (String message) {
                                        AppPopUps.showDialogContent(
                                            title: 'Success',
                                            onOkPress: () {
                                              Get.offAndToNamed(
                                                  DashboardPage.id);
                                            },
                                            onCancelPress: () {
                                              Get.offAndToNamed(
                                                  DashboardPage.id);
                                            },
                                            description: message,
                                            dialogType: DialogType.SUCCES);
                                      });
                                    }
                                  } else {
                                    AppPopUps.showSnackBar(
                                        message: 'select image',
                                        context: context);
                                  }
                                },
                              ),
                              vSpace,
                              vSpace,
                              Text(
                                "Already have an account?",
                                style: AppTextStyles.textStyleNormalBodyMedium,
                              ),
                              InkWell(
                                onTap: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  Get.offNamed(LoginPage.id);
                                },
                                child: Text(
                                  "Sign in",
                                  style: AppTextStyles.textStyleBoldBodyMedium
                                      .copyWith(
                                          decoration: TextDecoration.underline,
                                          color: AppColor.primaryColor),
                                ),
                              ),
                              vSpace,
                              vSpace,
                              vSpace,
                              vSpace,
                              vSpace,
                              vSpace,
                              vSpace,
                              vSpace,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (controller.isLoading.isTrue) LoadingWidget(),
                ],
              ),
            );
          }),
    );
  }
}
