import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:photos_app/common/user_defaults.dart';
import 'package:photos_app/models/user_model.dart';

class ProfilePageController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController usernameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  RxBool isUpdateModeOn = false.obs;

  void setValuesFromSharedPref() {
    UserModel? userModel = UserDefaults.getUserSession();
    usernameController.text = userModel?.username ?? '-';
    firstNameController.text = userModel?.firstName ?? '-';
    lastNameController.text = userModel?.lastName ?? '-';
    emailController.text = userModel?.email ?? '-';
    phoneController.text = userModel?.phoneNumber ?? '-';
    cityController.text = userModel?.city ?? '-';
    addressController.text = userModel?.address ?? '-';
  }
}
