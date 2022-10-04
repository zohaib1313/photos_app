import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:photos_app/controllers/mixins/shared_folders_network_repo_mixin.dart';
import 'package:photos_app/models/friends_list_model_response.dart';
import 'package:photos_app/models/groups_response_model.dart';

import '../common/user_defaults.dart';
import '../models/user_model.dart';
import 'mixins/private_folder_network_repo_controller_mixin.dart';

class HomePageController extends GetxController
    with
        PrivateFolderNetworkContentControllerMixin,
        SharedReceivedDataNetworkRepoMixin {
  UserModel? user = UserDefaults.getUserSession();

  TextEditingController searchController = TextEditingController();
}
