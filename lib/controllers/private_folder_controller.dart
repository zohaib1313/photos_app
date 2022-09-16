import 'package:get/get.dart';

import '../common/user_defaults.dart';
import '../models/my_data_model.dart';
import 'mixins/private_folder_network_repo_controller_mixin.dart';

class PrivateFolderController extends GetxController
    with PrivateFolderNetworkContentControllerMixin {}
