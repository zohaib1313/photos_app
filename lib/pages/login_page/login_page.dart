import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:photos_app/common/extension.dart';
import 'package:photos_app/models/user_model.dart';
import 'package:photos_app/pages/dashboard_page.dart';
import 'package:photos_app/pages/sign_up/sign_up_page.dart';

import '../../../../common/common_widgets.dart';
import '../../../../common/loading_widget.dart';
import '../../../../common/styles.dart';
import '../../common/spaces_boxes.dart';
import '../../controllers/login_controller.dart';
import '../../my_application.dart';

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
                            hintText: "User name",
                            contentPadding: 20 /* context.height * 0.04*/,
                            focusBorderColor: context.theme.primaryColor,
                            textColor: context.theme.cardColor,
                            hintColor: context.theme.cardColor,
                            fillColor: context.theme.hintColor,
                            validator: (String? value) {
                              if ((value ?? '').isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                          ),
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
                              focusBorderColor: context.theme.primaryColor,
                              textColor: context.theme.cardColor,
                              hintColor: context.theme.cardColor,
                              fillColor: context.theme.hintColor,
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
                            textColor: myContext!.theme.hintColor,
                            color: context.theme.primaryColor,
                            onTap: () async {
                              //todo

                              if (controller.formKey.currentState!.validate()) {
                                FocusManager.instance.primaryFocus?.unfocus();
                                controller.login(
                                  email: controller.emailController.text.trim(),
                                  password:
                                      controller.passwordController.text.trim(),
                                  completion:
                                      (UserModel? userLoginResponseModel) {},
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
                              Get.offNamed(SignupPage.id);
                            },
                            child: Text(
                              "Sign up",
                              style: AppTextStyles.textStyleBoldBodyMedium
                                  .copyWith(
                                      decoration: TextDecoration.underline,
                                      color: context.theme.primaryColor),
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
