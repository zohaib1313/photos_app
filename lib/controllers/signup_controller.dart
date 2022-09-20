import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:photos_app/common/user_defaults.dart';

import '../../../dio_networking/api_client.dart';
import '../common/app_pop_ups.dart';
import '../common/app_utils.dart';
import '../common/helpers.dart';
import '../dio_networking/api_response.dart';
import '../dio_networking/api_route.dart';
import '../dio_networking/app_apis.dart';
import '../models/user_model.dart';

class SignupController extends GetxController {
  RxBool isLoading = false.obs;

  ////.................user information......................///
  var formKeyUserInfo = GlobalKey<FormState>();
  var isObscure = true.obs;
  var isObscure2 = true.obs;

  TextEditingController usernameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  TextEditingController countryController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  Rxn<File?> profileImage = Rxn<File>();

  Future<void> registerAction({required completion}) async {
    FocusManager.instance.primaryFocus?.unfocus();
    printWrapped("registering user");
    isLoading.value = true;
    bool isEmailExist = await AppUtils.checkIfEmailAlreadyExists(
        email: emailController.text.trim());
    isLoading.value = false;

    if (isEmailExist) {
      AppPopUps.showDialogContent(
          title: 'Error',
          description: 'This Email Already Exists',
          dialogType: DialogType.ERROR);
      return;
    }

    isLoading.value = true;
    var data = dio.FormData.fromMap({
      "photo": await dio.MultipartFile.fromFile(profileImage.value!.path,
          filename: basename(profileImage.value!.path)),
      "username": usernameController.text.trim(),
      "email": emailController.text.trim(),
      "password": passwordController.text.trim(),
      "first_name": firstNameController.text.trim(),
      "last_name": lastNameController.text.trim(),
      "phone_number": phoneController.text.trim(),
      "city": cityController.text.trim(),
      "country": countryController.text.trim(),
      "age": ageController.text.trim(),
      "user_type": 1,
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
            apiFunction: registerAction)
        .then((response) async {
      isLoading.value = false;
      UserModel? userModel = response.response?.data;
      printWrapped("registering user response ${userModel.toString()}");

      if (userModel != null) {
        await UserDefaults.saveUserSession(userModel);
        completion('User created');
      } else {
        AppPopUps.showDialogContent(
            title: 'Error',
            description: 'Failed to signup',
            dialogType: DialogType.ERROR);
      }
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
