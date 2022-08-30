import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import 'dart:convert' show json;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../common/app_pop_ups.dart';
import '../dio_networking/api_client.dart';
import '../dio_networking/api_response.dart';
import '../dio_networking/api_route.dart';
import '../dio_networking/app_apis.dart';
import '../models/user_login_response_model.dart';

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
      String provider = '',
      required String password}) async {
    isLoading.value = true;

    Map<String, dynamic> body;
    if (provider.isEmpty) {
      body = {
        "email": email,
        "password": password,
      };
    } else {
      body = {"email": email, "u_uid": password, "provider": provider};
    }

    var client = APIClient(isCache: false, baseUrl: ApiConstants.baseUrl);
    client
        .request(
            needToAuthenticate: false,
            route: APIRoute(
              APIType.loginUser,
              body: body,
            ),
            create: () => APIResponse<UserLoginResponseModel>(
                create: () => UserLoginResponseModel()),
            apiFunction: login)
        .then((response) {
      /*    UserLoginResponseModel? userLoginResponseModel = response.response?.data;
      if (userLoginResponseModel != null) {
        UserDefaults.setApiToken(userLoginResponseModel.token ?? '');
        UserDefaults.setIsAdmin(userLoginResponseModel.isAdmin ?? false);

        ///getting user detail from different api
        _getUserDetails(
            id: userLoginResponseModel.id.toString(),
            onComplete: (UserModel user) {
              UserDefaults.saveUserSession(user);
              isLoading.value = false;
              completion(userLoginResponseModel);
            });
      }*/
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
