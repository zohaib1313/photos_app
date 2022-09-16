import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:photos_app/common/user_defaults.dart';
import 'package:photos_app/models/user_model.dart';

class ProfilePageController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController usernameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController userAgeController = TextEditingController();

  RxBool isUpdateModeOn = false.obs;

  void setValuesFromSharedPref() {
    UserModel? userModel = UserDefaults.getUserSession();
    print(
        "https://memory-app34.herokuapp.com${UserDefaults.getUserSession()?.photo}");
    usernameController.text = userModel?.username ?? '-';
    firstNameController.text = userModel?.firstName ?? '-';
    emailController.text = userModel?.email ?? '-';
//    userAgeController.text=UserModel
  }
}
