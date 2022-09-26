import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:photos_app/common/app_pop_ups.dart';
import 'package:photos_app/common/user_defaults.dart';
import 'package:photos_app/dio_networking/api_response.dart';
import 'package:photos_app/models/user_model.dart';
import 'package:dio/dio.dart' as dio;

import '../common/helpers.dart';
import '../dio_networking/api_client.dart';
import 'package:path/path.dart';

import '../dio_networking/api_route.dart';
import '../dio_networking/app_apis.dart';

class ProfilePageController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController usernameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  TextEditingController emailController = TextEditingController();
  TextEditingController userAgeController = TextEditingController();
  TextEditingController userCountryController = TextEditingController();
  TextEditingController userCityController = TextEditingController();
  TextEditingController userPhoneNumberController = TextEditingController();

  RxBool isUpdateModeOn = false.obs;

  Rxn<File?> profileImage = Rxn<File>();

  void setValuesFromSharedPref() {
    UserModel? userModel = UserDefaults.getUserSession();
    print(
        "https://memory-app34.herokuapp.com${UserDefaults.getUserSession()?.photo}");
    usernameController.text = userModel?.username ?? '-';
    firstNameController.text = userModel?.firstName ?? '-';
    emailController.text = userModel?.email ?? '-';
    userAgeController.text = userModel?.age ?? '-';
    userCountryController.text = userModel?.country ?? '-';
    userCityController.text = userModel?.city ?? '-';
    userPhoneNumberController.text = userModel?.phoneNumber ?? '-';
  }

  void updateProfile() async {
    isLoading.value = true;

    Map<String, dynamic> map = {
      "username": usernameController.text.trim(),
      "email": emailController.text.trim(),
      "first_name": firstNameController.text.trim(),
      "last_name": lastNameController.text.trim(),
      "phone_number": userPhoneNumberController.text.trim(),
      "city": userCityController.text.trim(),
      "country": userCountryController.text.trim(),
      "age": userAgeController.text.trim(),
    };

    if (profileImage.value != null) {
      map['photo'] = await dio.MultipartFile.fromFile(profileImage.value!.path,
          filename: basename(profileImage.value!.path));
    }

    var client = APIClient(isCache: false, baseUrl: ApiConstants.baseUrl);
    client
        .request(
            route: APIRoute(
              APIType.updateUserProfile,
              body: dio.FormData.fromMap(map),
            ),
            create: () => APIResponse<UserModel>(create: () => UserModel()),
            apiFunction: updateProfile)
        .then((response) async {
      isLoading.value = false;
      UserModel? userModel = response.response?.data;

      printWrapped("update response ${userModel.toString()}");

      if (userModel != null) {
        await UserDefaults.saveUserSession(userModel);

        ///updating local values from shared pref....
        setValuesFromSharedPref();
      } else {
        AppPopUps.showDialogContent(
            title: 'Error',
            description: 'Failed update user',
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
