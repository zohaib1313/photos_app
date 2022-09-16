import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:photos_app/common/app_pop_ups.dart';
import 'package:photos_app/common/app_utils.dart';
import 'package:photos_app/common/constants.dart';
import 'package:photos_app/controllers/shared_folder_controller.dart';
import 'package:photos_app/models/my_data_model.dart';
import 'package:photos_app/my_application.dart';
import 'package:photos_app/pages/home_page/private_folder/private_folder_view_page.dart';

import '../common/user_defaults.dart';
import '../models/user_model.dart';
import 'mixins/private_folder_network_repo_controller_mixin.dart';

class HomePageController extends GetxController
    with PrivateFolderNetworkContentControllerMixin {
  UserModel? user = UserDefaults.getUserSession();

  TextEditingController searchController = TextEditingController();
}
