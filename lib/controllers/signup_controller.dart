import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../dio_networking/api_client.dart';
import '../common/app_pop_ups.dart';
import '../common/helpers.dart';
import '../dio_networking/api_response.dart';
import '../dio_networking/api_route.dart';
import '../dio_networking/app_apis.dart';
import '../models/user_login_response_model.dart';
import '../models/user_model.dart';

class SignupController extends GetxController {
  RxBool isLoading = false.obs;

  ////.................user information......................///
  var formKeyUserInfo = GlobalKey<FormState>();
  var isObscure = false.obs;
  var isObscure2 = false.obs;

  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController cnicController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  Rxn<File?> profileImage = Rxn<File>();

  ////.................address information......................///

  TextEditingController addressCityController = TextEditingController();
  TextEditingController areasTextController = TextEditingController();
  TextEditingController addressDescription = TextEditingController();

  var isSignUpAsAgency = false.obs;

//...............agency info...............//
  TextEditingController companyNameController = TextEditingController();
  TextEditingController companyMailController = TextEditingController();
  TextEditingController companyFaxController = TextEditingController();
  TextEditingController companyPhoneController = TextEditingController();
  TextEditingController companyDescription = TextEditingController();

  var agencyInfoFormKey = GlobalKey<FormState>();
  Rxn<File?> agencyLogo = Rxn<File>();

  void registerAction({required mainCompletion}) {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  Future<void> _registerUser({required completion}) async {
    printWrapped("registering user");
    isLoading.value = true;
    var data = dio.FormData.fromMap({
      "photo": await dio.MultipartFile.fromFile(profileImage.value!.path,
          filename: "profile_image.png"),
      "address": addressDescription.text,
      "area": areasTextController.text,
      "city": addressCityController.text,
      "cnic": cnicController.text,
      "email": emailController.text,
      "first_name": firstNameController.text,
      "last_name": lastNameController.text,
      "phone_number": phoneController.text,
      "username": usernameController.text,
      "password": passwordController.text,
      "isAgent": false
    });
    var client = APIClient(isCache: false, baseUrl: ApiConstants.baseUrl);
    client
        .request(
            needToAuthenticate: false,
            route: APIRoute(
              APIType.registerUser,
              body: data,
            ),
            create: () => APIResponse<UserModel>(create: () => UserModel()),
            apiFunction: _registerUser)
        .then((response) async {
      printWrapped(
          "registering user response ${response.response?.data.toString()}");
    }).catchError((error) {
      print(error);
      isLoading.value = false;
      AppPopUps.showDialogContent(
          title: 'Error',
          description: error.toString(),
          dialogType: DialogType.ERROR);
      return Future.value(null);
    });
  }
}
