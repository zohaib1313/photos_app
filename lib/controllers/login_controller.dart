import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:photos_app/models/user_model.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import 'dart:convert' show json;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../common/app_pop_ups.dart';
import '../common/helpers.dart';
import '../common/user_defaults.dart';
import '../dio_networking/api_client.dart';
import '../dio_networking/api_response.dart';
import '../dio_networking/api_route.dart';
import '../dio_networking/app_apis.dart';
import '../pages/dashboard_page.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  final formKey = GlobalKey<FormState>();
  final isObscure = true.obs;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String emailForSocial = '';
  String passwordForSocial = '';

  login(
      {required completion,
      required String email,
      required String password}) async {
    isLoading.value = true;

    Map<String, dynamic> body = {"username": email, "password": password};

    var client = APIClient(isCache: false, baseUrl: ApiConstants.baseUrl);
    client
        .request(
            needToAuthenticate: false,
            route: APIRoute(
              APIType.loginUser,
              body: body,
            ),
            create: () => APIResponse<UserModel>(create: () => UserModel()),
            apiFunction: login)
        .then((response) async {
      UserModel? userModel = response.response?.data;
      printWrapped("registering user response ${userModel.toString()}");

      if (userModel != null) {
        await UserDefaults.saveUserSession(userModel);
        completion(userModel);
        Get.offAndToNamed(DashboardPage.id);
      } else {
        AppPopUps.showDialogContent(
            title: 'Error',
            description: 'Failed to signin',
            dialogType: DialogType.ERROR);
      }
    }).catchError((error) {
      isLoading.value = false;
      AppPopUps.showDialogContent(
          title: 'Error',
          description: error.toString(),
          dialogType: DialogType.ERROR);
      return Future.value(null);
    });
  }
}
