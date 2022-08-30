import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:photos_app/common/extension.dart';
import 'package:photos_app/pages/dashboard_page.dart';

import '../../../../common/common_widgets.dart';
import '../../../../common/loading_widget.dart';
import '../../../../common/styles.dart';
import '../../common/spaces_boxes.dart';
import '../../controllers/login_controller.dart';
import '../../models/user_login_response_model.dart';

class LoginPage extends GetView<LoginController> {
  LoginPage({Key? key}) : super(key: key);
  static const id = '/LoginPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<LoginController>(initState: (state) {
        controller.emailController.clear();
        controller.passwordController.clear();
        // controller.onInit();
      }, builder: (_) {
        return SafeArea(
          child: Stack(
            children: [
              Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Image.asset(
                              "assets/images/logo.png",
                              height: 200,
                              width: 200,
                            ),
                          ),
                          vSpace,
                          Text(
                            "Login to continue",
                            style: AppTextStyles.textStyleBoldSubTitleLarge,
                          ),
                          vSpace,
                          vSpace,
                          MyTextField(
                              controller: controller.emailController,
                              hintText: "Email",
                              contentPadding: 20 /* context.height * 0.04*/,
                              focusBorderColor: AppColor.primaryBlueDarkColor,
                              textColor: AppColor.blackColor,
                              hintColor: AppColor.blackColor,
                              fillColor: AppColor.alphaGrey,
                              validator: (String? value) =>
                                  value!.toValidEmail()),
                          vSpace,
                          Obx(
                            () => MyTextField(
                              controller: controller.passwordController,
                              contentPadding: 20 /* context.height * 0.04*/,
                              suffixIconWidet: GestureDetector(
                                  onTap: () {
                                    controller.isObscure.value =
                                        !controller.isObscure.value;
                                  },
                                  child: Icon(controller.isObscure.value
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined)),
                              hintText: "Password",
                              focusBorderColor: AppColor.primaryBlueDarkColor,
                              textColor: AppColor.blackColor,
                              hintColor: AppColor.blackColor,
                              fillColor: AppColor.alphaGrey,
                              obsecureText: controller.isObscure.value,
                              validator: (String? value) =>
                                  value!.toValidPassword(),
                            ),
                          ),
                          vSpace,
                          vSpace,
                          Button(
                            buttonText: "login",
                            padding: 16 /*context.height * 0.04*/,
                            textColor: AppColor.whiteColor,
                            color: AppColor.primaryBlueDarkColor,
                            onTap: () async {
                              if (controller.formKey.currentState!.validate()) {
                                FocusManager.instance.primaryFocus?.unfocus();
                                controller.login(
                                  email: controller.emailController.text.trim(),
                                  password:
                                      controller.passwordController.text.trim(),
                                  completion: (UserLoginResponseModel?
                                      userLoginResponseModel) {
                                    Get.offAndToNamed(DashboardPage.id);
                                  },
                                );
                              }
                            },
                          ),
                          vSpace,
                          vSpace,
                          vSpace,
                          vSpace,
                          Text(
                            "Don't have an account?",
                            style: AppTextStyles.textStyleNormalBodyMedium,
                          ),
                          InkWell(
                            onTap: () {
                              // Get.offNamed(SignupPage.id);
                            },
                            child: Text(
                              "Sign up",
                              style: AppTextStyles.textStyleBoldBodyMedium
                                  .copyWith(
                                      decoration: TextDecoration.underline,
                                      color: AppColor.primaryColor),
                            ),
                          ),
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
