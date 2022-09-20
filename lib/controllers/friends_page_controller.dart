import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:photos_app/common/user_defaults.dart';
import 'package:photos_app/models/friends_list_model_response.dart';

import '../common/app_pop_ups.dart';
import '../dio_networking/api_client.dart';
import '../dio_networking/api_response.dart';
import '../dio_networking/api_route.dart';
import '../dio_networking/app_apis.dart';

class FriendsPageController extends GetxController {
  RxBool isLoading = false.obs;
  int pageToLoad = 1;
  bool hasNewPage = false;
  TextEditingController searchController = TextEditingController();
  RxList<FriendsModel> friendsList = <FriendsModel>[].obs;
  RxList<FriendsModel> filteredList = <FriendsModel>[].obs;
  ScrollController listViewController = ScrollController();

  void loadFriendsList({
    bool showAlert = false,
  }) {
    Map<String, dynamic> body = {
      'page': pageToLoad,
      'user_id': UserDefaults.getCurrentUserId(),
    };
    isLoading.value = true;
    APIClient(isCache: false, baseUrl: ApiConstants.baseUrl)
        .request(
            route: APIRoute(
              APIType.getAllFriends,
              body: body,
            ),
            create: () => APIResponse<FriendsListModelResponse>(
                create: () => FriendsListModelResponse()),
            apiFunction: loadFriendsList)
        .then((response) {
      isLoading.value = false;

      FriendsListModelResponse? responseModel = response.response?.data;

      if (responseModel != null) {
        if (responseModel.next != null) {
          pageToLoad++;
        }
        friendsList.addAll(responseModel.friendsList ?? []);
        filteredList.addAll(friendsList);
      } else {
        if (showAlert) {
          AppPopUps.showDialogContent(
              title: 'Alert',
              description: 'Empty directory',
              dialogType: DialogType.WARNING);
        }
      }
    }).catchError((error) {
      isLoading.value = false;
      if (showAlert) {
        AppPopUps.showDialogContent(
            title: 'Error',
            description: error.toString(),
            dialogType: DialogType.ERROR);
      }
      return Future.value(null);
    });
  }
}
